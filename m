From: joe@perches.com
Subject: [PATCH] [303/2many] MAINTAINERS - LSILOGIC/SYMBIOS/NCR 53C8XX and 53C1010 PCI-SCSI drivers
Date: Sun, 12 Aug 2007 23:31:31 -0700
Message-ID: <46bffac3.V1FBFaN4yDE9HOrR%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:1050 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966975AbXHMGbo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, matthew@wil.cx, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0046cbd..c90c64d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2909,6 +2909,7 @@ P:	Matthew Wilcox
 M:	matthew@wil.cx
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/sym53c8xx_2/
 
 M32R ARCHITECTURE
 P:	Hirokazu Takata
