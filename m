From: jgross@suse.com
Subject: [PATCH V5 5/5] add xen pvscsi maintainer
Date: Mon, 18 Aug 2014 11:31:50 +0200
Message-ID: <1408354310-6362-6-git-send-email-jgross@suse.com>
References: <1408354310-6362-1-git-send-email-jgross@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbaHRJcK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2014 05:32:10 -0400
In-Reply-To: <1408354310-6362-1-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com, nab@linux-iscsi.org
Cc: Juergen Gross <jgross@suse.com>

From: Juergen Gross <jgross@suse.com>

Add myself as maintainer for the Xen pvSCSI stuff.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index aefa948..360f86f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10086,6 +10086,14 @@ S:	Supported
 F:	drivers/block/xen-blkback/*
 F:	drivers/block/xen*
 
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

