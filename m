From: Marvin Stodolsky <stodolsk@rcn.com>
Subject: PROBLEM:drivers/scsi: In function `sdebug_scatg2virt
Date: Sat, 13 Apr 2002 21:26:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CB8E8BA.5855149E@rcn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 66-44-2-122.s630.apx1.lnh.md.dialup.rcn.com ([66.44.2.122] helo=rcn.com)
	by smtp02.mrf.mail.rcn.net with esmtp (Exim 3.33 #10)
	id 16wo8u-0005wV-00
	for linux-scsi@vger.kernel.org; Sun, 14 Apr 2002 13:50:25 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[1.]  scsi_debug.c:521: structure has no member named `address' 
[2.]  Compile with 2.5.7 sources fails within:
/usr/bin/make -C scsi modules
make[3]: Entering directory `/usr/src/Lnx/linux-2.5.7/drivers/scsi'
at subsection:
 gcc -D__KERNEL__ -I/usr/src/Lnx/linux-2.5.7/include -Wall
-Wstrict-prototypes -Wno-trigraphs -O2 -fomit-frame-pointer
-fno-strict-aliasing -fno-common -pipe -mpreferred-stack-boundary=2
-march=i686 -DMODULE -DMODVERSIONS -include
/usr/src/Lnx/linux-2.5.7/include/linux/modversions.h 
-DKBUILD_BASENAME=scsi_debug  -c -o scsi_debug.o scsi_debug.c
scsi_debug.c: In function `sdebug_scatg2virt':
scsi_debug.c:521: structure has no member named `address'
scsi_debug.c:526: warning: control  reaches end of non-void function
make[3]: *** [scsi_debug.o] Error 1
make[3]: Leaving directory `/usr/src/Lnx/linux-2.5.7/drivers/scsi'
make[2]: *** [_modsubdir_scsi] Error 2
make[2]: Leaving directory `/usr/src/Lnx/linux-2.5.7/drivers'
make[1]: *** [_mod_drivers] Error 2
make[1]: Leaving directory `/usr/

3) using 
gcc --version 2.95.4
GNU Make version 3.79.
GNU ld version 2.12.90.0.1 20020307 Debian/GNU Linux
Compiling under a 2.4.18 kernel
=========
 grep -v not /usr/src/linux/.config , SCSI section
#
# SCSI support
#
CONFIG_SCSI=m

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_SD_EXTRA_DEVS=40
CONFIG_CHR_DEV_SG=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y

#
# SCSI low-level drivers
#
CONFIG_SCSI_DEBUG=m

