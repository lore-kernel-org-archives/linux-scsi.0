From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH] MAINTAINERS: Add myself to S390 ZFCP DRIVER as a co-maintainer
Date: Fri, 28 Jul 2017 12:29:43 +0200
Message-ID: <20170728102943.23974-1-bblock@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I have been working with Steffen on zFCP for quite a while now and we
decided adding me as a co-maintainer might be a good thing.

Acked-by: Steffen Maier <maier@linux.vnet.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f6ec1be48609..2c1a52d1376c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11342,6 +11342,7 @@ F:	drivers/s390/crypto/
 
 S390 ZFCP DRIVER
 M:	Steffen Maier <maier@linux.vnet.ibm.com>
+M:	Benjamin Block <bblock@linux.vnet.ibm.com>
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
-- 
2.11.2
