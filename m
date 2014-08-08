From: jgross@suse.com
Subject: [PATCH V4 3/4] add xen pvscsi maintainer
Date: Fri,  8 Aug 2014 09:43:59 +0200
Message-ID: <1407483840-31436-4-git-send-email-jgross@suse.com>
References: <1407483840-31436-1-git-send-email-jgross@suse.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1407483840-31436-1-git-send-email-jgross@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, JBottomley@parallels.com, konrad.wilk@oracle.com, hch@infradead.org, david.vrabel@citrix.com, JBeulich@suse.com
Cc: Juergen Gross <jgross@suse.com>
List-Id: linux-scsi@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

Add myself as maintainer for the Xen pvSCSI stuff.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c2066f4..d020bfd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10046,6 +10046,14 @@ S:	Supported
 F:	arch/x86/pci/*xen*
 F:	drivers/pci/*xen*
 
+XEN PVSCSI DRIVERS
+M:	Juergen Gross <jgross@suse.com>
+L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
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
