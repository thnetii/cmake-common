function(extract_tarball MODE FILEPATH TARGET_DIRECTORY WORKING_DIRECTORY)
  set(tarball_decompress_msg "Decompressing ${FILEPATH}")
  message(STATUS "${tarball_decompress_msg}")
  if(NOT WORKING_DIRECTORY)
    set(WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
  endif(NOT WORKING_DIRECTORY)
  if(NOT IS_DIRECTORY "${TARGET_DIRECTORY}")
    execute_process(
      COMMAND "${CMAKE_COMMAND}" -E tar xf${MODE} "${FILEPATH}"
      WORKING_DIRECTORY "${WORKING_DIRECTORY}"
      RESULT_VARIABLE tarball_result
    )
    if(tarball_result)
      message(FATAL_ERROR "Failed to decompress downloaded source tarball ${FILEPATH}")
    endif(tarball_result)
    message(STATUS "${tarball_decompress_msg} -- complete")
  else()
    message(STATUS "${tarball_decompress_msg} -- skipped, directory already exists")
  endif(NOT IS_DIRECTORY "${TARGET_DIRECTORY}")
endfunction(extract_tarball)
