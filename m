From: Juergen Gross <jgross@suse.com>
Subject: [PATCH V6 5/5] add xen pvscsi maintainer
Date: Thu, 28 Aug 2014 06:44:13 +0200
Message-ID: <1409201053-6223-6-git-send-email-jgross@suse.com>
References: <1409201053-6223-1-git-send-email-jgross@suse.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1409201053-6223-1-git-send-email-jgross@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com, nab@linux-iscsi.org, konrad.wilk@oracle.com
Cc: Juergen Gross <jgross@suse.com>
List-Id: linux-scsi@vger.kernel.org

Add myself as maintainer for the Xen pvSCSI stuff.

Signed-off-by: Juergen Gross <jgross@suse.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1ff06de..0ae6238 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10128,6 +10128,15 @@ S:	Supported
 F:	drivers/block/xen-blkback/*
 F:	drivers/block/xen*
 
+XEN PVSCSI DRIVERS
+M:	Juergen Gross <jgross@suse.com>
+L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/xen-scsifront.c
+F:	drivers/xen/xen-scsiback.c
+F:	include/xen/interface/io/vscsiif.h
+
 XEN SWIOTLB SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
 L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
-- 
1.8.4.5
