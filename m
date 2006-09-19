From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 5/5] aacraid:  README update
Date: Tue, 19 Sep 2006 09:00:39 -0700
Message-ID: <1158681639.2837.27.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:4771 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751810AbWISQAm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 12:00:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn:

This patch to the driver's documentation adds a few new product entries,
sorts the entries on OEM lines first for easy searching, followed by
product id order to make it easier to compare against the open source
pci list. The driver has 'family match' so is somewhat future proof, no
code changes are required to recognize the new products.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---

--- scsi-misc-aac.orig/Documentation/scsi/aacraid.txt	2006-09-12 09:48:48.000000000 -0700
+++ scsi-misc-aac/Documentation/scsi/aacraid.txt	2006-09-12 09:49:45.000000000 -0700
@@ -11,38 +11,43 @@
 Supported Cards/Chipsets
 -------------------------
 	PCI ID (pci.ids)	OEM	Product
-	9005:0285:9005:028a	Adaptec	2020ZCR (Skyhawk)
-	9005:0285:9005:028e	Adaptec	2020SA (Skyhawk)
-	9005:0285:9005:028b	Adaptec 2025ZCR (Terminator)
-	9005:0285:9005:028f	Adaptec 2025SA (Terminator)
-	9005:0285:9005:0286	Adaptec	2120S (Crusader)
-	9005:0286:9005:028d	Adaptec	2130S (Lancer)
+	9005:0283:9005:0283	Adaptec	Catapult (3210S with arc firmware)
+	9005:0284:9005:0284	Adaptec	Tomcat (3410S with arc firmware)
 	9005:0285:9005:0285	Adaptec	2200S (Vulcan)
+	9005:0285:9005:0286	Adaptec	2120S (Crusader)
 	9005:0285:9005:0287	Adaptec	2200S (Vulcan-2m)
+	9005:0285:9005:0288	Adaptec	3230S (Harrier)
+	9005:0285:9005:0289	Adaptec	3240S (Tornado)
+	9005:0285:9005:028a	Adaptec	2020ZCR (Skyhawk)
+	9005:0285:9005:028b	Adaptec 2025ZCR (Terminator)
 	9005:0286:9005:028c	Adaptec	2230S (Lancer)
 	9005:0286:9005:028c	Adaptec	2230SLP (Lancer)
-	9005:0285:9005:0296	Adaptec	2240S (SabreExpress)
+	9005:0286:9005:028d	Adaptec	2130S (Lancer)
+	9005:0285:9005:028e	Adaptec	2020SA (Skyhawk)
+	9005:0285:9005:028f	Adaptec 2025SA (Terminator)
 	9005:0285:9005:0290	Adaptec	2410SA (Jaguar)
-	9005:0285:9005:0293	Adaptec 21610SA (Corsair-16)
 	9005:0285:103c:3227	Adaptec 2610SA (Bearcat HP release)
+	9005:0285:9005:0293	Adaptec 21610SA (Corsair-16)
+	9005:0285:9005:0296	Adaptec	2240S (SabreExpress)
 	9005:0285:9005:0292	Adaptec	2810SA (Corsair-8)
 	9005:0285:9005:0294	Adaptec	Prowler
-	9005:0286:9005:029d	Adaptec	2420SA (Intruder HP release)
-	9005:0286:9005:029c	Adaptec	2620SA (Intruder)
-	9005:0286:9005:029b	Adaptec	2820SA (Intruder)
-	9005:0286:9005:02a7	Adaptec	2830SA (Skyray)
-	9005:0286:9005:02a8	Adaptec	2430SA (Skyray)
-	9005:0285:9005:0288	Adaptec	3230S (Harrier)
-	9005:0285:9005:0289	Adaptec	3240S (Tornado)
-	9005:0285:9005:0298	Adaptec	4000SAS (BlackBird)
 	9005:0285:9005:0297	Adaptec	4005SAS (AvonPark)
