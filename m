From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: [PATCH 3.6.0- 1/6] scsi/jazz_esp: use module_platform_driver macro
Date: Wed, 10 Oct 2012 19:34:26 +0100
Message-ID: <1349894066-8227-1-git-send-email-srinivas.kandagatla@st.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:57718 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516Ab2JJSgA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 14:36:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: srinivas.kandagatla@st.com, fthain@telegraphics.com.au, JBottomley@Parallels.com, tsbogend@alpha.frankende, linux-scsi@vger.kernel.org, grant.likely@secretlab.ca, davem@davemloft.net

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch removes some code duplication by using
module_platform_driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/scsi/jazz_esp.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 27cfb0c..35bfd0d 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -230,20 +230,8 @@ static struct platform_driver esp_jazz_driver = {
 	},
 };
 
-static int __init jazz_esp_init(void)
-{
-	return platform_driver_register(&esp_jazz_driver);
-}
-
-static void __exit jazz_esp_exit(void)
-{
-	platform_driver_unregister(&esp_jazz_driver);
-}
-
 MODULE_DESCRIPTION("JAZZ ESP SCSI driver");
 MODULE_AUTHOR("Thomas Bogendoerfer (tsbogend@alpha.franken.de)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(jazz_esp_init);
-module_exit(jazz_esp_exit);
+module_platform_driver(esp_jazz_driver);
-- 
1.7.0.4

