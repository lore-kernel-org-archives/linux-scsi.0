From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: [PATCH] aacraid: Add Power Management cards to documentation
Date: Wed, 7 May 2008 15:24:23 -0400
Message-ID: <D25ECCDE-1A2B-4E11-BEF9-CAC0A9ABA0FE@adaptec.com>
References: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com> <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com> <86802c440804211742g1fe25aadjeaffce49722e7c46@mail.gmail.com> <BCC76E6D-9A0F-4DC1-822A-50EE44A52890@adaptec.com> <1E278B55-6C77-42FA-8B15-16A0939203FB@adaptec.com> <1FB85EE8-0F95-4CF8-AD36-9E0E6542BB59@adaptec.com> <7D06DAD1-983B-457F-8A9B-76C4FA95D57B@adaptec.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-15--47170099
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:37157 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762634AbYEGTYb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2008 15:24:31 -0400
Received: from Macintosh.adaptec.com (unknown [10.5.3.1])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id BDF4820E63A
	for <linux-scsi@vger.kernel.org>; Wed,  7 May 2008 12:24:29 -0700 (PDT)
In-Reply-To: <7D06DAD1-983B-457F-8A9B-76C4FA95D57B@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-Scsi <linux-scsi@vger.kernel.org>


--Apple-Mail-15--47170099
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Update the documented list of products supported by the aacraid driver.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's  
handling of patch attachments (inline gets damaged, please use  
attachment).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

  Documentation/scsi/aacraid.txt |   24 +++++++++++++++++++-----
  1 file changed, 19 insertions(+), 5 deletions(-)

diff -ru a/Documentation/scsi/aacraid.txt b/Documentation/scsi/ 
aacraid.txt
--- a/Documentation/scsi/aacraid.txt	2008-05-07 15:15:29.872438789 -0400
+++ b/Documentation/scsi/aacraid.txt	2008-05-07 15:19:01.684932465 -0400
@@ -56,19 +56,33 @@
  	9005:0285:9005:02d1	Adaptec	5405 (Voodoo40)
  	9005:0285:15d9:02d2	SMC	AOC-USAS-S8i-LP
  	9005:0285:15d9:02d3	SMC	AOC-USAS-S8iR-LP
-	9005:0285:9005:02d4	Adaptec	2045 (Voodoo04 Lite)
-	9005:0285:9005:02d5	Adaptec	2405 (Voodoo40 Lite)
-	9005:0285:9005:02d6	Adaptec	2445 (Voodoo44 Lite)
-	9005:0285:9005:02d7	Adaptec	2805 (Voodoo80 Lite)
+	9005:0285:9005:02d4	Adaptec	ASR-2045 (Voodoo04 Lite)
+	9005:0285:9005:02d5	Adaptec	ASR-2405 (Voodoo40 Lite)
+	9005:0285:9005:02d6	Adaptec	ASR-2445 (Voodoo44 Lite)
+	9005:0285:9005:02d7	Adaptec	ASR-2805 (Voodoo80 Lite)
+	9005:0285:9005:02d8	Adaptec	5405G (Voodoo40 PM)
+	9005:0285:9005:02d9	Adaptec	5445G (Voodoo44 PM)
+	9005:0285:9005:02da	Adaptec	5805G (Voodoo80 PM)
+	9005:0285:9005:02db	Adaptec	5085G (Voodoo08 PM)
+	9005:0285:9005:02dc	Adaptec	51245G (Voodoo124 PM)
+	9005:0285:9005:02dd	Adaptec	51645G (Voodoo164 PM)
+	9005:0285:9005:02de	Adaptec	52445G (Voodoo244 PM)
+	9005:0285:9005:02df	Adaptec	ASR-2045G (Voodoo04 Lite PM)
+	9005:0285:9005:02e0	Adaptec	ASR-2405G (Voodoo40 Lite PM)
+	9005:0285:9005:02e1	Adaptec	ASR-2445G (Voodoo44 Lite PM)
+	9005:0285:9005:02e2	Adaptec	ASR-2805G (Voodoo80 Lite PM)
  	1011:0046:9005:0364	Adaptec	5400S (Mustang)
+	1011:0046:9005:0365	Adaptec	5400S (Mustang)
  	9005:0287:9005:0800	Adaptec	Themisto (Jupiter)
  	9005:0200:9005:0200	Adaptec	Themisto (Jupiter)
  	9005:0286:9005:0800	Adaptec	Callisto (Jupiter)
  	1011:0046:9005:1364	Dell	PERC 2/QC (Quad Channel, Mustang)
+	1011:0046:9005:1365	Dell	PERC 2/QC (Quad Channel, Mustang)
  	1028:0001:1028:0001	Dell	PERC 2/Si (Iguana)
  	1028:0003:1028:0003	Dell	PERC 3/Si (SlimFast)
  	1028:0002:1028:0002	Dell	PERC 3/Di (Opal)
