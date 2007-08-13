From: joe@perches.com
Subject: [PATCH] [541/2many] MAINTAINERS - WD7000 SCSI DRIVER
Date: Sun, 12 Aug 2007 23:39:41 -0700
Message-ID: <46bffcad.4+O9axGOMiHNnF8m%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:2441 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967502AbXHMGjz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: zaga@fly.cc.fer.hr, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d8ee850..4172b36 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5112,12 +5112,15 @@ M:	jt@hpl.hp.com
 L:	linux-wireless@vger.kernel.org
 W:	http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/
 S:	Maintained
+F:	Documentation/networking/wavelan.txt
+F:	drivers/net/wireless/wavelan*
 
 WD7000 SCSI DRIVER
 P:	Miroslav Zagorac
 M:	zaga@fly.cc.fer.hr
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/wd7000.c
 
 WISTRON LAPTOP BUTTON DRIVER
 P:	Miloslav Trmac
