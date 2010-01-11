From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/6] qla2xxx: qla2xxx: fixes for 2.6.33-rc3 [8.03.02-k0]
Date: Mon, 11 Jan 2010 11:32:11 -0800
Message-ID: <1263238337-363-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:60660 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753952Ab0AKTcS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jan 2010 14:32:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Please apply following patches.

Andrew Vasquez (2):
  qla2xxx: Correct FCP2 recovery handling.
  qla2xxx: Perform fast mailbox read  of flash regardless of size nor
    address alignment.

Giridhar Malavali (2):
  qla2xxx: Add BSG support for FC ELS/CT passthrough and vendor
    commands.
  qla2xxx: Update version number to 8.03.02-k0.

Harish Zunjarrao (1):
  fc-transport: Use packed modifier for fc_bsg_request structure.

Joe Carnuccio (1):
  qla2xxx: Enhance EEH support and enable AER support.

 drivers/scsi/qla2xxx/qla_attr.c    |  746 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_def.h     |  158 ++++++++-
 drivers/scsi/qla2xxx/qla_fw.h      |   33 ++
 drivers/scsi/qla2xxx/qla_gbl.h     |    5 +
 drivers/scsi/qla2xxx/qla_init.c    |   26 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |  120 ++++++
 drivers/scsi/qla2xxx/qla_isr.c     |  110 +++++-
 drivers/scsi/qla2xxx/qla_mbx.c     |  151 ++++++++
 drivers/scsi/qla2xxx/qla_os.c      |   53 ++-
 drivers/scsi/qla2xxx/qla_sup.c     |    3 +
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 include/scsi/scsi_bsg_fc.h         |    2 +-
 12 files changed, 1372 insertions(+), 39 deletions(-)

