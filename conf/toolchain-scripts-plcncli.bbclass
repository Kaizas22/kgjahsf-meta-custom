toolchain_create_toolchain_file() {
    toolchain_cmake=$1
	rm -f $toolchain_cmake
	touch $toolchain_cmake

    cat >> $toolchain_cmake << EOF
# CMake Toolchain file for this SDK
#
# Following variables will be defined and cached from this toolchain file:
#    ARP_TOOLCHAIN_CMAKE_MODULE_PATH       The path to the toolchain CMake helper modules.
#    ARP_TOOLCHAIN_HOST_SYSTEM_PROCESSOR   The architecture of the host system processor [x86, x86_64].
# Variables to configure the toolchain:
#    ARP_TOOLCHAIN_ROOT                    Path to the PLCnext toolchain root.
#    ARP_TOOLCHAIN_NATIVE_SYSROOT          Path to the PLCnext toolchain native sysroot.
#    ARP_TOOLCHAIN_TARGET_SYSROOT          Path to the PLCnext toolchain target sysroot.
#    ARP_TOOLCHAIN_PREFIX_PATH             Prefix path to add to 'CMAKE_FIND_ROOT_PATH'.

# Version 3.6 to support 'CMAKE_TRY_COMPILE_PLATFORM_VARIABLES'
cmake_minimum_required(VERSION 3.6 FATAL_ERROR)
include_guard(GLOBAL)

set(ARP_TOOLCHAIN_CMAKE_MODULE_PATH "\${CMAKE_CURRENT_LIST_DIR}/cmake" CACHE PATH "Path to the cmake module folder of the toolchain file." FORCE)

include("\${ARP_TOOLCHAIN_CMAKE_MODULE_PATH}/DetermineArpPaths.cmake")
include("\${ARP_TOOLCHAIN_CMAKE_MODULE_PATH}/DetermineHostSystemProcessor.cmake")

determine_host_system_processor(_ARP_TOOLCHAIN_HOST_SYSTEM_PROCESSOR)
set(ARP_TOOLCHAIN_HOST_SYSTEM_PROCESSOR \${_ARP_TOOLCHAIN_HOST_SYSTEM_PROCESSOR} CACHE STRING "The architecture of the host system processor [x86, x86_64]." FORCE)
unset(_ARP_TOOLCHAIN_HOST_SYSTEM_PROCESSOR)

determine_arp_paths(\${ARP_TOOLCHAIN_HOST_SYSTEM_PROCESSOR})

# Pass toolchain variables to try_compile runs
set(CMAKE_TRY_COMPILE_PLATFORM_VARIABLES ARP_TOOLCHAIN_ROOT ARP_TOOLCHAIN_TARGET_SYSROOT ARP_TOOLCHAIN_NATIVE_SYSROOT ARP_TOOLCHAIN_PREFIX_PATH)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ${ARCH})
set(CMAKE_SYSROOT \${ARP_TOOLCHAIN_TARGET_SYSROOT})

if(CMAKE_HOST_WIN32)
    set(_BIN_POSTFIX ".exe")
else()
    set(_BIN_POSTFIX "")
endif()
set(CMAKE_C_COMPILER "\${ARP_TOOLCHAIN_NATIVE_SYSROOT}$bindir/${TARGET_SYS}/${TARGET_PREFIX}gcc\${_BIN_POSTFIX}" CACHE FILEPATH "" FORCE)
set(CMAKE_CXX_COMPILER "\${ARP_TOOLCHAIN_NATIVE_SYSROOT}$bindir/${TARGET_SYS}/${TARGET_PREFIX}g++\${_BIN_POSTFIX}" CACHE FILEPATH "" FORCE)
unset(_BIN_POSTFIX)

set(_ARP_TOOLCHAIN_COMPILER_FLAGS "${TUNE_CCARGS}")
#set compiler flags if not already previously set
if(CMAKE_C_FLAGS MATCHES "\${_ARP_TOOLCHAIN_COMPILER_FLAGS}")
    set(_ARP_TOOLCHAIN_COMPILER_FLAGS "")
