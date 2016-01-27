/*
   Copyright (c) 2015, The Linux Foundation. All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>

#include "vendor_init.h"
#include "property_service.h"
#include "log.h"
#include "util.h"

#include "init_msm.h"

#define RAW_ID_PATH     "/sys/devices/system/soc/soc0/raw_id"
#define BUF_SIZE         64

#define BOOTINFO_PATH   "/sys/bootinfo/hw_version"

#define HW_MAJOR_VERSION_SHIFT 4
#define HW_MAJOR_VERSION_MASK  0xF0
#define HW_MINOR_VERSION_SHIFT 0
#define HW_MINOR_VERSION_MASK  0x0F

static char tmp[BUF_SIZE];
static char buff_tmp[BUF_SIZE];

const char *mixer_paths_prefix = "/system/etc/";
const char *v3_mixer_paths = "mixer_paths_3_x.xml";
const char *v4_mixer_paths = "mixer_paths_4_x.xml";
const char *v5_mixer_paths = "mixer_paths_5_x.xml";
const char *def_mixer_paths = "mixer_paths.xml";

static int read_file2(const char *fname, char *data, int max_size)
{
    int fd, rc;

    if (max_size < 1)
        return 0;

    fd = open(fname, O_RDONLY);
    if (fd < 0) {
        ERROR("failed to open '%s'\n", fname);
        return 0;
    }

    rc = read(fd, data, max_size - 1);
    if ((rc > 0) && (rc < max_size))
        data[rc] = '\0';
    else
        data[0] = '\0';
    close(fd);

    return 1;
}

unsigned long get_hw_version(){
    int rc = 0;
    unsigned long hw_ul;

    rc = read_file2(BOOTINFO_PATH, buff_tmp, sizeof(buff_tmp));
    if(rc) {
        hw_ul = strtoul(buff_tmp, NULL, 0);
        return hw_ul;    
    } else {
        return 75;
    }
    
}

unsigned long get_hw_version_major() {
	return ((get_hw_version() & HW_MAJOR_VERSION_MASK) >> HW_MAJOR_VERSION_SHIFT);
}

unsigned long get_hw_version_minor() {
	return ((get_hw_version() & HW_MINOR_VERSION_MASK) >> HW_MINOR_VERSION_SHIFT);
}

unsigned long real_hw_version() {
        return ((get_hw_version_major() * 10) + get_hw_version_minor());
}

const char *get_mixer_paths()
{
    unsigned long hw_major,hw_minor;
    const char *tmp_mixer_paths;

    hw_major = get_hw_version_major();
    hw_minor = get_hw_version_minor();

    if(hw_major == 3){

        tmp_mixer_paths = v3_mixer_paths;

    } else if (hw_major == 4) {

        tmp_mixer_paths = v4_mixer_paths;

    } else if (hw_major == 5) {

        tmp_mixer_paths = v5_mixer_paths;

    } else {

       tmp_mixer_paths = def_mixer_paths;

    }

    return tmp_mixer_paths;
}

void init_msm_properties(unsigned long msm_id, unsigned long msm_ver, char *board_type)
{
    int rc;
    unsigned long raw_id = -1;

    UNUSED(msm_id);
    UNUSED(msm_ver);
    UNUSED(board_type);

    /* set ro.hwversion */
    const int hwv_len = snprintf(NULL, 0, "%lu", real_hw_version());
    char hwv_buff [hwv_len + 1];
    snprintf(hwv_buff, hwv_len + 1, "%lu", real_hw_version());
    property_set("ro.hwversion", hwv_buff);

    /* set mixer paths props */
    property_set("audio.mixer_paths.config", (char*) get_mixer_paths());

    /* get raw ID */
    rc = read_file2(RAW_ID_PATH, tmp, sizeof(tmp));
    if (rc) {
        raw_id = strtoul(tmp, NULL, 0);
    }

    /* MI 3W  */
    if (raw_id==1978) {
        property_set("ro.product.model", "MI 3W");
        property_set("ro.product.device", "cancro");
        property_set("ro.product.name", "cancro");
    } else

    /* MI 4W  */
    if (raw_id==1974) {
        property_set("ro.product.model", "MI 4W");
        property_set("ro.product.device", "cancro");
        property_set("ro.product.name", "cancro");
    } else

    /* MI 4LTE-CU  */
    if (raw_id==1972) {
        property_set("ro.product.model", "MI 4LTE");
        property_set("ro.product.device", "cancro");
        property_set("ro.product.name", "cancro_wc_lte");
    }

    /* ??? */
    else {
        property_set("ro.product.model", "MI 3/4"); // this should never happen.
    }
}
