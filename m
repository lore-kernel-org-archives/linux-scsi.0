From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 00/17] Updates for the be2iscsi driver.
Date: Sat, 29 Sep 2012 07:01:06 +0530
Message-ID: <28f86bb7-b94e-4e0c-bfd6-b816639b7d57@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5818 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab2I2BcL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2012 21:32:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>

 Patches to update the be2iscsi driver. These patches were generated
 against the scsi tree misc heads.

Jayamohan Kallickal (1):
  be2iscsi: Fix the kernel panic in blkiopoll disable mode

John Soni Jose (15):
  be2iscsi: Display Completion Event string instead of opcode
  be2iscsi: Fix memory leak in control path of driver
  be2iscsi: Fix max supported EQ count to 8.
  be2iscsi: Display driver name and version in device attribute
  be2iscsi: Issue an FLR when driver is loaded.
  be2iscsi: Fix return value
  be2iscsi: Fix support for Skyhawk Adapters
  be2iscsi: Fix max EQ supported by the driver.
  be2iscsi: Fix CQ create MBX CMD for Skyhawk.
  be2iscsi: Fix WRB support for Skyhawk adapters.
  be2iscsi: Fix context update for session in Skyhawk.
  be2iscsi: Fix Task Completion Event handling for Skyhawk
  be2iscsi: Fix issue of displaying adapter family.
  be2iscsi: Fix the copyright information
  be2iscsi: Bump the driver version

Minh Tran (1):
  be2iscsi: Fix the issue with soft reset.

 drivers/scsi/be2iscsi/be.h       |    9 +-
 drivers/scsi/be2iscsi/be_cmds.c  |   42 ++-
 drivers/scsi/be2iscsi/be_cmds.h  |   83 +++-
 drivers/scsi/be2iscsi/be_iscsi.c |   10 +-
 drivers/scsi/be2iscsi/be_iscsi.h |    2 +-
 drivers/scsi/be2iscsi/be_main.c  |  974 +++++++++++++++++++++++++-------------
 drivers/scsi/be2iscsi/be_main.h  |  143 +++++-
 drivers/scsi/be2iscsi/be_mgmt.c  |  195 ++++++++-
 drivers/scsi/be2iscsi/be_mgmt.h  |   16 +-
 9 files changed, 1106 insertions(+), 368 deletions(-)

-- 
1.7.2

