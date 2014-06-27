From: jgross@suse.com
Subject: [PATCH 4/4] add xen pvscsi maintainer
Date: Fri, 27 Jun 2014 16:34:36 +0200
Message-ID: <1403879676-25431-5-git-send-email-jgross@suse.com>
References: <1403879676-25431-1-git-send-email-jgross@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbaF0Off (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 10:35:35 -0400
In-Reply-To: <1403879676-25431-1-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, xen-devel@lists.xen.org
Cc: Juergen Gross <jgross@suse.com>

From: Juergen Gross <jgross@suse.com>

Add myself as maintainer for the Xen pvSCSI stuff.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ebc8128..78c60e6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10008,6 +10008,13 @@ S:	Supported
 F:	arch/x86/pci/*xen*
 F:	drivers/pci/*xen*
 
+XEN PVSCSI DRIVERS
+M:	Juergen Gross <jgross@suse.com>
+L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
+S:	Supported
+F:	drivers/scsi/xen*
+F:	include/xen/interface/io/vscsiif.h
+
 XEN SWIOTLB SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
 L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
-- 
1.8.4.5

