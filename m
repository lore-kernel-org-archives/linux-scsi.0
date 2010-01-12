From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/4]  qla2xxx: fixes for 2.6.33-rc3 [8.03.01-k10]
Date: Tue, 12 Jan 2010 12:59:47 -0800
Message-ID: <1263329991-307-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:54864 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752857Ab0ALU74 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2010 15:59:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Please apply following patches.


Andrew Vasquez (2):
  qla2xxx: Correct FCP2 recovery handling.
  qla2xxx: Perform fast mailbox read of flash regardless of size nor
    address alignment.

Giridhar Malavali (1):
  qla2xxx: Update version number to 8.03.01-k10.

Harish Zunjarrao (1):
  fc-transport: Use packed modifier for fc_bsg_request structure.

 drivers/scsi/qla2xxx/qla_def.h     |    3 +--
 drivers/scsi/qla2xxx/qla_init.c    |   12 ++++++------
 drivers/scsi/qla2xxx/qla_os.c      |   12 ++++++------
 drivers/scsi/qla2xxx/qla_sup.c     |    3 +++
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 include/scsi/scsi_bsg_fc.h         |    2 +-
 6 files changed, 18 insertions(+), 16 deletions(-)

