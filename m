From: jgross@suse.com
Subject: [PATCH V2 4/4] add xen pvscsi maintainer
Date: Fri, 25 Jul 2014 13:37:33 +0200
Message-ID: <1406288253-13293-5-git-send-email-jgross@suse.com>
References: <1406288253-13293-1-git-send-email-jgross@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaGYLiP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2014 07:38:15 -0400
In-Reply-To: <1406288253-13293-1-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgross@suse.com, xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com, target-devel@vger.kernel.org, konrad.wilk@oracle.com

From: Juergen Gross <jgross@suse.com>

Add myself as maintainer for the Xen pvSCSI stuff.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 86efa7e..53f84c3 100644
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

