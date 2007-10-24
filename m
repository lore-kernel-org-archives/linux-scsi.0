From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/advansys.c: make 3 functions static
Date: Wed, 24 Oct 2007 18:23:22 +0200
Message-ID: <20071024162322.GM30533@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33308 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756698AbXJXQWx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2007 12:22:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes three needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/advansys.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

ad7c16573cd33555f4136c50fa35d1fb2c3669ca 
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 9dd3952..e316ff2 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -12261,7 +12261,7 @@ static ushort __devinit AdvReadEEPWord(AdvPortAddr iop_base, int eep_word_addr)
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __devinit
+static void __devinit
 AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -12328,7 +12328,7 @@ AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __devinit
+static void __devinit
 AdvSet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -12395,7 +12395,7 @@ AdvSet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cfg_buf)
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-void __devinit
+static void __devinit
 AdvSet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cfg_buf)
 {
 	ushort *wbuf;

