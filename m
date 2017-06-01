From: "Milan P. Gandhi" <mgandhi@redhat.com>
Subject: [PATCH] Fix few small typos in fcoe.c
Date: Thu, 1 Jun 2017 17:35:49 +0530
Message-ID: <656c7fa1-fce4-8a72-1cbe-32a47da5cec2@redhat.com>
Reply-To: mgandhi@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, Johannes Thumshirn <jth@kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch does a cleanup and fixes few small typos in fcoe.c

Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
 drivers/scsi/fcoe/fcoe.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 90939f6..7b960d3 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -519,7 +519,7 @@ static void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
  * @skb:      The receive skb
  * @netdev:   The associated net device
  * @ptype:    The packet_type structure which was used to register this handler
- * @orig_dev: The original net_device the the skb was received on.
+ * @orig_dev: The original net_device the skb was received on.
  *	      (in case dev is a bond)
  *
  * Returns: 0 for success
@@ -542,7 +542,7 @@ static int fcoe_fip_recv(struct sk_buff *skb, struct net_device *netdev,
  * @skb:      The receive skb
  * @netdev:   The associated net device
  * @ptype:    The packet_type structure which was used to register this handler
- * @orig_dev: The original net_device the the skb was received on.
+ * @orig_dev: The original net_device the skb was received on.
  *	      (in case dev is a bond)
  *
  * Returns: 0 for success
@@ -2590,7 +2590,7 @@ module_exit(fcoe_exit);
  * fcoe_flogi_resp() - FCoE specific FLOGI and FDISC response handler
  * @seq: active sequence in the FLOGI or FDISC exchange
  * @fp: response frame, or error encoded in a pointer (timeout)
- * @arg: pointer the the fcoe_ctlr structure
+ * @arg: pointer to the fcoe_ctlr structure
  *
  * This handles MAC address management for FCoE, then passes control on to
  * the libfc FLOGI response handler.
@@ -2619,7 +2619,7 @@ static void fcoe_flogi_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
  * fcoe_logo_resp() - FCoE specific LOGO response handler
  * @seq: active sequence in the LOGO exchange
  * @fp: response frame, or error encoded in a pointer (timeout)
- * @arg: pointer the the fcoe_ctlr structure
+ * @arg: pointer to the fcoe_ctlr structure
  *
  * This handles MAC address management for FCoE, then passes control on to
  * the libfc LOGO response handler.
