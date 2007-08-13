From: joe@perches.com
Subject: [PATCH] [205/2many] MAINTAINERS - GDT SCSI DISK ARRAY CONTROLLER
 DRIVER
Date: Sun, 12 Aug 2007 23:28:10 -0700
Message-ID: <46bff9fa.+PJkrw1WokE7d07h%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:4472 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966635AbXHMG2X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, achim_leubner@adaptec.com

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 770b0d8..6597718 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1961,6 +1961,7 @@ M:	achim_leubner@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.icp-vortex.com/
 S:	Supported
+F:	drivers/scsi/gdt*
 
 GENERIC GPIO I2C DRIVER
 P:	Haavard Skinnemoen
