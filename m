From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] MAINTAINERS: remove defunct iss storage mailing list
Date: Thu, 13 Oct 2016 13:57:41 -0300
Message-ID: <1476377861-12185-1-git-send-email-javier@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Javier Martinez Canillas <javier@osg.samsung.com>
List-Id: linux-scsi@vger.kernel.org

It appears that the mailing list email address doesn't exist anymore:

<iss_storagedev@hp.com>: host smtp.hp.com[15.73.96.116] said: 550 5.1.1
    <iss_storagedev@hp.com>: Recipient address rejected: User unknown in
    virtual alias table (in reply to RCPT TO command)

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 19d8daab5b0d..56ff868dd7d2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5600,7 +5600,6 @@ F:	drivers/watchdog/hpwdt.c
 
 HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)
 M:	Don Brace <don.brace@microsemi.com>
-L:	iss_storagedev@hp.com
 L:	esc.storagedev@microsemi.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
@@ -5611,7 +5610,6 @@ F:	include/uapi/linux/cciss*.h
 
 HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
 M:	Don Brace <don.brace@microsemi.com>
-L:	iss_storagedev@hp.com
 L:	esc.storagedev@microsemi.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
-- 
2.7.4
