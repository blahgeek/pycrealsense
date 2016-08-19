# -*- coding: utf-8 -*-

from realsense_c cimport *
include "realsense_enums.pxi"

import numpy as np
cimport numpy as np
from cpython cimport PyObject, Py_INCREF
cdef extern from "numpy/arrayobject.h":
    object PyArray_NewFromDescr(object subtype, np.dtype descr,
                                int nd, np.npy_intp* dims,
                                np.npy_intp* strides,
                                void* data, int flags, object obj)
    void * PyArray_GetPtr(object aobj, np.npy_intp* ind)
np.import_array()


class ApiError(Exception):
    pass

cdef class ApiBase:
    cdef rs_error * error
    def _check_error(self):
        cdef rs_error * error_copy = self.error
        self.error = NULL
        if error_copy != NULL:
            raise ApiError(rs_get_error_message(error_copy))

cdef class Device(ApiBase):

    cdef rs_device * dev
    cdef object _stream_formats

    def __init__(self):
        self._stream_formats = dict()

    def get_name(self):
        cdef char * ret
        with nogil:
            ret = rs_get_device_name(self.dev, &self.error)
        self._check_error()
        return ret

    def get_serial(self):
        cdef char * ret
        with nogil:
            ret = rs_get_device_serial(self.dev, &self.error)
        self._check_error()
        return ret

    def get_firmware_version(self):
        cdef char * ret
        with nogil:
            ret = rs_get_device_firmware_version(self.dev, &self.error)
        self._check_error()
        return ret

    def get_extrinsics(self, rs_stream from_stream, rs_stream to_stream):
        cdef rs_extrinsics extrinsics
        with nogil:
            rs_get_device_extrinsics(self.dev, from_stream, to_stream,
                                     &extrinsics, &self.error)
        self._check_error()
        return {
            'rotation': extrinsics.rotation,
            'translation': extrinsics.translation,
        }

    def get_depth_scale(self):
        cdef float ret
        with nogil:
            ret = rs_get_device_depth_scale(self.dev, &self.error)
        self._check_error()
        return ret

    def supports_option(self, rs_option option):
        cdef bint ret
        with nogil:
            ret = rs_device_supports_option(self.dev, option, &self.error)
        self._check_error()
        return ret

    def get_stream_mode_count(self, rs_stream stream):
        cdef int ret
        with nogil:
            ret = rs_get_stream_mode_count(self.dev, stream, &self.error)
        self._check_error()
        return ret

    def get_stream_mode(self, rs_stream stream, index):
        cdef int _index = index
        cdef int width, height, framerate
        cdef rs_format format
        with nogil:
            rs_get_stream_mode(self.dev, stream, _index, &width, &height,
                               &format, &framerate, &self.error)
        self._check_error()
        return {
            'width': width,
            'height': height,
            'framerate': framerate,
            'format': format,
        }

    def _set_stream_format(self, rs_stream stream):
        self._stream_formats[stream] = {
            'width': self.get_stream_width(stream),
            'height': self.get_stream_height(stream),
            'format': self.get_stream_format(stream),
        }

    def enable_stream(self, rs_stream stream,
                      width, height, rs_format format, framerate):
        cdef int _width = width
        cdef int _height = height
        cdef int _framerate = framerate
        with nogil:
            rs_enable_stream(self.dev, stream,
                             _width, _height, format, _framerate, &self.error)
        self._check_error()
        self._set_stream_format(stream)

    def enable_stream_preset(self, rs_stream stream, rs_preset preset):
        with nogil:
            rs_enable_stream_preset(self.dev, stream, preset, &self.error)
        self._check_error()
        self._set_stream_format(stream)

    def disable_stream(self, rs_stream stream):
        with nogil:
            rs_disable_stream(self.dev, stream, &self.error)
        self._check_error()

    def is_stream_enabled(self, rs_stream stream):
        cdef bint ret
        with nogil:
            ret = rs_is_stream_enabled(self.dev, stream, &self.error)
        self._check_error()
        return ret

    def get_stream_width(self, rs_stream stream):
        cdef int ret
        with nogil:
            ret = rs_get_stream_width(self.dev, stream, &self.error)
        self._check_error()
        return ret

    def get_stream_height(self, rs_stream stream):
        cdef int ret
        with nogil:
            ret = rs_get_stream_height(self.dev, stream, &self.error)
        self._check_error()
        return ret

    def get_stream_format(self, rs_stream stream):
        cdef rs_format ret
        with nogil:
            ret = rs_get_stream_format(self.dev, stream, &self.error)
        self._check_error()
        return ret

    def get_stream_framerate(self, rs_stream stream):
        cdef int ret
        with nogil:
            ret = rs_get_stream_framerate(self.dev, stream, &self.error)
        self._check_error()
        return ret

    def get_stream_intrinsics(self, rs_stream stream):
        cdef rs_intrinsics intrinsics
        with nogil:
            rs_get_stream_intrinsics(self.dev, stream, &intrinsics, &self.error)
        self._check_error()
        return {
            'width': intrinsics.width,
            'height': intrinsics.height,
            'ppx': intrinsics.ppx,
            'ppy': intrinsics.ppy,
            'fx': intrinsics.fx,
            'fy': intrinsics.fy,
            'model': intrinsics.model,
            'coeffs': intrinsics.coeffs,
        }

    def start(self):
        with nogil:
            rs_start_device(self.dev, &self.error)
        self._check_error()

    def stop(self):
        self._stream_formats = dict()
        with nogil:
            rs_stop_device(self.dev, &self.error)
        self._check_error()

    def is_streaming(self):
        cdef bint ret
        with nogil:
            ret = rs_is_device_streaming(self.dev, &self.error)
        self._check_error()
        return ret

    def get_option_range(self, rs_option option):
        cdef double min, max, step
        with nogil:
            rs_get_device_option_range(self.dev, option,
                                       &min, &max, &step, &self.error)
        self._check_error()
        return {
            'min': min,
            'max': max,
            'step': step,
        }

    def get_option(self, rs_option option):
        cdef double ret
        with nogil:
            ret = rs_get_device_option(self.dev, option, &self.error)
        self._check_error()
        return ret

    def set_option(self, rs_option option, value):
        cdef double _value = value
        with nogil:
            rs_set_device_option(self.dev, option, _value, &self.error)
        self._check_error()

    def wait_for_frames(self):
        with nogil:
            rs_wait_for_frames(self.dev, &self.error)
        self._check_error()

    def poll_for_frames(self):
        cdef bint ret
        with nogil:
            ret = rs_poll_for_frames(self.dev, &self.error)
        self._check_error()
        return ret

    def get_frame_timestamp(self, rs_stream stream):
        cdef int ret
        with nogil:
            ret = rs_get_frame_timestamp(self.dev, stream, &self.error)
        self._check_error()
        return ret

    def get_frame_data(self, rs_stream stream):
        '''Return numpy ndarray
        the memory is only valid until next wait_for_frames'''
        cdef void * ret
        with nogil:
            ret = rs_get_frame_data(self.dev, stream, &self.error)
        self._check_error()
        if stream not in self._stream_formats:
            self._set_stream_format(stream)
        fmt = self._stream_formats[stream]
        cdef np.dtype dtype
        cdef np.npy_intp shape[3]
        cdef np.npy_intp stride[3]

        ndim = 2
        shape[0] = fmt['height']
        shape[1] = fmt['width']

        if fmt['format'] == RS_FORMAT_Y8:
            dtype = np.dtype('uint8')
            stride[0] = fmt['width']
            stride[1] = 1
        elif fmt['format'] in (RS_FORMAT_BGR8, RS_FORMAT_RGB8):
            dtype = np.dtype('uint8')
            ndim = 3
            shape[2] = 3
            stride[0] = fmt['width'] * 3
            stride[1] = 3
            stride[2] = 1
        elif fmt['format'] in (RS_FORMAT_Y16, RS_FORMAT_Z16):
            dtype = np.dtype('uint16')
            stride[0] = fmt['width'] * 2
            stride[1] = 2
        else:
            raise NotImplementedError("Pixel format not supported yet")

        Py_INCREF(dtype)
        return PyArray_NewFromDescr(np.ndarray, dtype, ndim, shape, stride,
                                    ret, np.NPY_DEFAULT, None)


cdef class Context(ApiBase):

    cdef rs_context * ctx

    def __cinit__(self):
        with nogil:
            self.ctx = rs_create_context(RS_API_VERSION, &self.error)
        self._check_error()

    def __dealloc__(self):
        with nogil:
            rs_delete_context(self.ctx, &self.error)
        self._check_error()

    def get_device_count(self):
        cdef int ret
        with nogil:
            ret = rs_get_device_count(self.ctx, &self.error)
        self._check_error()
        return ret

    def get_device(self, index):
        cdef rs_device * dev
        cdef int c_index = index
        with nogil:
            dev = rs_get_device(self.ctx, c_index, &self.error)
        self._check_error()
        ret = Device()
        ret.dev = dev
        return ret
