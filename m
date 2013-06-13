From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH 00/10] [RFC] SCSI: esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver
Date: Thu, 13 Jun 2013 10:30:58 -0400
Message-ID: <1371133868-13794-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:14379 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758335Ab3FMOqz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jun 2013 10:46:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jseba@attotech.com, jbottomley@parallels.com, Bradley Grove <bgrove@attotech.com>


This is a new driver for ATTO Technology's ExpressSAS series of hardware RAID 
adapters.  It supports the following adapters:

    - ExpressSAS R60F
    - ExpressSAS R680
    - ExpressSAS R608
    - ExpressSAS R644

This patch is split into ten parts to make reviewing easier.   You'll need to
apply all of them to get the complete patch.

We have done some testing under x86 and x64 architectures, but the code is 
still under development and we expect to find additional issues.  We appreciate
any review comments.

Bradley Grove (10):
  [RFC] SCSI: esas2r: Add main header file
  [RFC] SCSI: esas2r: Add main file
  [RFC] SCSI: esas2r: Add initialization functions
  [RFC] SCSI: esas2r: Add device discovery and logging functions
  [RFC] SCSI: esas2r: Add interrupt and IO functions
  [RFC] SCSI: esas2r: Add flash and target database functions
  [RFC] SCSI: esas2r: Add IOCTL header file
  [RFC] SCSI: esas2r: Add IOCTL functions
  [RFC] SCSI: esas2r: Add ATTO VDA Firmware API headers and functions. 
    This API is used to control and manage the RAID adapter.
  [RFC] SCSI: esas2r: Add Makefile, Kconfig, and MAINTAINERS files

 MAINTAINERS                         |    9 +-
 drivers/scsi/Kconfig                |    1 +
 drivers/scsi/Makefile               |    1 +
 drivers/scsi/esas2r/Kconfig         |    6 +
 drivers/scsi/esas2r/Makefile        |    6 +
 drivers/scsi/esas2r/atioctl.h       | 1254 ++++++++++++++++++++
 drivers/scsi/esas2r/atvda.h         | 1327 +++++++++++++++++++++
 drivers/scsi/esas2r/esas2r.h        | 1755 ++++++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_disc.c   | 1192 +++++++++++++++++++
 drivers/scsi/esas2r/esas2r_flash.c  | 1518 ++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_init.c   | 2019 ++++++++++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_int.c    |  935 +++++++++++++++
 drivers/scsi/esas2r/esas2r_io.c     |  886 ++++++++++++++
 drivers/scsi/esas2r/esas2r_ioctl.c  | 2110 +++++++++++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_log.c    |  255 ++++
 drivers/scsi/esas2r/esas2r_log.h    |  118 ++
 drivers/scsi/esas2r/esas2r_main.c   | 2177 +++++++++++++++++++++++++++++++++++
 drivers/scsi/esas2r/esas2r_targdb.c |  306 +++++
 drivers/scsi/esas2r/esas2r_vda.c    |  526 +++++++++
 19 files changed, 16400 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/esas2r/Kconfig
 create mode 100644 drivers/scsi/esas2r/Makefile
 create mode 100644 drivers/scsi/esas2r/atioctl.h
 create mode 100644 drivers/scsi/esas2r/atvda.h
 create mode 100644 drivers/scsi/esas2r/esas2r.h
 create mode 100644 drivers/scsi/esas2r/esas2r_disc.c
 create mode 100644 drivers/scsi/esas2r/esas2r_flash.c
 create mode 100644 drivers/scsi/esas2r/esas2r_init.c
 create mode 100644 drivers/scsi/esas2r/esas2r_int.c
 create mode 100644 drivers/scsi/esas2r/esas2r_io.c
 create mode 100644 drivers/scsi/esas2r/esas2r_ioctl.c
 create mode 100644 drivers/scsi/esas2r/esas2r_log.c
 create mode 100644 drivers/scsi/esas2r/esas2r_log.h
 create mode 100644 drivers/scsi/esas2r/esas2r_main.c
 create mode 100644 drivers/scsi/esas2r/esas2r_targdb.c
 create mode 100644 drivers/scsi/esas2r/esas2r_vda.c

-- 
1.8.1.4

