From: Joe Perches <joe@perches.com>
Subject: [Trivial PATCH 3/5] aix94xx: Use angle brackets for system includes
Date: Fri,  3 Jun 2011 02:28:48 -0700
Message-ID: <44c272d56fab3f621c093aef14dd6a3886ed1ea7.1307092589.git.joe@perches.com>
References: <cover.1307092588.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1307092588.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use the normal include style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/aic94xx/aic94xx_dump.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_dump.c b/drivers/scsi/aic94xx/aic94xx_dump.c
index 67eeba3..a16a77c 100644
--- a/drivers/scsi/aic94xx/aic94xx_dump.c
+++ b/drivers/scsi/aic94xx/aic94xx_dump.c
@@ -29,7 +29,7 @@
  *
  */
 
-#include "linux/pci.h"
+#include <linux/pci.h>
 #include "aic94xx.h"
 #include "aic94xx_reg.h"
 #include "aic94xx_reg_def.h"
-- 
1.7.5.rc3.dirty
