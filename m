From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] Missing ';' in drivers_scsi_aic7xxx_aicasm_aicasm_gram.y
Date: Thu, 06 Feb 2003 14:16:57 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206053821.D7B0E2C3A8@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Justin Gibbs <gibbs@btc.adaptec.com>, linux-scsi@vger.kernel.org

[ No idea if this is correct - is it? --RR ]
From:  Thibaut VARENE <varenet@parisc-linux.org>

  I tested 2.4.20 on my ppc box and got 2 error messages on the file
  drivers/scsi/aic7xxx/aicasm/aicasm_gram.y, complaining about expected ';'.
  
  I corrected these with the attached patch.
  
  HTH,
  
  
  Thibaut VARENE
  The PA/Linux ESIEE Team
  http://pateam.esiee.fr/
  
  

--- trivial-2.4.21-pre4/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y.orig	2003-02-06 13:53:52.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y	2003-02-06 13:53:52.000000000 +1100
@@ -917,6 +917,7 @@
 		cs->begin_addr = instruction_ptr;
 		in_critical_section = TRUE;
 	}
+;
 
 critical_section_end:
 	T_END_CS ';'
@@ -931,6 +932,7 @@
 		cs->end_addr = instruction_ptr;
 		in_critical_section = FALSE;
 	}
+;
 
 export:
 	{ $$ = 0; }
-- 
  Don't blame me: the Monkey is driving
  File: Thibaut VARENE <varenet@parisc-linux.org>: [PATCH] Missing ';' in drivers_scsi_aic7xxx_aicasm_aicasm_gram.y
