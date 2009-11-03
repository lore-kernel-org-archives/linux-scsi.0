From: Roel Kluin <roel.kluin@gmail.com>
Subject: tmscsim: Missing parentheses in dc390_init_hw()?
Date: Tue, 03 Nov 2009 23:55:29 +0100
Message-ID: <4AF0B4E1.2030407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:48128 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZKCWoH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 17:44:07 -0500
Received: by ewy3 with SMTP id 3so2522031ewy.37
        for <linux-scsi@vger.kernel.org>; Tue, 03 Nov 2009 14:44:12 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

Same oddness, are there parentheses missing here?

Thanks, Roel

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 9a42734..25e6d63 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2408,8 +2408,8 @@ static void __devinit dc390_init_hw(struct dc390_acb *pACB, u8 index)
 
 	/* Negation */
 	DC390_write8(CtrlReg4, pACB->glitch_cfg | /* glitch eater */
-		(dc390_eepromBuf[index][EE_MODE2] & ACTIVE_NEGATION) ?
-		 NEGATE_REQACKDATA : 0);
+		((dc390_eepromBuf[index][EE_MODE2] & ACTIVE_NEGATION) ?
+		 NEGATE_REQACKDATA : 0));
 	
 	/* Clear Transfer Count High: ID */
 	DC390_write8(CtcReg_High, 0);
