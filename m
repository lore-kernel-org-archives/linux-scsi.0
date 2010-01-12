From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/4] qla2xxx: Updates for scsi-misc-2.6.
Date: Tue, 12 Jan 2010 13:02:45 -0800
Message-ID: <1263330169-347-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:35934 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752079Ab0ALVCu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2010 16:02:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Please apply these patches.

Giridhar Malavali (3):
  qla2xxx: Add BSG support for FC ELS/CT passthrough and vendor
    commands.
  qla2xxx: Remove firmware hint for 81xx parts.
  qla2xxx: Update version number to 8.03.02-k0.

Joe Carnuccio (1):
  qla2xxx: Enhance EEH support and enable AER support.

 drivers/scsi/qla2xxx/qla_attr.c    |  746 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_def.h     |  155 ++++++++
 drivers/scsi/qla2xxx/qla_fw.h      |   33 ++
 drivers/scsi/qla2xxx/qla_gbl.h     |    5 +
 drivers/scsi/qla2xxx/qla_init.c    |   14 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |  120 ++++++
 drivers/scsi/qla2xxx/qla_isr.c     |  110 +++++-
 drivers/scsi/qla2xxx/qla_mbx.c     |  151 ++++++++
 drivers/scsi/qla2xxx/qla_os.c      |   42 ++-
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 10 files changed, 1355 insertions(+), 25 deletions(-)

