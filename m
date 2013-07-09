From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 5/8] libfc: Differentiate echange timer cancellation debug
 statements
Date: Tue, 09 Jul 2013 12:47:31 -0700
Message-ID: <20130709194731.10724.49186.stgit@fritz>
References: <20130709194705.10724.64013.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19212 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab3GITrc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jul 2013 15:47:32 -0400
In-Reply-To: <20130709194705.10724.64013.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Morgan <jack.morgan@intel.com>, Neil Horman <nhorman@tuxdriver.com>

There are two debug statements with the same output string regarding
echange timer cancellation. This patch simply changes the output of
one string so that they can be differentiated.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Jack Morgan <jack.morgan@intel.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 drivers/scsi/libfc/fc_exch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index e98ea6a..5879929 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1567,7 +1567,7 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 		    fc_exch_rctl_name(fh->fh_r_ctl));
 
 	if (cancel_delayed_work_sync(&ep->timeout_work)) {
-		FC_EXCH_DBG(ep, "Exchange timer canceled\n");
+		FC_EXCH_DBG(ep, "Exchange timer canceled due to ABTS response\n");
 		fc_exch_release(ep);	/* release from pending timer hold */
 	}
 