else()
    set(_ARP_TOOLCHAIN_COMPILER_FLAGS " \${_ARP_TOOLCHAIN_COMPILER_FLAGS}")
endif()
set(CMAKE_C_FLAGS "\${CMAKE_C_FLAGS}\${_ARP_TOOLCHAIN_COMPILER_FLAGS}" CACHE STRING "Flags used by the compiler during all build types." FORCE)
set(CMAKE_C_LINK_FLAGS "\${CMAKE_C_LINK_FLAGS}\${_ARP_TOOLCHAIN_COMPILER_FLAGS}" CACHE STRING "Flags used by the compiler during all build types." FORCE)
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS}\${_ARP_TOOLCHAIN_COMPILER_FLAGS}" CACHE STRING "Flags used by the compiler during all build types." FORCE)
set(CMAKE_CXX_LINK_FLAGS "\${CMAKE_CXX_LINK_FLAGS}\${_ARP_TOOLCHAIN_COMPILER_FLAGS}" CACHE STRING "Flags used by the compiler during all build types." FORCE)
unset(_ARP_TOOLCHAIN_COMPILER_FLAGS)

set(ARP_TOOLCHAIN_PREFIX_PATH "" CACHE PATH "Path to add to 'CMAKE_FIND_ROOT_PATH'.")

# Search in these paths when using find_*
set(CMAKE_FIND_ROOT_PATH \${ARP_TOOLCHAIN_TARGET_SYSROOT} \${ARP_TOOLCHAIN_PREFIX_PATH} \${CMAKE_PREFIX_PATH})
# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# For libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
EOF
}

