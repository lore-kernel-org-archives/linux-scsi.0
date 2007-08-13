From: joe@perches.com
Subject: [PATCH] [302/2many] MAINTAINERS - LSILOGIC MPT FUSION DRIVERS
 (FC/SAS/SPI)
Date: Sun, 12 Aug 2007 23:31:29 -0700
Message-ID: <46bffac1.amjW/6zt7L13hRNA%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:1054 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966869AbXHMGbp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, support@lsi.com, mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Eric.Moore@lsi.com

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8ae4d49..0046cbd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2902,6 +2902,7 @@ L:	mpt_linux_developer@lsi.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.lsilogic.com/support
 S:	Supported
+F:	drivers/message/fusion/
 
 LSILOGIC/SYMBIOS/NCR 53C8XX and 53C1010 PCI-SCSI drivers
 P:	Matthew Wilcox
