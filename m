From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2/3] aacraid: Update supported product information
Date: Thu, 08 Jun 2006 09:51:09 -0700
Message-ID: <1149785469.22364.17.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:62435 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S964899AbWFHQvM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2006 12:51:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received From Mark Salyzyn

Some of the cards product names changed.


Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-06-08 09:38:40.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-06-08 09:38:44.000000000 -0700
@@ -119,7 +119,7 @@
 	{ 0x9005, 0x0286, 0x9005, 0x029f, 0, 0, 26 }, /* ICP9014R0 (Lancer) */
 	{ 0x9005, 0x0286, 0x9005, 0x02a0, 0, 0, 27 }, /* ICP9047MA (Lancer) */
 	{ 0x9005, 0x0286, 0x9005, 0x02a1, 0, 0, 28 }, /* ICP9087MA (Lancer) */
-	{ 0x9005, 0x0286, 0x9005, 0x02a3, 0, 0, 29 }, /* ICP5085AU (Hurricane) */
+	{ 0x9005, 0x0286, 0x9005, 0x02a3, 0, 0, 29 }, /* ICP5445AU (Hurricane44) */
 	{ 0x9005, 0x0285, 0x9005, 0x02a4, 0, 0, 30 }, /* ICP9085LI (Marauder-X) */
 	{ 0x9005, 0x0285, 0x9005, 0x02a5, 0, 0, 31 }, /* ICP5085BR (Marauder-E) */
 	{ 0x9005, 0x0286, 0x9005, 0x02a6, 0, 0, 32 }, /* ICP9067MA (Intruder-6) */
@@ -143,7 +143,7 @@
 	{ 0x9005, 0x0285, 0x9005, 0x0298, 0, 0, 48 }, /* ASR-4000SAS (BlackBird) */
 	{ 0x9005, 0x0285, 0x9005, 0x0299, 0, 0, 49 }, /* ASR-4800SAS (Marauder-X) */
 	{ 0x9005, 0x0285, 0x9005, 0x029a, 0, 0, 50 }, /* ASR-4805SAS (Marauder-E) */
-	{ 0x9005, 0x0286, 0x9005, 0x02a2, 0, 0, 51 }, /* ASR-4810SAS (Hurricane */
+	{ 0x9005, 0x0286, 0x9005, 0x02a2, 0, 0, 51 }, /* ASR-3800SAS (Hurricane44) */
 
 	{ 0x9005, 0x0285, 0x1028, 0x0287, 0, 0, 52 }, /* Perc 320/DC*/
 	{ 0x1011, 0x0046, 0x9005, 0x0365, 0, 0, 53 }, /* Adaptec 5400S (Mustang)*/
@@ -195,7 +195,7 @@
 	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP9014R0       ", 1 }, /* ICP9014R0 (Lancer) */
 	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP9047MA       ", 1 }, /* ICP9047MA (Lancer) */
 	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP9087MA       ", 1 }, /* ICP9087MA (Lancer) */
-	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP5085AU       ", 1 }, /* ICP5085AU (Hurricane) */
+	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP5445AU       ", 1 }, /* ICP5445AU (Hurricane44) */
 	{ aac_rx_init, "aacraid",  "ICP     ", "ICP9085LI       ", 1 }, /* ICP9085LI (Marauder-X) */
 	{ aac_rx_init, "aacraid",  "ICP     ", "ICP5085BR       ", 1 }, /* ICP5085BR (Marauder-E) */
 	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP9067MA       ", 1 }, /* ICP9067MA (Intruder-6) */
@@ -217,7 +217,7 @@
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4000SAS     ", 1 }, /* ASR-4000SAS (BlackBird & AvonPark) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4800SAS     ", 1 }, /* ASR-4800SAS (Marauder-X) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4805SAS     ", 1 }, /* ASR-4805SAS (Marauder-E) */
-	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "ASR-4810SAS     ", 1 }, /* ASR-4810SAS (Hurricane) */
+	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "ASR-3800SAS     ", 1 }, /* ASR-3800SAS (Hurricane44) */
 
 	{ aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Perc 320/DC*/
 	{ aac_sa_init, "aacraid",  "ADAPTEC ", "Adaptec 5400S   ", 4, AAC_QUIRK_34SG }, /* Adaptec 5400S (Mustang)*/
--- scsi-misc-aac.orig/Documentation/scsi/aacraid.txt	2006-06-08 09:37:41.000000000 -0700
+++ scsi-misc-aac/Documentation/scsi/aacraid.txt	2006-06-08 09:38:44.000000000 -0700
@@ -24,10 +24,10 @@
 	9005:0285:9005:0296	Adaptec	2240S (SabreExpress)
 	9005:0285:9005:0290	Adaptec	2410SA (Jaguar)
 	9005:0285:9005:0293	Adaptec 21610SA (Corsair-16)
-	9005:0285:103c:3227	Adaptec 2610SA (Bearcat)
+	9005:0285:103c:3227	Adaptec 2610SA (Bearcat HP release)
 	9005:0285:9005:0292	Adaptec	2810SA (Corsair-8)
 	9005:0285:9005:0294	Adaptec	Prowler
-	9005:0286:9005:029d	Adaptec	2420SA (Intruder)
+	9005:0286:9005:029d	Adaptec	2420SA (Intruder HP release)
 	9005:0286:9005:029c	Adaptec	2620SA (Intruder)
 	9005:0286:9005:029b	Adaptec	2820SA (Intruder)
 	9005:0286:9005:02a7	Adaptec	2830SA (Skyray)
@@ -38,7 +38,7 @@
 	9005:0285:9005:0297	Adaptec	4005SAS (AvonPark)
 	9005:0285:9005:0299	Adaptec	4800SAS (Marauder-X)
 	9005:0285:9005:029a	Adaptec	4805SAS (Marauder-E)
-	9005:0286:9005:02a2	Adaptec	4810SAS (Hurricane)
+	9005:0286:9005:02a2	Adaptec	3800SAS (Hurricane44)
 	1011:0046:9005:0364	Adaptec	5400S (Mustang)
 	1011:0046:9005:0365	Adaptec	5400S (Mustang)
 	9005:0283:9005:0283	Adaptec	Catapult (3210S with arc firmware)
@@ -72,7 +72,7 @@
 	9005:0286:9005:02a1	ICP	ICP9087MA (Lancer)
 	9005:0286:9005:02a4	ICP	ICP9085LI (Marauder-X)
 	9005:0286:9005:02a5	ICP	ICP5085BR (Marauder-E)
-	9005:0286:9005:02a3	ICP	ICP5085AU (Hurricane)
+	9005:0286:9005:02a3	ICP	ICP5445AU (Hurricane44)
 	9005:0286:9005:02a6	ICP	ICP9067MA (Intruder-6)
 	9005:0286:9005:02a9	ICP	ICP5087AU (Skyray)
 	9005:0286:9005:02aa	ICP	ICP5047AU (Skyray)

-- 
Mark Haverkamp <markh@osdl.org>

