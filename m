From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/2] fc_transport: Fix for FC pass thru support
Date: Fri, 19 Jun 2009 16:26:52 -0700
Message-ID: <1245454014-1889-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:57597 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751953AbZFSXcq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2009 19:32:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Please apply

---
Giridhar Malavali (2):
  fc_transport: The softirq_done function registration for BSG request
  fc_transport: Selective return value from BSG timeout function

 drivers/scsi/scsi_transport_fc.c |   42 ++++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 19 deletions(-)

