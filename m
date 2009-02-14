From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH v2 5/6 2.6.29-rc] cxgb3i -- spelling errors in the documentation
Date: Fri, 13 Feb 2009 21:39:04 -0800
Message-ID: <200902140539.n1E5d4s3014351@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:5268 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZBNFhR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Feb 2009 00:37:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH v2 5/6 2.6.29-rc] cxgb3i - spelling errors in the documentation

From: Karen Xie <kxie@chelsio.com>

fixed spelling errors.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 0 files changed, 0 insertions(+), 0 deletions(-)


diff --git a/Documentation/scsi/cxgb3i.txt b/Documentation/scsi/cxgb3i.txt
index 8141fa0..7ac8032 100644
--- a/Documentation/scsi/cxgb3i.txt
+++ b/Documentation/scsi/cxgb3i.txt
@@ -4,7 +4,7 @@ Introduction
 ============
 
 The Chelsio T3 ASIC based Adapters (S310, S320, S302, S304, Mezz cards, etc.
-series of products) supports iSCSI acceleration and iSCSI Direct Data Placement
+series of products) support iSCSI acceleration and iSCSI Direct Data Placement
 (DDP) where the hardware handles the expensive byte touching operations, such
 as CRC computation and verification, and direct DMA to the final host memory
 destination:
@@ -31,9 +31,9 @@ destination:
 	  the TCP segments onto the wire. It handles TCP retransmission if
 	  needed.
 
-	  On receving, S3 h/w recovers the iSCSI PDU by reassembling TCP
+	  On receiving, S3 h/w recovers the iSCSI PDU by reassembling TCP
 	  segments, separating the header and data, calculating and verifying
-	  the digests, then forwards the header to the host. The payload data,
+	  the digests, then forwarding the header to the host. The payload data,
 	  if possible, will be directly placed into the pre-posted host DDP
 	  buffer. Otherwise, the payload data will be sent to the host too.
 
@@ -68,9 +68,8 @@ The following steps need to be taken to accelerates the open-iscsi initiator:
 	sure the ip address is unique in the network.
 
 3. edit /etc/iscsi/iscsid.conf
-   The default setting for MaxRecvDataSegmentLength (131072) is too big,
-   replace "node.conn[0].iscsi.MaxRecvDataSegmentLength" to be a value no
-   bigger than 15360 (for example 8192):
+   The default setting for MaxRecvDataSegmentLength (131072) is too big;
+   replace with a value no bigger than 15360 (for example 8192):
 
 	node.conn[0].iscsi.MaxRecvDataSegmentLength = 8192
 
