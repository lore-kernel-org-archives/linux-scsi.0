From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/9]  qla2xxx: fixes for 2.6.32-rc4 [8.03.01-k7]
Date: Tue, 13 Oct 2009 15:16:44 -0700
Message-ID: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:49709 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1761547AbZJMWY7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 18:24:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Please apply..

Andrew Vasquez (5):
  qla2xxx: Add firmware-dump kobject uevent notification.
  qla2xxx: Display additional mailbox registers during AEN handling.
  qla2xxx: Retrieve firmware's maximum number of supported FCFs.
  qla2xxx: Properly check FCP_RSP response-info field after TMF
    completion.
  qla2xxx: Properly re-register FC4/FDMI after physical and logical
    link disruptions.

Giridhar Malavali (2):
  qla2xxx: Set the size of the host buffer used to fetch DCBX and XGMAC
    parameters to 4K.
  qla2xxx: Update version number to 8.03.01-k7

Lalit Chandivade (2):
  qla2xxx: Reread firmware versions information after an ISP abort.
  qla2xxx: Properly handle UNDERRUN completion statuses.

 Documentation/ABI/stable/sysfs-driver-qla2xxx |    8 ++
 drivers/scsi/qla2xxx/qla_dbg.c                |   78 ++++----------
 drivers/scsi/qla2xxx/qla_def.h                |    9 ++-
 drivers/scsi/qla2xxx/qla_gbl.h                |    3 +-
 drivers/scsi/qla2xxx/qla_init.c               |   12 ++-
 drivers/scsi/qla2xxx/qla_isr.c                |  144 ++++++++++++------------
 drivers/scsi/qla2xxx/qla_mbx.c                |   50 +++++++--
 drivers/scsi/qla2xxx/qla_mid.c                |    2 -
 drivers/scsi/qla2xxx/qla_os.c                 |   35 ++++++
 drivers/scsi/qla2xxx/qla_version.h            |    2 +-
 10 files changed, 197 insertions(+), 146 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-driver-qla2xxx

