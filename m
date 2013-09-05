From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 14/16] fcoe: Declare fcoe_ctlr_mode_set() static
Date: Thu, 05 Sep 2013 12:13:33 -0700
Message-ID: <20130905191333.15235.45035.stgit@fritz>
References: <20130905191218.15235.85917.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10236 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756963Ab3IETN5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Sep 2013 15:13:57 -0400
In-Reply-To: <20130905191218.15235.85917.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Neil Horman <nhorman@tuxdriver.com>

From: Bart Van Assche <bvanassche@acm.org>

The function fcoe_ctlr_mode_set() is local, hence declare it static.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 35b1fb7..9e83a79 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2828,8 +2828,8 @@ unlock:
  * disabled, so that should ensure that this routine is only called
  * when nothing is happening.
  */
-void fcoe_ctlr_mode_set(struct fc_lport *lport, struct fcoe_ctlr *fip,
-			enum fip_state fip_mode)
+static void fcoe_ctlr_mode_set(struct fc_lport *lport, struct fcoe_ctlr *fip,
+			       enum fip_state fip_mode)
 {
 	void *priv;
 

