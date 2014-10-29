/* 
 * File:   Filenames.h
 * Author: Richard Greene
 * 
 * Names of named pipes and other shared files.
 *
 * Created on May 19, 2014, 11:17 AM
 */

#ifndef FILENAMES_H
#define	FILENAMES_H

#define CAPE_MANAGER_SLOTS_FILE ("/sys/devices/bone_capemgr.9/slots")
#define BOARD_SERIAL_NUM_FILE ("/sys/bus/i2c/devices/0-0050/eeprom")
#define THERMOMETER_FILE ("/mnt/1wire/22.*/temperature")

#define PRINTER_STATUS_PIPE ("/tmp/PrinterStatusPipe")

#define ROOT_DIR "/var/smith"

#define IMAGE_EXTENSION "png"
#define IMAGE_FILE_FILTER ("/*." IMAGE_EXTENSION)

#define PRINT_FILE_EXTENSION "tar.gz"
#define PRINT_FILE_FILTER ("/*." PRINT_FILE_EXTENSION)

#define SLICE_IMAGE_PREFIX "slice"

#define TEST_PATTERN_FILE "/TestPattern.png"
#define TEST_PATTERN (ROOT_DIR TEST_PATTERN_FILE)

#define SETTINGS_FILE "/settings"
#define SETTINGS_SUB_DIR "/config"
#define SETTINGS_PATH (ROOT_DIR SETTINGS_SUB_DIR SETTINGS_FILE)

#define EMBEDDED_PRINT_SETTINGS_FILE "/printsettings"


#endif	/* FILENAMES_H */