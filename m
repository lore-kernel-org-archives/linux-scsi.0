From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 1/1] cxgb4i: Increased the value of MAX_IMM_TX_PKT_LEN
 from 128 to 256 bytes
Date: Wed, 09 Sep 2015 11:49:38 -0700
Message-ID: <201509091849.t89Inc0f016816@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:22767 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbIISuG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2015 14:50:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kxie@chelsio.com, hch@infradead.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

This helps improving the latency of small packets.

Signed-off-by: Rakesh Ranjan <rakesh@chelsio.com>
Signed-off-by: Karen Xie <kxie@chelsio.com>

---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index de6feb8..804806e 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -160,7 +160,7 @@ static struct scsi_transport_template *cxgb4i_stt;
 
 #define DIV_ROUND_UP(n, d)	(((n) + (d) - 1) / (d))
 #define RCV_BUFSIZ_MASK		0x3FFU
-#define MAX_IMM_TX_PKT_LEN	128
+#define MAX_IMM_TX_PKT_LEN	256
 
 static int push_tx_frames(struct cxgbi_sock *, int);
 
