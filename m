From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] mptsas: white space fixes and version bump
Date: Wed, 19 Oct 2005 20:01:47 +0200
Message-ID: <20051019180147.GE21488@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:30600 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751209AbVJSSBu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 14:01:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, Eric.Moore@lsil.com
Cc: linux-scsi@vger.kernel.org

Various whitespace and comment fixes from Eric, aswell as a version
bump.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/message/fusion/mptbase.h
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptbase.h	2005-10-19 15:07:26.000000000 +0200
+++ linux-2.6/drivers/message/fusion/mptbase.h	2005-10-19 15:09:35.000000000 +0200
@@ -77,8 +77,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.03.03"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.03"
+#define MPT_LINUX_VERSION_COMMON	"3.03.04"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.04"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
Index: linux-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptsas.c	2005-10-19 15:07:26.000000000 +0200
+++ linux-2.6/drivers/message/fusion/mptsas.c	2005-10-19 15:09:35.000000000 +0200
@@ -167,12 +167,12 @@
 static void mptsas_print_phy_pg1(SasPhyPage1_t *pg1)
 {
 	printk("---- SAS PHY PAGE 1 ------------\n");
-        printk("Invalid Dword Count=0x%x\n", pg1->InvalidDwordCount);
-        printk("Running Disparity Error Count=0x%x\n",
+	printk("Invalid Dword Count=0x%x\n", pg1->InvalidDwordCount);
+	printk("Running Disparity Error Count=0x%x\n",
 			pg1->RunningDisparityErrorCount);
-        printk("Loss Dword Synch Count=0x%x\n", pg1->LossDwordSynchCount);
-        printk("PHY Reset Problem Count=0x%x\n", pg1->PhyResetProblemCount);
-        printk("\n");
+	printk("Loss Dword Synch Count=0x%x\n", pg1->LossDwordSynchCount);
+	printk("PHY Reset Problem Count=0x%x\n", pg1->PhyResetProblemCount);
+	printk("\n");
 }
 
 static void mptsas_print_device_pg0(SasDevicePage0_t *pg0)
@@ -188,8 +188,11 @@
 	printk("SAS Address=0x%llX\n", le64_to_cpu(sas_address));
 	printk("Target ID=0x%X\n", pg0->TargetID);
 	printk("Bus=0x%X\n", pg0->Bus);
-	printk("PhyNum=0x%X\n", pg0->PhyNum);
-	printk("AccessStatus=0x%X\n", le16_to_cpu(pg0->AccessStatus));
+	/* The PhyNum field specifies the PHY number of the parent
+	 * device this device is linked to
+	 */
+	printk("Parent Phy Num=0x%X\n", pg0->PhyNum);
+	printk("Access Status=0x%X\n", le16_to_cpu(pg0->AccessStatus));
 	printk("Device Info=0x%X\n", le32_to_cpu(pg0->DeviceInfo));
 	printk("Flags=0x%X\n", le16_to_cpu(pg0->Flags));
 	printk("Physical Port=0x%X\n", pg0->PhysicalPort);
@@ -201,7 +204,7 @@
 	printk("---- SAS EXPANDER PAGE 1 ------------\n");
 
 	printk("Physical Port=0x%X\n", pg1->PhysicalPort);
-	printk("PHY Identifier=0x%X\n", pg1->Phy);
+	printk("PHY Identifier=0x%X\n", pg1->PhyIdentifier);
 	printk("Negotiated Link Rate=0x%X\n", pg1->NegotiatedLinkRate);
 	printk("Programmed Link Rate=0x%X\n", pg1->ProgrammedLinkRate);
 	printk("Hardware Link Rate=0x%X\n", pg1->HwLinkRate);
