From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] Typo in linux_drivers_scsi_seagate.c
Date: Wed, 07 Aug 2002 14:09:10 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020807043057.72BAE4B86@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org

From:  James Mayer <james@cobaltmountain.com>

(Included in 2.5)

--- trivial-2.4.20-pre1/drivers/scsi/seagate.c.orig	2002-08-07 10:57:44.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/seagate.c	2002-08-07 10:57:44.000000000 +1000
@@ -21,7 +21,7 @@
  * linux 2.1.112, simplified some #defines etc. <pavel@ucw.cz>
  *
  * Aug 2000 - aeb - deleted seagate_st0x_biosparam(). It would try to
- * read the physical disk geometry, a bad mistake. Of course it doesnt
+ * read the physical disk geometry, a bad mistake. Of course it doesn't
  * matter much what geometry one invents, but on large disks it
  * returned 256 (or more) heads, causing all kind of failures.
  * Of course this means that people might see a different geometry now,
-- 
  Don't blame me: the Monkey is driving
