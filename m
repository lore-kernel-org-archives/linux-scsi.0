From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 09/11] drivers/scsi: include <module.h> for modular ufshcd-pltfrm code
Date: Thu, 30 Apr 2015 21:47:45 -0400
Message-ID: <1430444867-22342-10-git-send-email-paul.gortmaker@windriver.com>
References: <1430444867-22342-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430444867-22342-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This file is built off of a tristate Kconfig option and also contains
modular function calls so it should explicitly include module.h to
avoid compile breakage during header shuffles done in the future.

Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 7db9564f507d..1c0bac8a7e4a 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -33,6 +33,7 @@
  * this program.
  */
 
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
-- 
2.2.1
