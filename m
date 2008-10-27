From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] scsi: Clean up my email address and use a single standard
 address for everything
Date: Mon, 27 Oct 2008 15:16:36 +0000
Message-ID: <20081027151636.59be566f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52879 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750717AbYJ0PQb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2008 11:16:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

[Resynched v -rc2]

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index eeddbd1..f92da9f 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -30,7 +30,7 @@
  * $Log: NCR5380.c,v $
 
  * Revision 1.10 1998/9/2	Alan Cox
- *				(alan@redhat.com)
+ *				(alan@lxorguk.ukuu.org.uk)
  * Fixed up the timer lockups reported so far. Things still suck. Looking 
  * forward to 2.3 and per device request queues. Then it'll be possible to
  * SMP thread this beast and improve life no end.
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 84bb616..3c298c7 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -54,7 +54,7 @@
  * 9/28/04 Christoph Hellwig <hch@lst.de>
  *	    - merge the two source files
  *	    - remove internal queueing code
- * 14/06/07 Alan Cox <alan@redhat.com>
+ * 14/06/07 Alan Cox <alan@lxorguk.ukuu.org.uk>
  *	 - Grand cleanup and Linuxisation
  */
 
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 8abfd06..90d1d08 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index a735526..9377f83 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index cbac063..1631044 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 289304a..d24c267 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index 933f208..abc9ef5 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 9aa301c..1c5ac39 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/rkt.c b/drivers/scsi/aacraid/rkt.c
index 8cd6588..16d8db5 100644
--- a/drivers/scsi/aacraid/rkt.c
+++ b/drivers/scsi/aacraid/rkt.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 073208b..f70d9f8 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
index fc1a557..b6a3c5c 100644
--- a/drivers/scsi/aacraid/sa.c
+++ b/drivers/scsi/aacraid/sa.c
@@ -1,6 +1,6 @@
 /*
  *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *	(c) Copyright 2001 Red Hat Inc.
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 7c45d88..ed0e3e5 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -22,7 +22,7 @@
  * aha1740_makecode may still need even more work
  * if it doesn't work for your devices, take a look.
  *
- * Reworked for new_eh and new locking by Alan Cox <alan@redhat.com>
+ * Reworked for new_eh and new locking by Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * Converted to EISA and generic DMA APIs by Marc Zyngier
  * <maz@wild-wind.fr.eu.org>, 4/2003.
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 7d31154..20ca0a6 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1,8 +1,8 @@
 /* 
  *  Copyright (C) 1997	Wu Ching Chen
  *  2.1.x update (C) 1998  Krzysztof G. Baranowski
- *  2.5.x update (C) 2002  Red Hat <alan@redhat.com>
- *  2.6.x update (C) 2004  Red Hat <alan@redhat.com>
+ *  2.5.x update (C) 2002  Red Hat
+ *  2.6.x update (C) 2004  Red Hat
  *
  * Marcelo Tosatti <marcelo@conectiva.com.br> : SMP fixes
  *
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 952505c..152dd15 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -14,8 +14,8 @@
  *             neuffer@goofy.zdv.uni-mainz.de               *
  *             a.arnold@kfa-juelich.de                      * 
  *                                                          *
- *  Updated 2002 by Alan Cox <alan@redhat.com> for Linux    *
- *  2.5.x and the newer locking and error handling          *
+ *  Updated 2002 by Alan Cox <alan@lxorguk.ukuu.org.uk> for *
+ *   Linux 2.5.x and the newer locking and error handling   *
  *                                                          *
  *  This program is free software; you can redistribute it  *
  *  and/or modify it under the terms of the GNU General     *
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 56f4e6b..32eef66 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -3,7 +3,7 @@
  * Revised: Mon Dec 28 21:59:02 1998 by faith@acm.org
  * Author: Rickard E. Faith, faith@cs.unc.edu
  * Copyright 1992-1996, 1998 Rickard E. Faith (faith@acm.org)
- * Shared IRQ supported added 7/7/2001  Alan Cox <alan@redhat.com>
+ * Shared IRQ supported added 7/7/2001  Alan Cox <alan@lxorguk.ukuu.org.uk>
 
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 4d15a62..9c1e6a5 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -10,7 +10,7 @@
  See the WWW-page: http://www.uni-mainz.de/~langm000/linux.html for latest
  updates, info and ADF-files for adapters supported by this driver.
 
- Alan Cox <alan@redhat.com>
+ Alan Cox <alan@lxorguk.ukuu.org.uk>
  Updated for Linux 2.5.45 to use the new error handler, cleaned up the
  lock macros and did a few unavoidable locking tweaks, plus one locking
  fix in the irq and completion path.
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 8053b1e..52bdc6d 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -107,7 +107,7 @@
  * this thing into as good a shape as possible, and I'm positive
  * there are lots of lurking bugs and "Stupid Places".
  *
- * Updated for Linux 2.5 by Alan Cox <alan@redhat.com>
+ * Updated for Linux 2.5 by Alan Cox <alan@lxorguk.ukuu.org.uk>
  *	- Using new_eh handler
  *	- Hopefully got all the locking right again
  *	See "FIXME" notes for items that could do with more work
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index e3f7397..5529518 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -4,7 +4,7 @@
  * Copyright (c) 1994-1998 Initio Corporation
  * Copyright (c) 1998 Bas Vermeulen <bvermeul@blackstar.xs4all.nl>
  * Copyright (c) 2004 Christoph Hellwig <hch@lst.de>
- * Copyright (c) 2007 Red Hat <alan@redhat.com>
+ * Copyright (c) 2007 Red Hat
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/initio.h b/drivers/scsi/initio.h
index cb48efa..e58af9e 100644
--- a/drivers/scsi/initio.h
+++ b/drivers/scsi/initio.h
@@ -4,7 +4,7 @@
  * Copyright (c) 1994-1998 Initio Corporation
  * All rights reserved.
  *
- * Cleanups (c) Copyright 2007 Red Hat <alan@redhat.com>
+ * Cleanups (c) Copyright 2007 Red Hat <alan@lxorguk.ukuu.org.uk>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 4871dd1..5945914 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -19,7 +19,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * Alan Cox <alan@redhat.com> - Removed several careless u32/dma_addr_t errors
+ * Alan Cox <alan@lxorguk.ukuu.org.uk> - Removed several careless u32/dma_addr_t errors
  *				that broke 64bit platforms.
  */
 
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index de7b3bc..1ad5155 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -23,7 +23,7 @@
    Functions as standalone, loadable, and PCMCIA driver, the latter from
    Dave Hinds' PCMCIA package.
    