toolchain_create_detemine_arpPaths_script() {
    arpPath_script=$1
	rm -f $arpPath_script
	touch $arpPath_script

    TARGET_SYSROOT_DIR=$(echo "${SDKTARGETSYSROOT}" | sed s/.*sysroots/sysroots/)
    NATIVE_SYSROOT_DIR=$(echo "${SDKPATHNATIVE}" | sed s/.*sysroots/sysroots/)

    cat >> $arpPath_script << EOF
# Get the paths of the Phoenix Contact PLCnext toolchain.
#
# Following variables will be definded and cached from this macro:
#    ARP_TOOLCHAIN_ROOT                                 Path to the PLCnext toolchain root.
#    ARP_TOOLCHAIN_NATIVE_SYSROOT                       Path to the PLCnext toolchain native sysroot.
#    ARP_TOOLCHAIN_TARGET_SYSROOT                       Path to the PLCnext toolchain target sysroot.
ARP_TOOLCHAIN_ENVIRONMENT_PATH		                    Extended environment variable PATH for the PLCnext toolchain.
+#		ARP_TOOLCHAIN_CREATE_ENVIRONMENT_SETUP_FILE     Create environment setup file in cmake binary folder.
macro(determine_arp_paths _host_system_processor)
    set(_NATIVE_SYSROOT_DIR "")
#DBG set(_NATIVE_SYSROOT_DIR "${NATIVE_SYSROOT_DIR}")
    set(_TARGET_SYSROOT_DIR "")
#DBG set(_TARGET_SYSROOT_DIR "${TARGET_SYSROOT_DIR}")

    # Specify the target and native sysroots to use if they are not user defined
    set(_TARGET_SYSROOT_DIR "sysroots/cortexa9t2hf-neon-pxc-linux-gnueabi")
    if(\${CMAKE_HOST_WIN32})
        if(\${_host_system_processor} STREQUAL "x86_64")
            set(_NATIVE_SYSROOT_DIR "sysroots/x86_64-pokysdk-mingw32")
        elseif(\${_host_system_processor} STREQUAL "x86")
            set(_NATIVE_SYSROOT_DIR "sysroots/i686-pokysdk-mingw32")
        endif()
    elseif(\${CMAKE_HOST_UNIX})
        if(\${_host_system_processor} STREQUAL "x86_64")
            set(_NATIVE_SYSROOT_DIR "sysroots/x86_64-pokysdk-linux")
        elseif(\${_host_system_processor} STREQUAL "x86")
            set(_NATIVE_SYSROOT_DIR "sysroots/i686-pokysdk-linux")
        endif()
    endif()

    if(NOT DEFINED ARP_TOOLCHAIN_ROOT)
        # Try to initialize from PLCnext toolchain environment setup script variable.
        if(NOT "\$ENV{SDKROOT}" STREQUAL "")
            set(ARP_TOOLCHAIN_ROOT \$ENV{SDKROOT} CACHE PATH "Path to the PLCnext toolchain root.")
        elseif(NOT "\$ENV{PLCNEXT_SDK_ROOT}" STREQUAL "")
            set(ARP_TOOLCHAIN_ROOT \$ENV{PLCNEXT_SDK_ROOT} CACHE PATH "Path to the PLCnext toolchain root.")
        else()
            message(FATAL_ERROR "PLCnext toolchain root path not specified. Set the 'ARP_TOOLCHAIN_ROOT' variable to the path where the 'sysroots' folder is stored.")
        endif()
    else()
        set(ARP_TOOLCHAIN_ROOT \${ARP_TOOLCHAIN_ROOT} CACHE PATH "Path to the PLCnext toolchain root.")
    endif()

    if(NOT DEFINED ARP_TOOLCHAIN_NATIVE_SYSROOT)
        # Try to initialize from PLCnext toolchain environment setup script variable.
        if(NOT "\$ENV{OECORE_NATIVE_SYSROOT}" STREQUAL "")
            set(ARP_TOOLCHAIN_NATIVE_SYSROOT \$ENV{OECORE_NATIVE_SYSROOT} CACHE PATH "Path to the PLCnext toolchain native sysroot.")
        else()
            set(ARP_TOOLCHAIN_NATIVE_SYSROOT "\${ARP_TOOLCHAIN_ROOT}/\${_NATIVE_SYSROOT_DIR}" CACHE PATH "Path to the PLCnext toolchain native sysroot.")
        endif()
        if(NOT EXISTS \${ARP_TOOLCHAIN_NATIVE_SYSROOT})
            message(FATAL_ERROR "PLCnext toolchain native sysroot path '\${ARP_TOOLCHAIN_NATIVE_SYSROOT}' does not exist.")
        else()
            message(STATUS "Setting ARP_TOOLCHAIN_NATIVE_SYSROOT='\${ARP_TOOLCHAIN_NATIVE_SYSROOT}'")
        endif()
    else()
        set(ARP_TOOLCHAIN_NATIVE_SYSROOT "\${ARP_TOOLCHAIN_NATIVE_SYSROOT}" CACHE PATH "Path to the PLCnext toolchain native sysroot.")
    endif()

    if(NOT DEFINED ARP_TOOLCHAIN_TARGET_SYSROOT)
        # Try to initialize from PLCnext toolchain environment setup script variable.
        if(NOT "\$ENV{OECORE_TARGET_SYSROOT}" STREQUAL "")
            set(ARP_TOOLCHAIN_TARGET_SYSROOT \$ENV{OECORE_TARGET_SYSROOT} CACHE PATH "Path to the PLCnext toolchain target sysroot.")
        else()
            set(ARP_TOOLCHAIN_TARGET_SYSROOT "\${ARP_TOOLCHAIN_ROOT}/\${_TARGET_SYSROOT_DIR}" CACHE PATH "Path to the PLCnext toolchain target sysroot.")
        endif()
        if(NOT EXISTS \${ARP_TOOLCHAIN_TARGET_SYSROOT})
            message(FATAL_ERROR "PLCnext toolchain target sysroot path '\${ARP_TOOLCHAIN_TARGET_SYSROOT}' does not exist.")
        else()
            message(STATUS "Setting ARP_TOOLCHAIN_TARGET_SYSROOT='\${ARP_TOOLCHAIN_TARGET_SYSROOT}'")
        endif()
    else()
        set(ARP_TOOLCHAIN_TARGET_SYSROOT "\${ARP_TOOLCHAIN_TARGET_SYSROOT}" CACHE PATH "Path to the PLCnext toolchain target sysroot.")
    endif()

    if(NOT DEFINED ARP_TOOLCHAIN_ENVIRONMENT_PATH)
        set(ARP_TOOLCHAIN_ENVIRONMENT_PATH "$ENV{PATH};${ARP_TOOLCHAIN_NATIVE_SYSROOT}/usr/bin" CACHE PATH "Extended environment variable PATH for the PLCnext toolchain.")
        message(STATUS "Setting ARP_TOOLCHAIN_ENVIRONMENT_PATH='${ARP_TOOLCHAIN_ENVIRONMENT_PATH}'")
    else()
        set(ARP_TOOLCHAIN_ENVIRONMENT_PATH "${ARP_TOOLCHAIN_ENVIRONMENT_PATH}" CACHE PATH "Extended environment variable PATH for the PLCnext toolchain.")
    endif()
    set(ENV{PATH} "${ARP_TOOLCHAIN_ENVIRONMENT_PATH}" CACHE PATH "Test")
    message(STATUS "Setting ENV{PATH}='$ENV{PATH}'")

    set(ARP_TOOLCHAIN_CREATE_ENVIRONMENT_SETUP_FILE ON CACHE BOOL "Create an EnvironmentSetup.bat or EnvironmentSetup.sh resp. inside the CMake binary folder.")
    if(ARP_TOOLCHAIN_CREATE_ENVIRONMENT_SETUP_FILE)
        if(${CMAKE_HOST_WIN32})
            string(REPLACE "/" "\\" _WINDOWS_PATH ${ARP_TOOLCHAIN_NATIVE_SYSROOT})
            file(WRITE ${PROJECT_BINARY_DIR}/EnvironmentSetup.bat 
            "\@REM Execute this script before using cmake or make to ensure that the environment is setup correctly
            set PATH=${_WINDOWS_PATH}\\usr\\bin;\%PATH\%")
            unset(_WINDOWS_PATH)
        elseif(${CMAKE_HOST_UNIX})
            file(WRITE ${PROJECT_BINARY_DIR}/EnvironmentSetup.sh 
            "\# Execute this script before using cmake or make to ensure that the environment is setup correctly
            export PATH=${ARP_TOOLCHAIN_NATIVE_SYSROOT}/usr/bin:\$PATH")
        endif()
    endif()

    unset(_NATIVE_SYSROOT_DIR)
    unset(_TARGET_SYSROOT_DIR)
endmacro()
EOF
}

toolchain_create_determine_hostSystemProcessor_script() {
    hostSystemProcessor_script=$1
	rm -f $hostSystemProcessor_script
	touch $hostSystemProcessor_script

    cat >> $hostSystemProcessor_script << EOF
# Get the host system processor architecture.
# Return value will be set in the provided '_result' variable
#    x86      for 32 bit architecture
#    x86_64   for 64 bit architecture
macro(determine_host_system_processor _result)
    set(_HOST_SYSTEM_PROCESSOR \${CMAKE_HOST_SYSTEM_PROCESSOR})
    string(TOLOWER \${_HOST_SYSTEM_PROCESSOR} _HOST_SYSTEM_PROCESSOR)
    if(\${_HOST_SYSTEM_PROCESSOR} STREQUAL "amd64" OR \${_HOST_SYSTEM_PROCESSOR} STREQUAL "x86-64" OR \${_HOST_SYSTEM_PROCESSOR} STREQUAL "x64" OR \${_HOST_SYSTEM_PROCESSOR} STREQUAL "ia64")
        set(_HOST_SYSTEM_PROCESSOR "x86_64")
    elseif(_HOST_SYSTEM_PROCESSOR MATCHES "i[0-9]86" OR \${_HOST_SYSTEM_PROCESSOR} STREQUAL "ia32")
        set(_HOST_SYSTEM_PROCESSOR "x86")
    endif()
    set(\${_result} \${_HOST_SYSTEM_PROCESSOR})
    unset(_HOST_SYSTEM_PROCESSOR)
endmacro()
EOF
}

toolchain_create_find_arpDevice_script() {
    arpDevice_script=$1
	rm -f $arpDevice_script
	touch $arpDevice_script

    ARP_DEVICE=$(echo "${ARPDEVICE}" | tr a-z A-Z)

    cat >> $arpDevice_script << EOF
# FindArpDevice.cmake
#
# Sets required compile options / definitions
# based on the chosen target
#
# This will define the following interface targets
#
#     ArpDevice
#
# and the following variables
#
#     ArpDevice_FOUND

include(FindPackageHandleStandardArgs)

if(NOT TARGET ArpDevice)
    add_library(ArpDevice INTERFACE)
endif()

set(ARP_CHECK_DEVICE ON CACHE BOOL "If set to ON, checks whether the device is supported by this SDK. Default is ON.")
set(ARP_CHECK_DEVICE_VERSION ON CACHE BOOL "If set to ON, checks whether the device version is supported by this SDK. Default is ON.")

### Check ARP_DEVICE ###

if(ARP_DEVICE STREQUAL "${ARP_DEVICE}")
    target_compile_definitions(ArpDevice INTERFACE -DARP_DEVICE_${ARP_DEVICE})
    set(_ARP_DEVICE_MATCH ON)
else()
    set(ARP_SUPPORTED_DEVICES "${ARP_DEVICE}" CACHE STRING "Supported devices of this SDK.")
    set(_ARP_DEVICE_MATCH OFF)
endif()

### Check ARP_DEVICE_VERSION ###

find_file(_VERSION_FILE "Arp/System/Core/ArpVersion.h" "$includedir/plcnext/")
if(NOT _VERSION_FILE)
    message(FATAL_ERROR "The version file 'ArpVersion.h' could not be found. The supported version cannot be defined.")
endif()

file(READ \${_VERSION_FILE} _VERSION_FILE_CONTENT)

if(NOT \${_VERSION_FILE_CONTENT} MATCHES "#define ARP_VERSION_MAJOR ([0-9]+)")
    message(FATAL_ERROR "Cannot match '#define ARP_VERSION_MAJOR ([0-9]+)' in 'ArpVersion.h'. Content is \${_VERSION_FILE_CONTENT}")
endif()
set(ARP_VERSION_MAJOR \${CMAKE_MATCH_1} CACHE STRING "Major version of this SDK.")

if(NOT \${_VERSION_FILE_CONTENT} MATCHES "#define ARP_VERSION_MINOR ([0-9]+)")
    message(FATAL_ERROR "Cannot match '#define ARP_VERSION_MINOR ([0-9]+)' in 'ArpVersion.h'. Content is \${_VERSION_FILE_CONTENT}")
endif()
set(ARP_VERSION_MINOR \${CMAKE_MATCH_1} CACHE STRING "Minor version of this SDK.")

if(NOT \${_VERSION_FILE_CONTENT} MATCHES "#define ARP_VERSION_PATCH ([0-9]+)")
    message(FATAL_ERROR "Cannot match '#define ARP_VERSION_PATCH ([0-9]+)' in 'ArpVersion.h'. Content is \${_VERSION_FILE_CONTENT}")
endif()
set(ARP_VERSION_PATCH \${CMAKE_MATCH_1} CACHE STRING "Patch version of this SDK.")

if(NOT \${_VERSION_FILE_CONTENT} MATCHES "#define ARP_VERSION_BUILD ([0-9]+)")
    message(FATAL_ERROR "Cannot match '#define ARP_VERSION_BUILD ([0-9]+)' in 'ArpVersion.h'. Content is \${_VERSION_FILE_CONTENT}")
endif()
set(ARP_VERSION_BUILD \${CMAKE_MATCH_1} CACHE STRING "Build version of this SDK.")

if(NOT \${_VERSION_FILE_CONTENT} MATCHES "#define ARP_VERSION_NAME \\"([^\\"]*)\\"")
    message(FATAL_ERROR "Cannot match '#define ARP_VERSION_NAME \\"([^\\"]*)\\"' in 'ArpVersion.h'. Content is \${_VERSION_FILE_CONTENT}")
endif()
set(ARP_VERSION_NAME \${CMAKE_MATCH_1} CACHE STRING "Version name of this SDK.")

if(NOT \${_VERSION_FILE_CONTENT} MATCHES "#define ARP_VERSION_STATE \\"([^"]*)\\"")
    message(FATAL_ERROR "Cannot match '#define ARP_VERSION_STATE \\"([^\\"]*)\\"' in 'ArpVersion.h'. Content is \${_VERSION_FILE_CONTENT}")
endif()
set(ARP_VERSION_STATE \${CMAKE_MATCH_1} CACHE STRING "Version state of this SDK.")

set(ARP_VERSION "\${ARP_VERSION_NAME} (\${ARP_VERSION_MAJOR}.\${ARP_VERSION_MINOR}.\${ARP_VERSION_PATCH}.\${ARP_VERSION_BUILD} \${ARP_VERSION_STATE})" CACHE STRING "Full version of this SDK.")

if(ARP_DEVICE_VERSION STREQUAL \${ARP_VERSION})
    set(_ARP_DEVICE_VERSION_MATCH ON)
else()
    set(ARP_SUPPORTED_VERSIONS \${ARP_VERSION} CACHE STRING "Supported versions of this SDK.")
    set(_ARP_DEVICE_VERSION_MATCH OFF)
endif()

### Throw errors if device or version do not match ###

if(NOT _ARP_DEVICE_MATCH AND ARP_CHECK_DEVICE)
    if(DEFINED ARP_DEVICE)
        message(FATAL_ERROR "The device '\${ARP_DEVICE}' is not supported by this SDK. Supported devices are \${ARP_SUPPORTED_DEVICES}.")
    else()
        message(FATAL_ERROR "ARP_DEVICE was not specified. Please use -DARP_DEVICE to specify this argument. Supported devices are \${ARP_SUPPORTED_DEVICES}.")
    endif()
endif()

if(NOT _ARP_DEVICE_VERSION_MATCH AND ARP_CHECK_DEVICE_VERSION)
    if(DEFINED ARP_DEVICE_VERSION)
        message(FATAL_ERROR "The device version '\${ARP_DEVICE_VERSION}' is not supported by this SDK. Supported versions are \${ARP_SUPPORTED_VERSIONS}.")
    else()
        message(FATAL_ERROR "ARP_DEVICE_VERSION was not specified. Please use -DARP_DEVICE_VERSION to specify this argument. Supported versions are \${ARP_SUPPORTED_VERSIONS}.")
    endif()
endif()

### Set additional compile and linker flags ###
# WARNING: This flag should not be removed as libraries would otherwise only be loaded when the target is restarted.

target_compile_options(ArpDevice INTERFACE -fno-gnu-unique)

### unset local varaibles ###

unset(_ARP_DEVICE_MATCH)
unset(_ARP_DEVICE_VERSION_MATCH)
unset(_VERSION_FILE)
unset(_VERSION_FILE_CONTENT)
EOF
}

toolchain_create_find_arpProgramming_script() {
    arpProgramming_script=$1
	rm -f $arpProgramming_script
	touch $arpProgramming_script

    cat >> $arpProgramming_script << EOF
# FindArpProgramming.cmake
#
# Finds PlcNext necessary base libraries and
# include path
#
# This will define the following imported targets
#
#     ArpProgramming
#
# and the following variables
#
#     ArpProgramming_FOUND

find_path(ArpProgramming_INCLUDE_DIR "Arp/System/Core/Arp.h" $includedir/plcnext/)

### PlcNext System Libraries ###

find_library(ArpProgramming_ARP_ACF_LIBRARY Arp.System.Acf)
find_library(ArpProgramming_ARP_COMMONS_LIBRARY Arp.System.Commons)
find_library(ArpProgramming_ARP_CORE_LIBRARY Arp.System.Core)
find_library(ArpProgramming_ARP_PLC_COMMONS_LIBRARY Arp.Plc.Commons)
find_library(ArpProgramming_ARP_RSC_LIBRARY Arp.System.Rsc)

### PlcNext Feature Libraries - all services should be found in these ###

find_library(ArpProgramming_ARP_NM_LIBRARY Arp.System.Nm)
find_library(ArpProgramming_ARP_NMPAYLOAD_LIBRARY Arp.System.NmPayload)
find_library(ArpProgramming_ARP_SECURITY_LIBRARY Arp.System.Security)
find_library(ArpProgramming_ARP_SECURITY_SERVICES_LIBRARY Arp.System.Security.Services)
find_library(ArpProgramming_ARP_UM_LIBRARY Arp.System.Um)
find_library(ArpProgramming_ARP_VE_LIBRARY Arp.System.Ve)

find_library(ArpProgramming_ARP_PLC_DOMAIN_LIBRARY Arp.Plc.Domain)
find_library(ArpProgramming_ARP_PLC_GDS_LIBRARY Arp.Plc.Gds)
find_library(ArpProgramming_ARP_PLC_META_LIBRARY Arp.Plc.Meta)

find_library(ArpProgramming_ARP_DEVICE_INTERFACE_LIBRARY Arp.Device.Interface)

find_library(ArpProgramming_ARP_IO_AXIOLINE_LIBRARY Arp.Io.Axioline)
find_library(ArpProgramming_ARP_IO_INTERBUS_LIBRARY Arp.Io.Interbus)
find_library(ArpProgramming_ARP_IO_PROFINETSTACK_LIBRARY Arp.Io.ProfinetStack)

find_library(ArpProgramming_ARP_SERVICES_NOTIFICATIONLOGGER_LIBRARY Arp.Services.NotificationLogger)
find_library(ArpProgramming_ARP_SERVICES_OPCUASERVER_LIBRARY Arp.Services.OpcUAServer)
find_library(ArpProgramming_ARP_SERVICES_TRACECONTROLLER_LIBRARY Arp.Services.TraceController)

### other Libraries ###

find_library(ArpProgramming_PTHREAD_LIBRARY NAMES pthread)
find_library(ArpProgramming_CPPFORMAT_LIBRARY NAMES cppformat)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ArpProgramming
    DEFAULT_MSG
    ArpProgramming_INCLUDE_DIR ArpProgramming_ARP_ACF_LIBRARY ArpProgramming_ARP_COMMONS_LIBRARY ArpProgramming_ARP_CORE_LIBRARY ArpProgramming_ARP_PLC_COMMONS_LIBRARY ArpProgramming_ARP_RSC_LIBRARY ArpProgramming_PTHREAD_LIBRARY ArpProgramming_CPPFORMAT_LIBRARY ArpProgramming_ARP_NM_LIBRARY ArpProgramming_ARP_NMPAYLOAD_LIBRARY ArpProgramming_ARP_SECURITY_LIBRARY ArpProgramming_ARP_SECURITY_SERVICES_LIBRARY ArpProgramming_ARP_UM_LIBRARY ArpProgramming_ARP_VE_LIBRARY ArpProgramming_ARP_PLC_DOMAIN_LIBRARY ArpProgramming_ARP_PLC_GDS_LIBRARY ArpProgramming_ARP_PLC_META_LIBRARY ArpProgramming_ARP_DEVICE_INTERFACE_LIBRARY ArpProgramming_ARP_IO_AXIOLINE_LIBRARY ArpProgramming_ARP_IO_INTERBUS_LIBRARY ArpProgramming_ARP_IO_PROFINETSTACK_LIBRARY ArpProgramming_ARP_SERVICES_NOTIFICATIONLOGGER_LIBRARY ArpProgramming_ARP_SERVICES_OPCUASERVER_LIBRARY ArpProgramming_ARP_SERVICES_TRACECONTROLLER_LIBRARY
)

set(ArpProgramming_LIBRARIES
    "\${ArpProgramming_ARP_ACF_LIBRARY}"
    "\${ArpProgramming_ARP_COMMONS_LIBRARY}"
    "\${ArpProgramming_ARP_CORE_LIBRARY}"
    "\${ArpProgramming_ARP_PLC_COMMONS_LIBRARY}"
    "\${ArpProgramming_ARP_RSC_LIBRARY}"
    "\${ArpProgramming_ARP_NM_LIBRARY}"
    "\${ArpProgramming_ARP_NMPAYLOAD_LIBRARY}"
    "\${ArpProgramming_ARP_SECURITY_LIBRARY}"
    "\${ArpProgramming_ARP_SECURITY_SERVICES_LIBRARY}"
    "\${ArpProgramming_ARP_UM_LIBRARY}"
    "\${ArpProgramming_ARP_VE_LIBRARY}"
    "\${ArpProgramming_ARP_PLC_DOMAIN_LIBRARY}"
    "\${ArpProgramming_ARP_PLC_GDS_LIBRARY}"
    "\${ArpProgramming_ARP_PLC_META_LIBRARY}"
    "\${ArpProgramming_ARP_DEVICE_INTERFACE_LIBRARY}"
    "\${ArpProgramming_ARP_IO_AXIOLINE_LIBRARY}"
    "\${ArpProgramming_ARP_IO_INTERBUS_LIBRARY}"
    "\${ArpProgramming_ARP_IO_PROFINETSTACK_LIBRARY}"
    "\${ArpProgramming_ARP_SERVICES_NOTIFICATIONLOGGER_LIBRARY}"
    "\${ArpProgramming_ARP_SERVICES_OPCUASERVER_LIBRARY}"
    "\${ArpProgramming_ARP_SERVICES_TRACECONTROLLER_LIBRARY}"
    "\${ArpProgramming_CPPFORMAT_LIBRARY}"
    "\${ArpProgramming_PTHREAD_LIBRARY}")

if(ArpProgramming_FOUND AND NOT TARGET ArpProgramming)
    add_library(ArpProgramming INTERFACE)
endif()

if(ArpProgramming_FOUND)
    target_include_directories(ArpProgramming INTERFACE "\${ArpProgramming_INCLUDE_DIR}")
    target_link_libraries(ArpProgramming INTERFACE "\${ArpProgramming_ARP_ACF_LIBRARY}" "\${ArpProgramming_ARP_COMMONS_LIBRARY}" "\${ArpProgramming_ARP_CORE_LIBRARY}" "\${ArpProgramming_ARP_PLC_COMMONS_LIBRARY}" "\${ArpProgramming_ARP_RSC_LIBRARY}" "\${ArpProgramming_PTHREAD_LIBRARY}" "\${ArpProgramming_CPPFORMAT_LIBRARY}" "\${ArpProgramming_ARP_RSC_LIBRARY}" "\${ArpProgramming_ARP_RSC_LIBRARY}" "\${ArpProgramming_ARP_NM_LIBRARY}" "\${ArpProgramming_ARP_NMPAYLOAD_LIBRARY}" "\${ArpProgramming_ARP_SECURITY_LIBRARY}" "\${ArpProgramming_ARP_SECURITY_SERVICES_LIBRARY}" "\${ArpProgramming_ARP_UM_LIBRARY}" "\${ArpProgramming_ARP_VE_LIBRARY}" "\${ArpProgramming_ARP_PLC_DOMAIN_LIBRARY}" "\${ArpProgramming_ARP_PLC_GDS_LIBRARY}" "\${ArpProgramming_ARP_PLC_META_LIBRARY}" "\${ArpProgramming_ARP_DEVICE_INTERFACE_LIBRARY}" "\${ArpProgramming_ARP_IO_AXIOLINE_LIBRARY}" "\${ArpProgramming_ARP_IO_INTERBUS_LIBRARY}" "\${ArpProgramming_ARP_IO_PROFINETSTACK_LIBRARY}" "\${ArpProgramming_ARP_SERVICES_NOTIFICATIONLOGGER_LIBRARY}" "\${ArpProgramming_ARP_SERVICES_OPCUASERVER_LIBRARY}" "\${ArpProgramming_ARP_SERVICES_TRACECONTROLLER_LIBRARY}")
endif()
EOF
}
