From: Joe Perches <joe@perches.com>
Subject: [PATCH 5/9] drivers/message: Fix continuation lines
Date: Fri, 26 Mar 2010 19:27:54 -0700
Message-ID: <8fa446e7fdb52da2402bb243fe260b0bca20059d.1269655208.git.joe@perches.com>
References: <cover.1269655208.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1269655208.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Eric Moore <Eric.Moore@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/message/fusion/mptbase.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5382b5a..6ab5f8e 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -83,17 +83,17 @@ MODULE_VERSION(my_VERSION);
 static int mpt_msi_enable_spi;
 module_param(mpt_msi_enable_spi, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_spi, " Enable MSI Support for SPI \
-		controllers (default=0)");
+controllers (default=0)");
 
 static int mpt_msi_enable_fc;
 module_param(mpt_msi_enable_fc, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
-		controllers (default=0)");
+controllers (default=0)");
 
 static int mpt_msi_enable_sas;
 module_param(mpt_msi_enable_sas, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
-		controllers (default=0)");
+controllers (default=0)");
 
 
 static int mpt_channel_mapping;
@@ -105,7 +105,7 @@ static int mpt_set_debug_level(const char *val, struct kernel_param *kp);
 module_param_call(mpt_debug_level, mpt_set_debug_level, param_get_int,
 		  &mpt_debug_level, 0600);
 MODULE_PARM_DESC(mpt_debug_level, " debug level - refer to mptdebug.h \
-	- (default=0)");
+- (default=0)");
 
 int mpt_fwfault_debug;
 EXPORT_SYMBOL(mpt_fwfault_debug);
-- 
1.7.0.14.g7e948
