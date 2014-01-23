From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] isci: update version to 1.2
Date: Thu, 23 Jan 2014 10:52:01 +0100
Message-ID: <20140123095201.6396.47361.stgit@gklab-154-244.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com
Cc: Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Maciej Patelczyk <maciej.patelczyk@intel.com>
List-Id: linux-scsi@vger.kernel.org

The version of isci driver has not been updated for 2 years.
It was 83 isci commits ago. Suspend/resume support has been implemented
and many bugs have been fixed since 1.1. Now update the version to 1.2.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
---
 drivers/scsi/isci/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index d25d0d8..695b34e 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -66,7 +66,7 @@
 #include "probe_roms.h"
 
 #define MAJ 1
-#define MIN 1
+#define MIN 2
 #define BUILD 0
 #define DRV_VERSION __stringify(MAJ) "." __stringify(MIN) "." \
 	__stringify(BUILD)
