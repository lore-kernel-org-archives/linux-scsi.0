From: joe@perches.com
Subject: [PATCH] [35/2many] MAINTAINERS - AHA152X SCSI DRIVER
Date: Sun, 12 Aug 2007 23:22:29 -0700
Message-ID: <46bff8a5.wGRI03LmVFlRPhc0%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:3534 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965755AbXHMGWr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fischer@norbit.de, akpm@linux-foundation.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c35092f..b6827c1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -343,9 +343,11 @@ F:	drivers/char/agp/
 
 AHA152X SCSI DRIVER
 P:	Juergen E. Fischer
-M:	Juergen Fischer <fischer@norbit.de>
+M:	fischer@norbit.de
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/aha152x*
+F:	drivers/scsi/pcmcia/aha152x*
 
 ALCATEL SPEEDTOUCH USB DRIVER
 P:	Duncan Sands
