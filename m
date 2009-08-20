From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/2] qla2xxx: Updates for 2.6.32
Date: Thu, 20 Aug 2009 11:06:03 -0700
Message-ID: <1250791565-285-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:59439 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755048AbZHTSGG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 14:06:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Please apply...

Andrew Vasquez (2):
  qla2xxx: Generalize srb structure usage.
  qla2xxx: Add asynchronous-login support.

 drivers/scsi/qla2xxx/qla_def.h  |   35 ++++++
 drivers/scsi/qla2xxx/qla_gbl.h  |   20 +++
 drivers/scsi/qla2xxx/qla_init.c |  215 +++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c |  204 +++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c  |  250 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_mid.c  |    2 +
 drivers/scsi/qla2xxx/qla_os.c   |   83 ++++++++++++--
 7 files changed, 798 insertions(+), 11 deletions(-)

