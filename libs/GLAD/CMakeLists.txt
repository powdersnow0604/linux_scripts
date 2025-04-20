cmake_minimum_required(VERSION 3.14)
project(glad LANGUAGES C)

# src directory
if(NOT DEFINED DIR)
    set(DIR ${CMAKE_SOURCE_DIR} CACHE STRING "Directory variable")
endif()

# 라이브러리 만들기
add_library(glad SHARED
    ${DIR}/src/glad.c
)

# 헤더 파일 디렉토리 설정
target_include_directories(glad PUBLIC
    $<BUILD_INTERFACE:${DIR}/include>
    $<INSTALL_INTERFACE:include>
)

# 설치 설정
include(GNUInstallDirs)

install(TARGETS glad
    EXPORT gladTargets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(DIRECTORY ${DIR}/include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# 패키지 설정
install(EXPORT gladTargets
    FILE gladTargets.cmake
    NAMESPACE glad::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/glad
)

include(CMakePackageConfigHelpers)


configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/gladConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/gladConfig.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/glad
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/gladConfig.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/glad
)

# Add pkg-config support
set(PKG_CONFIG_FILE "${CMAKE_CURRENT_BINARY_DIR}/glad.pc")
set(PKG_CONFIG_CONTENT "prefix=${CMAKE_INSTALL_PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: glad
Description: Multi-Language GL/GLES/EGL/GLX/WGL Loader-Generator based on the official specs
Version: ${PROJECT_VERSION}
Libs: -L\${libdir} -lglad
Cflags: -I\${includedir}
")

file(WRITE "${PKG_CONFIG_FILE}" "${PKG_CONFIG_CONTENT}")

install(FILES
    "${PKG_CONFIG_FILE}"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
)

