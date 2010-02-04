From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/1] qla2xxx: fix for 2.6.33-rcX
Date: Thu,  4 Feb 2010 14:17:58 -0800
Message-ID: <1265321879-1227-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46623 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1757496Ab0BDWSA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Feb 2010 17:18:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Please ignore my previous patch as it was incomplete. 
Can you please apply this patch. This is a critical fix which can cause
panic issues (found on PPC). This needs to be back ported to stable kernel.


Anirban Chakraborty (1):
  qla2xxx: Obtain proper host structure during response-queue
    processing.

 drivers/scsi/qla2xxx/qla_gbl.h |    1 -
 drivers/scsi/qla2xxx/qla_isr.c |   29 +----------------------------
 drivers/scsi/qla2xxx/qla_mid.c |    8 +++++---
 3 files changed, 6 insertions(+), 32 deletions(-)