-   Cleaned up 26/10/2002 by Alan Cox <alan@redhat.com> as part of the 2.5
+   Cleaned up 26/10/2002 by Alan Cox <alan@lxorguk.ukuu.org.uk> as part of the 2.5
    SCSI driver cleanup and audit. This driver still needs work on the
    following
    	-	Non terminating hardware waits
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index f7d2795..e5c369b 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -6,7 +6,7 @@
  *  Changes : 
  * 
  *  Marcelo Tosatti <marcelo@conectiva.com.br> : Added io_request_lock locking
- *  Alan Cox <alan@redhat.com> : Cleaned up code formatting
+ *  Alan Cox <alan@lxorguk.ukuu.org.uk> : Cleaned up code formatting
  *				 Fixed an irq locking bug
  *				 Added ISAPnP support
  *  Bjoern A. Zeeb <bzeeb@zabbadoz.net> : Initial irq locking updates
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index d4c1356..093610b 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -146,13 +146,13 @@
  *
  * use host->host_lock, not io_request_lock, cleanups
  *
- * 2002/10/04 - Alan Cox <alan@redhat.com>
+ * 2002/10/04 - Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * Use dev_id for interrupts, kill __func__ pasting
  * Add a lock for the scb pool, clean up all other cli/sti usage stuff
  * Use the adapter lock for the other places we had the cli's
  *
- * 2002/10/06 - Alan Cox <alan@redhat.com>
+ * 2002/10/06 - Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * Switch to new style error handling
  * Clean up delay to udelay, and yielding sleeps