-	1028:0004:1028:0004	Dell	PERC 3/DiF (Iguana)
+	1028:0004:1028:0004	Dell	PERC 3/SiF (Iguana)
+	1028:0004:1028:00d0	Dell	PERC 3/DiF (Iguana)
  	1028:0002:1028:00d1	Dell	PERC 3/DiV (Viper)
  	1028:0002:1028:00d9	Dell	PERC 3/DiL (Lexus)
  	1028:000a:1028:0106	Dell	PERC 3/DiJ (Jaguar)

Sincerely - Mark Salyzyn

--Apple-Mail-15--47170099
Content-Disposition: attachment;
	filename=aacraid_pm_products.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="aacraid_pm_products.patch"
Content-Transfer-Encoding: 7bit

diff -ru a/Documentation/scsi/aacraid.txt b/Documentation/scsi/aacraid.txt
--- a/Documentation/scsi/aacraid.txt	2008-05-07 15:15:29.872438789 -0400
+++ b/Documentation/scsi/aacraid.txt	2008-05-07 15:19:01.684932465 -0400
@@ -56,19 +56,33 @@
 	9005:0285:9005:02d1	Adaptec	5405 (Voodoo40)
 	9005:0285:15d9:02d2	SMC	AOC-USAS-S8i-LP
 	9005:0285:15d9:02d3	SMC	AOC-USAS-S8iR-LP
-	9005:0285:9005:02d4	Adaptec	2045 (Voodoo04 Lite)
-	9005:0285:9005:02d5	Adaptec	2405 (Voodoo40 Lite)
-	9005:0285:9005:02d6	Adaptec	2445 (Voodoo44 Lite)
-	9005:0285:9005:02d7	Adaptec	2805 (Voodoo80 Lite)
+	9005:0285:9005:02d4	Adaptec	ASR-2045 (Voodoo04 Lite)
+	9005:0285:9005:02d5	Adaptec	ASR-2405 (Voodoo40 Lite)
+	9005:0285:9005:02d6	Adaptec	ASR-2445 (Voodoo44 Lite)
+	9005:0285:9005:02d7	Adaptec	ASR-2805 (Voodoo80 Lite)
+	9005:0285:9005:02d8	Adaptec	5405G (Voodoo40 PM)
+	9005:0285:9005:02d9	Adaptec	5445G (Voodoo44 PM)
+	9005:0285:9005:02da	Adaptec	5805G (Voodoo80 PM)
+	9005:0285:9005:02db	Adaptec	5085G (Voodoo08 PM)
+	9005:0285:9005:02dc	Adaptec	51245G (Voodoo124 PM)
+	9005:0285:9005:02dd	Adaptec	51645G (Voodoo164 PM)
+	9005:0285:9005:02de	Adaptec	52445G (Voodoo244 PM)
+	9005:0285:9005:02df	Adaptec	ASR-2045G (Voodoo04 Lite PM)
+	9005:0285:9005:02e0	Adaptec	ASR-2405G (Voodoo40 Lite PM)
+	9005:0285:9005:02e1	Adaptec	ASR-2445G (Voodoo44 Lite PM)
+	9005:0285:9005:02e2	Adaptec	ASR-2805G (Voodoo80 Lite PM)
 	1011:0046:9005:0364	Adaptec	5400S (Mustang)
+	1011:0046:9005:0365	Adaptec	5400S (Mustang)
 	9005:0287:9005:0800	Adaptec	Themisto (Jupiter)
 	9005:0200:9005:0200	Adaptec	Themisto (Jupiter)
 	9005:0286:9005:0800	Adaptec	Callisto (Jupiter)
 	1011:0046:9005:1364	Dell	PERC 2/QC (Quad Channel, Mustang)
+	1011:0046:9005:1365	Dell	PERC 2/QC (Quad Channel, Mustang)
 	1028:0001:1028:0001	Dell	PERC 2/Si (Iguana)
 	1028:0003:1028:0003	Dell	PERC 3/Si (SlimFast)
 	1028:0002:1028:0002	Dell	PERC 3/Di (Opal)
-	1028:0004:1028:0004	Dell	PERC 3/DiF (Iguana)
+	1028:0004:1028:0004	Dell	PERC 3/SiF (Iguana)
+	1028:0004:1028:00d0	Dell	PERC 3/DiF (Iguana)
 	1028:0002:1028:00d1	Dell	PERC 3/DiV (Viper)
 	1028:0002:1028:00d9	Dell	PERC 3/DiL (Lexus)
 	1028:000a:1028:0106	Dell	PERC 3/DiJ (Jaguar)

--Apple-Mail-15--47170099
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit



--Apple-Mail-15--47170099--
