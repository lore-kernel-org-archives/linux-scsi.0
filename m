From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] remove emacs settings
Date: Mon, 16 Dec 2002 17:26:00 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021216064635.B15812C265@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org

[ Marcelo: this change seems very popular 8) ]
From:  Andries.Brouwer@cwi.nl

  

--- trivial-2.4.21-pre1/drivers/scsi/scsi_proc.c.orig	2002-12-16 17:22:02.000000000 +1100
+++ trivial-2.4.21-pre1/drivers/scsi/scsi_proc.c	2002-12-16 17:22:02.000000000 +1100
@@ -308,22 +308,3 @@
 }
 
 #endif				/* CONFIG_PROC_FS */
-
-/*
- * Overrides for Emacs so that we get a uniform tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-indent-level: 4
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -4
- * c-argdecl-indent: 4
- * c-label-offset: -4
- * c-continued-statement-offset: 4
- * c-continued-brace-offset: 0
- * indent-tabs-mode: nil
- * tab-width: 8
- * End:
- */
-- 
  Don't blame me: the Monkey is driving
  File: Andries.Brouwer@cwi.nl: [TRIVIAL] remove emacs settings
