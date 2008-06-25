From: Douglas Gilbert <dougg@torque.net>
Subject: [Announce] sg3_utils-1.26 available
Date: Wed, 25 Jun 2008 13:05:11 -0400
Message-ID: <48627AC7.5030301@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:52606 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYFYRF2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2008 13:05:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: emschwar@debian.org, "Robin H. Johnson" <robbat2@gentoo.org>

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series. In the lk 2.6
series these utilities (except sgp_dd) can be used with any
devices that support the SG_IO ioctl. Ported to FreeBSD,
Tru64, Solaris, and Windows (cygwin and mingw).

This version adds one new utility: sg_sat_phy_event. Various
changes made by www.t10.org in the last 8 months are reflected
in this version. There has been more work on moving large tables
of data out into separate files. Copy of ChangeLog below.

For an overview of sg3_utils and downloads see this page:
http://www.torque.net/sg/sg3_utils.html
The sg_dd utility has its own page at:
http://www.torque.net/sg/sg_dd.html
The SG_IO ioctl is discussed at:
http://www.torque.net/sg/sg_io.html
A full changelog can be found at:
http://www.torque.net/sg/p/sg3_utils.CHANGELOG

A release announcement has been sent to freshmeat.net .

Top of Changelog:
Changelog for sg3_utils-1.26 [20080625] [svn: r183]
   - sg_sat_phy_event: new utility; copied from examples
     directory and enhanced, rename original to sg__sat_phy_event
   - sg_ses: sync with ses2r19b, many nomenclature changes
   - sg_get_config: sync with mmc6r01
     - allow Microcode upgrade and DVD read feature descriptors
       to be 4 bytes long
     - add '--raw' option
   - sg_verify: add --vrprotect= option
   - sg_vpd: add nominal form factor to block dev. char. VPD page
     - add --maxlen= option to set allocation length in cdb
   - sg_inq: add --maxlen= option that does same as --len=
     - move version descriptors (spc4r15) to sg_inq_data.c file
   - sg_inq+sg_vpd: logic for "NAA-3 Locally assigned" identifier
     - update extended inquiry VPD page
   - sg_modes: add --maxlen= option to specify allocation length
   - sg_start: add '--noflush' and '--mod=PC_MOD' options (sbc3r14)
   - sg_request: add a '--progress' option (similar to sg_turs)
     - add --maxlen= option to set allocation length in cdb
   - sg_luns: add --maxlen= option to specify allocation length
   - sg_dd: improve MMC handling of 'illegal mode for this track'
     read errors (with ILI and info field)
   - sg_dd, sgm_dd, sgp_dd, sginfo, sg_rbuf, sg_read: replace
     "%lld" and friends with PRI macros
   - sg_opcodes: tmf name change in spc4r15 (async event)
   - sg_turs: add more to man page about '--progress' indication
   - sg_write_long: add examples section to man page
   - '--raw' option: modify utilities that can send binary output
     to call sg_set_binary_mode(). For MingGW port CR problem.
   - sg_lib: update asc/ascq and command name strings to spc4r15
     - split sg_lib into sg_lib_data.[hc] and sg_lib.[hc]
     - split sg_cmds_extra into sg_cmds_extra and sg_cmds_mmc
     - add osd2r03 service actions (all different from osd-r10)
     - add sg_get_trans_proto_str()
     - add sg_get_sense_filemark_eom_ili() function (MMC uses ILI)
     - add sense key specific unit attention condition queue
       overflow decoding (added in spc4r13)
     - add sg_set_text_mode() and sg_set_binary_mode() functions
       for non-Unix OSes
   - sg_cmds_mmc: add sg_ll_set_streaming() function
   - sg_cmds_extra: add vrprotect argument to sg_ll_verify10()
     - add sg_ll_get_performance() and sg_ll_set_cd_speed()
   - change 'long long' to int64_t and 'unsigned long long' to
     uint64_t to stress that 64 bit integer wanted, not larger
   - audit of dangerous 'u64 = uch[24] << 24' code, replace most
     'unsigned long's
   - multiple documentation corrections provided by Dan Horak
   - win32/MinGW: define SG3_UTILS_MINGW when detected
   - remove archive/pre_configure subdirectory
   - move sg_io_linux.c into the lib subdirectory
   - utils/hxascdmp: add hxascdmp(1) man page
   - switch primary build to ubuntu environment, rename
     library to libsgutils2 to avoid clash

Changelog for sg3_utils-1.25 [20071016] [svn: r115]
....


Doug Gilbert
