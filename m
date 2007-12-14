From: akpm@linux-foundation.org
Subject: [patch 17/30] scsi/advansys.c: make 3 functions static
Date: Thu, 13 Dec 2007 16:14:20 -0800
Message-ID: <200712140014.lBE0EKxO026223@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54134 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763460AbXLNAUH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 19:20:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@kernel.org

From: Adrian Bunk <bunk@kernel.org>

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/advansys.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/advansys.c~scsi-advansysc-make-3-functions-static drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c~scsi-advansysc-make-3-functions-static
+++ a/drivers/scsi/advansys.c
@@ -12261,7 +12261,7 @@ static ushort __devinit AdvReadEEPWord(A
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __devinit
+static void __devinit
 AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -12328,7 +12328,7 @@ AdvSet3550EEPConfig(AdvPortAddr iop_base
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __devinit
+static void __devinit
 AdvSet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -12395,7 +12395,7 @@ AdvSet38C0800EEPConfig(AdvPortAddr iop_b
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __devinit
+static void __devinit
 AdvSet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
_
