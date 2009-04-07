From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 00/15] qla2xxx: updates for 2.6.30 [8.03.01-k2]
Date: Mon,  6 Apr 2009 22:33:36 -0700
Message-ID: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZDGFdy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 01:33:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Another round of updates/fixes for 2.6.30.

--

Andrew Vasquez (7):
  qla2xxx: Export additional FCoE attributes for application support.
  qla2xxx: Correct compilation failures when DEBUG'n' options are
    enabled.
  qla2xxx: Correct typo in read_nvram() callback.
  qla2xxx: Restrict model-name/description device-table usage.
  qla2xxx: Don't try to 'stop' firmware if already in ROM code.
  qla2xxx: Add an override option to specify ISP firmware load
    semantics.
  qla2xxx: Update version number to 8.03.01-k2.

Anirban Chakraborty (4):
  qla2xxx: Add QoS support.
  qla2xxx: Add CPU affinity support.
  qla2xxx: Remove reference to request queue from scsi request block.
  qla2xxx: Use port number to compute nvram/vpd parameter offsets.

Harish Zunjarrao (1):
  qla2xxx: Correct hard-coded address of a second-port's NVRAM.

Joe Carnuccio (1):
  qla2xxx: Perform an implicit login to the Management Server.

Michael Reed (1):
  qla2xxx: Conditionally disable automatic queue full tracking.

Seokmann Ju (1):
  qla2xxx: Correct bus-reset behaviour with recent ISPs.

 drivers/scsi/qla2xxx/qla_attr.c    |   81 ++++++++++---
 drivers/scsi/qla2xxx/qla_dbg.c     |    7 +-
 drivers/scsi/qla2xxx/qla_def.h     |   34 ++++--
 drivers/scsi/qla2xxx/qla_fw.h      |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   29 +++--
 drivers/scsi/qla2xxx/qla_gs.c      |    2 +-
 drivers/scsi/qla2xxx/qla_init.c    |   90 +++++++++------
 drivers/scsi/qla2xxx/qla_iocb.c    |   59 +++++----
 drivers/scsi/qla2xxx/qla_isr.c     |  236 ++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_mbx.c     |   90 ++++++++++-----
 drivers/scsi/qla2xxx/qla_mid.c     |  118 +++++++++----------
 drivers/scsi/qla2xxx/qla_os.c      |  233 ++++++++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_sup.c     |   38 +++---
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 14 files changed, 611 insertions(+), 410 deletions(-)

