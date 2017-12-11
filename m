From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] MAINTIANERS: change FCoE list to linux-scsi
Date: Mon, 11 Dec 2017 10:09:30 +0100
Message-ID: <20171211090930.14879-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

fcoe-devel@open-fcoe.org is defunct and all patches are routed via the SCSI
tree anyways.

So update MAINTAINERS accordingly.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9e0045e3ee0c..46bbf0f210ea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5431,7 +5431,7 @@ F:	drivers/media/tuners/fc2580*
 
 FCOE SUBSYSTEM (libfc, libfcoe, fcoe)
 M:	Johannes Thumshirn <jth@kernel.org>
-L:	fcoe-devel@open-fcoe.org
+L:	linux-scsi@vger.kernel.org
 W:	www.Open-FCoE.org
 S:	Supported
 F:	drivers/scsi/libfc/
-- 
2.13.6
