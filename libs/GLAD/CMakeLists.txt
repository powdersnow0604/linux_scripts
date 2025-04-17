cmake_minimum_required(VERSION 3.14)
project(glad LANGUAGES C)

# 라이브러리 만들기
add_library(glad SHARED
    src/glad.c
)

# 헤더 파일 디렉토리 설정
target_include_directories(glad PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
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

install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

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

