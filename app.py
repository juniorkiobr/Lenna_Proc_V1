# create an 680x680 screen

import math
import sys
import os
import threading
import numpy as np
import cv2
from time import strftime, gmtime, localtime, sleep

from PyQt6.QtCore import QObject, pyqtSignal, pyqtSlot
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtQuick import QQuickWindow


class NoiseGenerator:
    def __init__(self):
        pass

    def gaussian_noise(self, mean, var):
        sigma = var ** 0.5
        image = cv2.imread('./UI/images/lenna.png')
        row, col, ch = image.shape
        print(f'row:{row} col:{col} ch:{ch}')
        gauss = np.random.normal(mean, sigma, (row, col, ch))
        # print(f'gauss:{gauss}')
        gauss = gauss.reshape(row, col, ch).astype(np.uint8)
        noise_image = cv2.add(image, gauss)
        cv2.imwrite('./UI/images/Noise.png', gauss)
        cv2.imwrite('./UI/images/Noise1.png', gauss)
        cv2.imwrite('./UI/images/LennaResult.png', noise_image)
        cv2.imwrite('./UI/images/LennaResult1.png', noise_image)

    def floyd_steinberg_dither(self, qnt_colors):
        # image = cv2.imread('./UI/images/lenna.png', cv2.IMREAD_GRAYSCALE)
        image = cv2.imread('./UI/images/lenna.png')

        # cv2.imwrite('./UI/images/lennaGray.png', image)

        arr = np.array(image, dtype=float)
        height, width, ch = arr.shape
        for y in range(height):
            for x in range(width):
                old_pixel = arr[y, x]

                # Realiza a busca em cada canal do RGB
                for i in range(ch):
                    # Encontra um novo valor para o pixel
                    new_pixel = self.find_closest_color(
                        old_pixel[i], qnt_colors)

                    arr[y, x, i] = new_pixel
                    # Retira o erro de quantização para cada pixel
                    quant_error = old_pixel[i] - new_pixel

                    if x + 1 < width:
                        image[y, x + 1, i] += quant_error * \
                            0.4375  # right, 7 / 16
                    if (y + 1 < height) and (x + 1 < width):
                        image[y + 1, x + 1, i] += quant_error * \
                            0.0625  # right, down, 1 / 16
                    if y + 1 < height:
                        image[y + 1, x, i] += quant_error * \
                            0.3125  # down, 5 / 16
                    if (x - 1 >= 0) and (y + 1 < height):
                        image[y + 1, x - 1, i] += quant_error * \
                            0.1875  # left, down, 3 / 16

        cv2.imwrite('./UI/images/FloydSteinberg.png', arr)

    def find_closest_color(self, pixel, qnt_colors):
        return np.round(qnt_colors * pixel / 255) * (255 / qnt_colors)

    def gaussian_remove(self, filterStr=10, searchWin=21, templateWin=7, colorStr=10):
        lennaResult = cv2.imread('./UI/images/LennaResult.png')
        denoised = cv2.fastNlMeansDenoisingColored(
            lennaResult, None, templateWin, searchWin, filterStr, colorStr)
        cv2.imwrite('./UI/images/Denoised.png', denoised)
        cv2.imwrite('./UI/images/Denoised1.png', denoised)


gen = NoiseGenerator()


class Backend(QObject):

    def __init__(self):
        QObject.__init__(self)
        # self.timeChanged = None
        self.time = strftime("%H:%M:%S", localtime())

    updated = pyqtSignal(str, arguments=['updater'])

    def updater(self):
        self.updated.emit(self.time_changed())

    @pyqtSlot(float, float)
    def onMediaUpdate(self, media=0.0, variacao=0.2):
        print(media, variacao)
        global gen
        # gen.gaussian_noise(media, variacao)
        gen.floyd_steinberg_dither()

    @pyqtSlot(int, int, int, int)
    def onFilterUpdate(self, filterStr=10, searchWin=21, templateWin=7, colorStr=10):
        print(filterStr, searchWin, templateWin, colorStr)
        global gen
        gen.gaussian_remove(filterStr, searchWin, templateWin, colorStr)

    def bootUp(self):
        t_thread = threading.Thread(target=self._bootUp)
        t_thread.daemon = True
        t_thread.start()

    def _bootUp(self):
        while True:
            self.updater()
            sleep(0.1)

    def time_changed(self):
        return strftime("%H:%M:%S", localtime())


QQuickWindow.setSceneGraphBackend('software')

app = QGuiApplication(sys.argv)
curr_time = strftime("%H:%M:%S", localtime())


def init_qml():
    engine = QQmlApplicationEngine()
    engine.quit.connect(app.quit)
    engine.load('./UI/main.qml')
    back_end = Backend()
    print(engine.rootObjects())
    engine.rootObjects()[0].setProperty('backend', back_end)
    # engine.rootObjects()[0].setProperty('time', curr_time)
    back_end.bootUp()

    sys.exit(app.exec())


# gen.gaussian_noise(0, 0.2)
# gen.gaussian_remove()
gen.floyd_steinberg_dither(2)
# init_qml()
