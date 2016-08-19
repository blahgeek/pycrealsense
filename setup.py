#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# @Author: BlahGeek
# @Date:   2016-08-01
# @Last Modified by:   BlahGeek
# @Last Modified time: 2016-08-02

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy

ext_modules = [
    Extension('realsense',
              sources=['src/realsense_c.pxd', 'src/realsense.pyx', 'src/realsense_enums.pxi'],
              libraries=['realsense',],
              include_dirs=[numpy.get_include()]),
]

setup(
    name = 'pycrealsense',
    install_requires=['numpy', ],
    cmdclass = {'build_ext': build_ext},
    ext_modules = ext_modules,
)
