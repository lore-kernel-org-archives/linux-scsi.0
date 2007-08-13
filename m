From: joe@perches.com
Subject: [PATCH] [166/2many] MAINTAINERS - EATA-DMA SCSI DRIVER
Date: Sun, 12 Aug 2007 23:26:42 -0700
Message-ID: <46bff9a2.xVArxjKoYTQQ0aCA%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:2474 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967451AbXHMGkG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-eata@i-connect.net, akpm@linux-foundation.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8c79559..a8b11ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1616,8 +1616,10 @@ F:	include/linux/dvb/
 
 EATA-DMA SCSI DRIVER
 P:	Michael Neuffer
-L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
+L:	linux-eata@i-connect.net
+L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/eata*
 
 EATA ISA/EISA/PCI SCSI DRIVER
 P:	Dario Ballabio
