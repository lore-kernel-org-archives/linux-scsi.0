From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/1] qla2xxx: fix for 2.6.33-rcX
Date: Mon, 15 Feb 2010 16:42:08 -0800
Message-ID: <1266280929-12445-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:50351 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S932299Ab0BPAmL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Feb 2010 19:42:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@kroah.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, stable@kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Hi Greg,

Please find the patch which applies fine with stable kernel 2.6.32-8.

Anirban Chakraborty (1):
  qla2xxx: Obtain proper host structure during response-queue
    processing.

 drivers/scsi/qla2xxx/qla_gbl.h |    1 -
 drivers/scsi/qla2xxx/qla_isr.c |   29 +----------------------------
 drivers/scsi/qla2xxx/qla_mid.c |    6 +++++-
 3 files changed, 6 insertions(+), 30 deletions(-)

