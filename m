From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] kill drivers/scsi/hosts.h
Date: Thu, 24 Feb 2005 22:23:56 +0100
Message-ID: <20050224212356.GI8651@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mailout.stusta.mhn.de ([141.84.69.5]:65285 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S262496AbVBXVYA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Feb 2005 16:24:00 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Since more than half a year ago, drivers/scsi/hosts.h gives a warning, 
so it seems to be time to remove it.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 9 Feb 2005

--- linux-2.6.11-rc3-mm1-full/drivers/scsi/hosts.h	2004-12-24 22:34:30.000000000 +0100
+++ /dev/null	2004-11-25 03:16:25.000000000 +0100
@@ -1,2 +0,0 @@
-#warning "This file is obsolete, please use <scsi/scsi_host.h> instead"
-#include <scsi/scsi_host.h>
