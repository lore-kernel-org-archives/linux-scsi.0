From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] NCR5380.c warning
Date: Thu, 11 Sep 2003 08:40:41 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0309110838240.1879-100000@vervain.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


NCR5380: `phases' is used inside the #ifdef NDEBUG only, so move its definition
inside as well.

--- linux-2.6.0-test5/drivers/scsi/NCR5380.c.orig	Tue Sep  9 10:13:04 2003
+++ linux-2.6.0-test5/drivers/scsi/NCR5380.c	Tue Sep  9 15:02:38 2003
@@ -390,6 +390,7 @@
 	return -ETIMEDOUT;
 }
 
+#ifdef NDEBUG
 static struct {
 	unsigned char value;
 	const char *name;
@@ -403,7 +404,6 @@
 	{PHASE_UNKNOWN, "UNKNOWN"}
 };
 
-#ifdef NDEBUG
 static struct {
 	unsigned char mask;
 	const char *name;

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