+	9005:0285:9005:0298	Adaptec	4000SAS (BlackBird)
 	9005:0285:9005:0299	Adaptec	4800SAS (Marauder-X)
 	9005:0285:9005:029a	Adaptec	4805SAS (Marauder-E)
+	9005:0286:9005:029b	Adaptec	2820SA (Intruder)
+	9005:0286:9005:029c	Adaptec	2620SA (Intruder)
+	9005:0286:9005:029d	Adaptec	2420SA (Intruder HP release)
 	9005:0286:9005:02a2	Adaptec	3800SAS (Hurricane44)
+	9005:0286:9005:02a7	Adaptec	3805SAS (Hurricane80)
+	9005:0286:9005:02a8	Adaptec	3400SAS (Hurricane40)
+	9005:0286:9005:02ac	Adaptec	1800SAS (Typhoon44)
+	9005:0286:9005:02b3	Adaptec	2400SAS (Hurricane40lm)
+	9005:0285:9005:02b5	Adaptec ASR5800 (Voodoo44)
+	9005:0285:9005:02b6	Adaptec ASR5805 (Voodoo80)
+	9005:0285:9005:02b7	Adaptec ASR5808 (Voodoo08)
 	1011:0046:9005:0364	Adaptec	5400S (Mustang)
 	1011:0046:9005:0365	Adaptec	5400S (Mustang)
-	9005:0283:9005:0283	Adaptec	Catapult (3210S with arc firmware)
-	9005:0284:9005:0284	Adaptec	Tomcat (3410S with arc firmware)
 	9005:0287:9005:0800	Adaptec	Themisto (Jupiter)
 	9005:0200:9005:0200	Adaptec	Themisto (Jupiter)
 	9005:0286:9005:0800	Adaptec	Callisto (Jupiter)
@@ -64,18 +69,20 @@
 	9005:0285:9005:0290	IBM	ServeRAID 7t (Jaguar)
 	9005:0285:1014:02F2	IBM	ServeRAID 8i (AvonPark)
 	9005:0285:1014:0312	IBM	ServeRAID 8i (AvonParkLite)
-	9005:0286:1014:9580	IBM	ServeRAID 8k/8k-l8 (Aurora)
 	9005:0286:1014:9540	IBM	ServeRAID 8k/8k-l4 (AuroraLite)
-	9005:0286:9005:029f	ICP	ICP9014R0 (Lancer)
+	9005:0286:1014:9580	IBM	ServeRAID 8k/8k-l8 (Aurora)
+	9005:0286:1014:034d	IBM	ServeRAID 8s (Hurricane)
 	9005:0286:9005:029e	ICP	ICP9024R0 (Lancer)
+	9005:0286:9005:029f	ICP	ICP9014R0 (Lancer)
 	9005:0286:9005:02a0	ICP	ICP9047MA (Lancer)
 	9005:0286:9005:02a1	ICP	ICP9087MA (Lancer)
+	9005:0286:9005:02a3	ICP	ICP5445AU (Hurricane44)
 	9005:0286:9005:02a4	ICP	ICP9085LI (Marauder-X)
 	9005:0286:9005:02a5	ICP	ICP5085BR (Marauder-E)
-	9005:0286:9005:02a3	ICP	ICP5445AU (Hurricane44)
 	9005:0286:9005:02a6	ICP	ICP9067MA (Intruder-6)
-	9005:0286:9005:02a9	ICP	ICP5087AU (Skyray)
-	9005:0286:9005:02aa	ICP	ICP5047AU (Skyray)
+	9005:0286:9005:02a9	ICP	ICP5085AU (Hurricane80)
+	9005:0286:9005:02aa	ICP	ICP5045AU (Hurricane40)
+	9005:0286:9005:02b4	ICP	ICP5045AL (Hurricane40lm)
 
 People
 -------------------------

-- 
Mark Haverkamp <markh@osdl.org>

