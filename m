From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: [PATCH 3.6.0- 4/6] scsi/sni_53c710: use module_platform_driver macro
Date: Wed, 10 Oct 2012 19:34:53 +0100
Message-ID: <1349894093-8328-1-git-send-email-srinivas.kandagatla@st.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:60356 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226Ab2JJSgO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 14:36:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: srinivas.kandagatla@st.com, fthain@telegraphics.com.au, JBottomley@Parallels.com, tsbogend@alpha.frankende, linux-scsi@vger.kernel.org, grant.likely@secretlab.ca, davem@davemloft.net

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch removes some code duplication by using
module_platform_driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/scsi/sni_53c710.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index cf51432..970a778 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -140,16 +140,4 @@ static struct platform_driver snirm710_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init snirm710_init(void)
-{
-	return platform_driver_register(&snirm710_driver);
-}
-
-static void __exit snirm710_exit(void)
-{
-	platform_driver_unregister(&snirm710_driver);
-}
-
-module_init(snirm710_init);
-module_exit(snirm710_exit);
+module_platform_driver(snirm710_driver);
-- 
1.7.0.4

