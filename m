From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/1] qla2xxx: fix for 2.6.33-rcX
Date: Tue,  2 Feb 2010 19:48:32 -0800
Message-ID: <1265168913-353-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:58453 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751874Ab0BCDsf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2010 22:48:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, stable@kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Can you please apply this patch. This is a critical fix which can cause
panic issues (found on PPC). This needs to be back ported to stable kernel.

Andrew Vasquez (1):
  qla2xxx: Obtain proper host structure during response-queue
    processing.

 drivers/scsi/qla2xxx/qla_isr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

