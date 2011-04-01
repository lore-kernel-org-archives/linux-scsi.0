From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/11] libfc: remove duplicate ema_list init
Date: Fri, 01 Apr 2011 16:06:35 -0700
Message-ID: <20110401230635.15001.76122.stgit@localhost6.localdomain6>
References: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37808 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab1DAXGf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 19:06:35 -0400
In-Reply-To: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

As ema_list is already initialized by libfc_host_alloc.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_lport.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 8c08b21..735f1f8 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1590,7 +1590,6 @@ void fc_lport_enter_flogi(struct fc_lport *lport)
  */
 int fc_lport_config(struct fc_lport *lport)
 {
-	INIT_LIST_HEAD(&lport->ema_list);
 	INIT_DELAYED_WORK(&lport->retry_work, fc_lport_timeout);
 	mutex_init(&lport->lp_mutex);
 

