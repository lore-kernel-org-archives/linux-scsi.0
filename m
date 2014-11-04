From: Anish Bhatt <anish@chelsio.com>
Subject: [PATCH scsi 1/2] cxgbi : Add Maintainer for cxgb3i/cxgb4i
Date: Tue,  4 Nov 2014 15:19:22 -0800
Message-ID: <1415143163-2326-2-git-send-email-anish@chelsio.com>
References: <1415143163-2326-1-git-send-email-anish@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:56858
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751325AbaKDXVR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 18:21:17 -0500
In-Reply-To: <1415143163-2326-1-git-send-email-anish@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, jbottomley@parallels.com, michaelc@cs.wisc.edu, kxie@chelsio.com, manojmalviya@chelsio.com, Anish Bhatt <anish@chelsio.com>

Signed-off-by: Anish Bhatt <anish@chelsio.com>
---
 MAINTAINERS | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 82d4ad2..254cb28 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2742,6 +2742,13 @@ W:	http://www.chelsio.com
 S:	Supported
 F:	drivers/net/ethernet/chelsio/cxgb3/
 
+CXGB3 ISCSI DRIVER (CXGB3I)
+M:      Karen Xie <kxie@chelsio.com>
+L:      linux-scsi@vger.kernel.org
+W:      http://www.chelsio.com
+S:      Supported
+F:      drivers/scsi/cxgbi/cxgb3i
+
 CXGB3 IWARP RNIC DRIVER (IW_CXGB3)
 M:	Steve Wise <swise@chelsio.com>
 L:	linux-rdma@vger.kernel.org
@@ -2756,6 +2763,13 @@ W:	http://www.chelsio.com
 S:	Supported
 F:	drivers/net/ethernet/chelsio/cxgb4/
 
+CXGB4 ISCSI DRIVER (CXGB4I)
+M:      Karen Xie <kxie@chelsio.com>
+L:      linux-scsi@vger.kernel.org
+W:      http://www.chelsio.com
+S:      Supported
+F:      drivers/scsi/cxgbi/cxgb4i
+
 CXGB4 IWARP RNIC DRIVER (IW_CXGB4)
 M:	Steve Wise <swise@chelsio.com>
 L:	linux-rdma@vger.kernel.org
-- 
2.1.3

