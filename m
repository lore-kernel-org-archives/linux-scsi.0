From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] Typo in linux_drivers_scsi_ncr53c8xx.c
Date: Mon, 15 Jul 2002 17:47:56 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020715082112.26476427D@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org

From: (via Rusty) James Mayer <james@cobaltmountain.com>


--- trivial-2.5.25/drivers/scsi/ncr53c8xx.c.orig	Mon Jul 15 17:03:04 2002
+++ trivial-2.5.25/drivers/scsi/ncr53c8xx.c	Mon Jul 15 17:03:04 2002
@@ -7184,7 +7184,7 @@
 **
 **	Possible cases:		   hs  sir   msg_in value  send   goto
 **	We try to negotiate:
-**	-> target doesnt't msgin   NEG FAIL  noop   defa.  -      dispatch
+**	-> target doesn't msgin    NEG FAIL  noop   defa.  -      dispatch
 **	-> target rejected our msg NEG FAIL  reject defa.  -      dispatch
 **	-> target answered  (ok)   NEG SYNC  sdtr   set    -      clrack
 **	-> target answered (!ok)   NEG SYNC  sdtr   defa.  REJ--->msg_bad
-- 
  Don't blame me: the Monkey is driving
