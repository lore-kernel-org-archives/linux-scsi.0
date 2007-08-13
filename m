From: joe@perches.com
Subject: [PATCH] [19/2many] MAINTAINERS - IPS SCSI RAID DRIVER
Date: Sun, 12 Aug 2007 23:21:59 -0700
Message-ID: <46bff887.tZoEfrDzIK+F6h6p%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:3523 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966042AbXHMGYo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, aacraid@adaptec.com

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 141b08a..71e09b7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -224,6 +224,7 @@ M:	aacraid@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Maintained
+F:	drivers/scsi/ips*
 
 DPT_I2O SCSI RAID DRIVER
 P:	Adaptec OEM Raid Solutions
