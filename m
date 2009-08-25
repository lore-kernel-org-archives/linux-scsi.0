From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/7] qla2xxx: Update for 2.6.32
Date: Tue, 25 Aug 2009 11:36:14 -0700
Message-ID: <1251225381-768-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47025 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755832AbZHYSgV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 14:36:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Please apply...

Andrew Vasquez (4):
  qla2xxx: Add firmware-dump kobject uevent notification.
  qla2xxx: Further limit device-table (qla_devtbl) lookup to non-24xx.
  qla2xxx: Correct various NPIV issues.
  qla2xxx: Properly delete rports attached to a vport.

Giridhar Malavali (1):
  qla2xxx: Update version number to 8.03.01-k6.

Lalit Chandivade (1):
  qla2xxx: Correct qla2x00_eh_wait_on_command() to wait correctly.

Santosh Vernekar (1):
  qla2xxx: Correctly set FCF_TAPE_PRESENT flag based on scsi-device.

 drivers/scsi/qla2xxx/qla_attr.c    |    5 ++
 drivers/scsi/qla2xxx/qla_dbg.c     |   78 +++++++++++-------------------------
 drivers/scsi/qla2xxx/qla_def.h     |    6 +++
 drivers/scsi/qla2xxx/qla_gbl.h     |    1 +
 drivers/scsi/qla2xxx/qla_init.c    |   19 +++++----
 drivers/scsi/qla2xxx/qla_isr.c     |    7 ++-
 drivers/scsi/qla2xxx/qla_mid.c     |   30 ++++++-------
 drivers/scsi/qla2xxx/qla_os.c      |   71 +++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 9 files changed, 119 insertions(+), 100 deletions(-)

