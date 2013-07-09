From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 4/8] libfc: Remove extra space in fc_exch_timer_cancel
 definition
Date: Tue, 09 Jul 2013 12:47:26 -0700
Message-ID: <20130709194726.10724.90924.stgit@fritz>
References: <20130709194705.10724.64013.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:36029 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab3GITr1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jul 2013 15:47:27 -0400
In-Reply-To: <20130709194705.10724.64013.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Morgan <jack.morgan@intel.com>, Neil Horman <nhorman@tuxdriver.com>

Simply remove an extra space that violates coding style.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Jack Morgan <jack.morgan@intel.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 drivers/scsi/libfc/fc_exch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 8b928c6..e98ea6a 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -337,7 +337,7 @@ static void fc_exch_release(struct fc_exch *ep)
  * fc_exch_timer_cancel() - cancel exch timer
  * @ep:		The exchange whose timer to be canceled
  */
-static inline  void fc_exch_timer_cancel(struct fc_exch *ep)
+static inline void fc_exch_timer_cancel(struct fc_exch *ep)
 {
 	if (cancel_delayed_work(&ep->timeout_work)) {
 		FC_EXCH_DBG(ep, "Exchange timer canceled\n");

