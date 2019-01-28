From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] MAINTAINERS: Move FCoE to Hannes Reinecke
Date: Mon, 28 Jan 2019 12:06:34 +0100
Message-ID: <20190128110634.17243-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

I'll be moving on to different things in the storage stack and Hannes
agreed to take over FCoE.

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9f64f8d3740e..49b829794699 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5855,7 +5855,7 @@ S:	Maintained
 F:	drivers/media/tuners/fc2580*
 
 FCOE SUBSYSTEM (libfc, libfcoe, fcoe)
-M:	Johannes Thumshirn <jth@kernel.org>
+M:	Hannes Reinecke <hare@suse.de>
 L:	linux-scsi@vger.kernel.org
 W:	www.Open-FCoE.org
 S:	Supported
-- 
2.16.4
