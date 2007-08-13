From: joe@perches.com
Subject: [PATCH] [20/2many] MAINTAINERS - DPT_I2O SCSI RAID DRIVER
Date: Sun, 12 Aug 2007 23:22:01 -0700
Message-ID: <46bff889.dXV5VZMV3JtRGPq4%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:3434 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965281AbXHMGWT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, aacraid@adaptec.com

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 71e09b7..7d58f6b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -232,6 +232,8 @@ M:	aacraid@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Maintained
+F:	drivers/scsi/dpt*
+F:	drivers/scsi/dpt/
 
 AACRAID SCSI RAID DRIVER
 P:	Adaptec OEM Raid Solutions
