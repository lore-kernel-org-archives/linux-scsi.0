From: Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 073/493] drivers/message/fusion: remove use of __devexit_p
Date: Mon, 19 Nov 2012 13:20:22 -0500
Message-ID: <1353349642-3677-73-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41656 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab2KSSiQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2012 13:38:16 -0500
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: DL-MPTFusionLinux@lsi.com 
Cc: linux-scsi@vger.kernel.org 
---
 drivers/message/fusion/mptfc.c  | 2 +-
 drivers/message/fusion/mptsas.c | 2 +-
 drivers/message/fusion/mptspi.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index d784c36..343e9e8 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1360,7 +1360,7 @@ static struct pci_driver mptfc_driver = {
 	.name		= "mptfc",
 	.id_table	= mptfc_pci_table,
 	.probe		= mptfc_probe,
-	.remove		= __devexit_p(mptfc_remove),
+	.remove		= mptfc_remove,
 	.shutdown	= mptscsih_shutdown,
 #ifdef CONFIG_PM
 	.suspend	= mptscsih_suspend,
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 551262e..ec75697 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5387,7 +5387,7 @@ static struct pci_driver mptsas_driver = {
 	.name		= "mptsas",
 	.id_table	= mptsas_pci_table,
 	.probe		= mptsas_probe,
-	.remove		= __devexit_p(mptsas_remove),
+	.remove		= mptsas_remove,
 	.shutdown	= mptsas_shutdown,
 #ifdef CONFIG_PM
 	.suspend	= mptscsih_suspend,
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 8f61ba6..c3aabde 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1550,7 +1550,7 @@ static struct pci_driver mptspi_driver = {
 	.name		= "mptspi",
 	.id_table	= mptspi_pci_table,
 	.probe		= mptspi_probe,
-	.remove		= __devexit_p(mptscsih_remove),
+	.remove		= mptscsih_remove,
 	.shutdown	= mptscsih_shutdown,
 #ifdef CONFIG_PM
 	.suspend	= mptscsih_suspend,
-- 
1.8.0

