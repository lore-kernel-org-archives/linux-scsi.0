From: joe@perches.com
Subject: [PATCH] [21/2many] MAINTAINERS - AACRAID SCSI RAID DRIVER
Date: Sun, 12 Aug 2007 23:22:03 -0700
Message-ID: <46bff88b.U/STkuzaGFGAV6x7%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:3438 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965307AbXHMGWU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, aacraid@adaptec.com

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 7d58f6b..1162fb7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -241,6 +241,7 @@ M:	aacraid@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Supported
+F:	drivers/scsi/aacraid/
 
 ACPI
 P:	Len Brown
