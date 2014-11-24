From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/6] SCSI-libfc: Fix typos for the word "destroy"
Date: Mon, 24 Nov 2014 18:15:11 +0100
Message-ID: <5473679F.1000909@users.sourceforge.net>
References: <54736422.90409@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54736422.90409@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E. J. Bottomley" <JBottomley@parallels.com>, Robert Love <robert.w.love@intel.com>, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org
Cc: kernel-janitors@vger.kernel.org, trivial@kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Nov 2014 15:40:41 +0100

Identifiers were corrected in descriptions for the functions
fc_fcp_pkt_destroy() and fc_fcp_destroy().

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/libfc/fc_fcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 1d7e76e..5649fc9 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -191,7 +191,7 @@ static void fc_fcp_pkt_hold(struct fc_fcp_pkt *fsp)
 }
 
 /**
- * fc_fcp_pkt_destory() - Release hold on a fcp_pkt
+ * fc_fcp_pkt_destroy() - Release hold on a fcp_pkt
  * @seq: The sequence that the FCP packet is on (required by destructor API)
  * @fsp: The FCP packet to be released
  *
@@ -2216,7 +2216,7 @@ int fc_change_queue_type(struct scsi_device *sdev, int tag_type)
 EXPORT_SYMBOL(fc_change_queue_type);
 
 /**
- * fc_fcp_destory() - Tear down the FCP layer for a given local port
+ * fc_fcp_destroy() - Tear down the FCP layer for a given local port
  * @lport: The local port that no longer needs the FCP layer
  */
 void fc_fcp_destroy(struct fc_lport *lport)
-- 
2.1.3
