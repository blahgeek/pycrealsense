# -*- coding: utf8 -*-


cdef extern from "librealsense/rs.h":

    int RS_API_VERSION = 4

    enum rs_stream:
        RS_STREAM_DEPTH                            = 0
        RS_STREAM_COLOR                            = 1
        RS_STREAM_INFRARED                         = 2
        RS_STREAM_INFRARED2                        = 3
        RS_STREAM_POINTS                           = 4
        RS_STREAM_RECTIFIED_COLOR                  = 5
        RS_STREAM_COLOR_ALIGNED_TO_DEPTH           = 6
        RS_STREAM_INFRARED2_ALIGNED_TO_DEPTH       = 7
        RS_STREAM_DEPTH_ALIGNED_TO_COLOR           = 8
        RS_STREAM_DEPTH_ALIGNED_TO_RECTIFIED_COLOR = 9
        RS_STREAM_DEPTH_ALIGNED_TO_INFRARED2       = 10
        RS_STREAM_COUNT                            = 11

    enum rs_format:
        RS_FORMAT_ANY         = 0
        RS_FORMAT_Z16         = 1
        RS_FORMAT_DISPARITY16 = 2
        RS_FORMAT_XYZ32F      = 3
        RS_FORMAT_YUYV        = 4
        RS_FORMAT_RGB8        = 5
        RS_FORMAT_BGR8        = 6
        RS_FORMAT_RGBA8       = 7
        RS_FORMAT_BGRA8       = 8
        RS_FORMAT_Y8          = 9
        RS_FORMAT_Y16         = 10
        RS_FORMAT_RAW10       = 11
        RS_FORMAT_COUNT       = 12

    enum rs_preset:
        RS_PRESET_BEST_QUALITY      = 0
        RS_PRESET_LARGEST_IMAGE     = 1
        RS_PRESET_HIGHEST_FRAMERATE = 2
        RS_PRESET_COUNT             = 3

    enum rs_distortion:
        RS_DISTORTION_NONE                   = 0
        RS_DISTORTION_MODIFIED_BROWN_CONRADY = 1
        RS_DISTORTION_INVERSE_BROWN_CONRADY  = 2
        RS_DISTORTION_COUNT                  = 3

    enum rs_option:
        RS_OPTION_COLOR_BACKLIGHT_COMPENSATION                    = 0
        RS_OPTION_COLOR_BRIGHTNESS                                = 1
        RS_OPTION_COLOR_CONTRAST                                  = 2
        RS_OPTION_COLOR_EXPOSURE                                  = 3
        RS_OPTION_COLOR_GAIN                                      = 4
        RS_OPTION_COLOR_GAMMA                                     = 5
        RS_OPTION_COLOR_HUE                                       = 6
        RS_OPTION_COLOR_SATURATION                                = 7
        RS_OPTION_COLOR_SHARPNESS                                 = 8
        RS_OPTION_COLOR_WHITE_BALANCE                             = 9
        RS_OPTION_COLOR_ENABLE_AUTO_EXPOSURE                      = 10
        RS_OPTION_COLOR_ENABLE_AUTO_WHITE_BALANCE                 = 11
        RS_OPTION_F200_LASER_POWER                                = 12
        RS_OPTION_F200_ACCURACY                                   = 13
        RS_OPTION_F200_MOTION_RANGE                               = 14
        RS_OPTION_F200_FILTER_OPTION                              = 15
        RS_OPTION_F200_CONFIDENCE_THRESHOLD                       = 16
        RS_OPTION_SR300_DYNAMIC_FPS                               = 17
        RS_OPTION_SR300_AUTO_RANGE_ENABLE_MOTION_VERSUS_RANGE     = 18
        RS_OPTION_SR300_AUTO_RANGE_ENABLE_LASER                   = 19
        RS_OPTION_SR300_AUTO_RANGE_MIN_MOTION_VERSUS_RANGE        = 20
        RS_OPTION_SR300_AUTO_RANGE_MAX_MOTION_VERSUS_RANGE        = 21
        RS_OPTION_SR300_AUTO_RANGE_START_MOTION_VERSUS_RANGE      = 22
        RS_OPTION_SR300_AUTO_RANGE_MIN_LASER                      = 23
        RS_OPTION_SR300_AUTO_RANGE_MAX_LASER                      = 24
        RS_OPTION_SR300_AUTO_RANGE_START_LASER                    = 25
        RS_OPTION_SR300_AUTO_RANGE_UPPER_THRESHOLD                = 26
        RS_OPTION_SR300_AUTO_RANGE_LOWER_THRESHOLD                = 27
        RS_OPTION_R200_LR_AUTO_EXPOSURE_ENABLED                   = 35
        RS_OPTION_R200_LR_GAIN                                    = 36
        RS_OPTION_R200_LR_EXPOSURE                                = 37
        RS_OPTION_R200_EMITTER_ENABLED                            = 38
        RS_OPTION_R200_DEPTH_UNITS                                = 39
        RS_OPTION_R200_DEPTH_CLAMP_MIN                            = 40
        RS_OPTION_R200_DEPTH_CLAMP_MAX                            = 41
        RS_OPTION_R200_DISPARITY_MULTIPLIER                       = 42
        RS_OPTION_R200_DISPARITY_SHIFT                            = 43
        RS_OPTION_R200_AUTO_EXPOSURE_MEAN_INTENSITY_SET_POINT     = 44
        RS_OPTION_R200_AUTO_EXPOSURE_BRIGHT_RATIO_SET_POINT       = 45
        RS_OPTION_R200_AUTO_EXPOSURE_KP_GAIN                      = 46
        RS_OPTION_R200_AUTO_EXPOSURE_KP_EXPOSURE                  = 47
        RS_OPTION_R200_AUTO_EXPOSURE_KP_DARK_THRESHOLD            = 48
        RS_OPTION_R200_AUTO_EXPOSURE_TOP_EDGE                     = 49
        RS_OPTION_R200_AUTO_EXPOSURE_BOTTOM_EDGE                  = 50
        RS_OPTION_R200_AUTO_EXPOSURE_LEFT_EDGE                    = 51
        RS_OPTION_R200_AUTO_EXPOSURE_RIGHT_EDGE                   = 52
        RS_OPTION_R200_DEPTH_CONTROL_ESTIMATE_MEDIAN_DECREMENT    = 53
        RS_OPTION_R200_DEPTH_CONTROL_ESTIMATE_MEDIAN_INCREMENT    = 54
        RS_OPTION_R200_DEPTH_CONTROL_MEDIAN_THRESHOLD             = 55
        RS_OPTION_R200_DEPTH_CONTROL_SCORE_MINIMUM_THRESHOLD      = 56
        RS_OPTION_R200_DEPTH_CONTROL_SCORE_MAXIMUM_THRESHOLD      = 57
        RS_OPTION_R200_DEPTH_CONTROL_TEXTURE_COUNT_THRESHOLD      = 58
        RS_OPTION_R200_DEPTH_CONTROL_TEXTURE_DIFFERENCE_THRESHOLD = 59
        RS_OPTION_R200_DEPTH_CONTROL_SECOND_PEAK_THRESHOLD        = 60
        RS_OPTION_R200_DEPTH_CONTROL_NEIGHBOR_THRESHOLD           = 61
        RS_OPTION_R200_DEPTH_CONTROL_LR_THRESHOLD                 = 62
        RS_OPTION_COUNT                                           = 63

    struct rs_intrinsics:
        int           width
        int           height
        float         ppx
        float         ppy
        float         fx
        float         fy
        rs_distortion model
        float         coeffs[5]

    struct rs_extrinsics:
        float rotation[9]
        float translation[3]

    struct rs_context:
        pass

    struct rs_device:
        pass

    struct rs_error:
        pass

    rs_context * rs_create_context(int api_version, rs_error ** error) nogil

    void rs_delete_context(rs_context * context, rs_error ** error) nogil

    int rs_get_device_count(const rs_context * context, rs_error ** error) nogil

    rs_device * rs_get_device(rs_context * context, int index, rs_error ** error) nogil

    const char * rs_get_device_name(const rs_device * device, rs_error ** error) nogil

    const char * rs_get_device_serial(const rs_device * device, rs_error ** error) nogil

    const char * rs_get_device_firmware_version(const rs_device * device, rs_error ** error) nogil

    void rs_get_device_extrinsics(const rs_device * device, rs_stream from_stream, rs_stream to_stream, rs_extrinsics * extrin, rs_error ** error) nogil

    float rs_get_device_depth_scale(const rs_device * device, rs_error ** error) nogil

    int rs_device_supports_option(const rs_device * device, rs_option option, rs_error ** error) nogil

    int rs_get_stream_mode_count(const rs_device * device, rs_stream stream, rs_error ** error) nogil

    void rs_get_stream_mode(const rs_device * device, rs_stream stream, int index, int * width, int * height, rs_format * format, int * framerate, rs_error ** error) nogil

    void rs_enable_stream(rs_device * device, rs_stream stream, int width, int height, rs_format format, int framerate, rs_error ** error) nogil

    void rs_enable_stream_preset(rs_device * device, rs_stream stream, rs_preset preset, rs_error ** error) nogil

    void rs_disable_stream(rs_device * device, rs_stream stream, rs_error ** error) nogil

    int rs_is_stream_enabled(const rs_device * device, rs_stream stream, rs_error ** error) nogil

    int rs_get_stream_width(const rs_device * device, rs_stream stream, rs_error ** error) nogil

    int rs_get_stream_height(const rs_device * device, rs_stream stream, rs_error ** error) nogil

    rs_format rs_get_stream_format(const rs_device * device, rs_stream stream, rs_error ** error) nogil

    int rs_get_stream_framerate(const rs_device * device, rs_stream stream, rs_error ** error) nogil

    void rs_get_stream_intrinsics(const rs_device * device, rs_stream stream, rs_intrinsics * intrin, rs_error ** error) nogil

    void rs_start_device(rs_device * device, rs_error ** error) nogil

    void rs_stop_device(rs_device * device, rs_error ** error) nogil

    int rs_is_device_streaming(const rs_device * device, rs_error ** error) nogil

    void rs_get_device_option_range(rs_device * device, rs_option option, double * min, double * max, double * step, rs_error ** error) nogil

    void rs_get_device_options(rs_device * device, const rs_option * options, int count, double * values, rs_error ** error) nogil

    void rs_set_device_options(rs_device * device, const rs_option * options, int count, const double * values, rs_error ** error) nogil

    double rs_get_device_option(rs_device * device, rs_option option, rs_error ** error) nogil

    void rs_set_device_option(rs_device * device, rs_option option, double value, rs_error ** error) nogil

    void rs_wait_for_frames(rs_device * device, rs_error ** error) nogil

    int rs_poll_for_frames(rs_device * device, rs_error ** error) nogil

    int rs_get_frame_timestamp(const rs_device * device, rs_stream stream, rs_error ** error) nogil

    const void * rs_get_frame_data(const rs_device * device, rs_stream stream, rs_error ** error) nogil

    const char * rs_get_failed_function  (const rs_error * error) nogil
    const char * rs_get_failed_args      (const rs_error * error) nogil
    const char * rs_get_error_message    (const rs_error * error) nogil
    void         rs_free_error           (rs_error * error) nogil

    const char * rs_stream_to_string     (rs_stream stream) nogil
    const char * rs_format_to_string     (rs_format format) nogil
    const char * rs_preset_to_string     (rs_preset preset) nogil
    const char * rs_distortion_to_string (rs_distortion distortion) nogil
    const char * rs_option_to_string     (rs_option option) nogil

    enum rs_log_severity:
        RS_LOG_SEVERITY_DEBUG = 0
        RS_LOG_SEVERITY_INFO  = 1
        RS_LOG_SEVERITY_WARN  = 2
        RS_LOG_SEVERITY_ERROR = 3
        RS_LOG_SEVERITY_FATAL = 4
        RS_LOG_SEVERITY_NONE  = 5

    void rs_log_to_console(rs_log_severity min_severity, rs_error ** error) nogil
    void rs_log_to_file(rs_log_severity min_severity, const char * file_path, rs_error ** error) nogil
