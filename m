From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH] MAINTAINERS vger.rutgers.edu
Date: Sun, 7 Dec 2003 16:44:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031207214411.GI1277@linnie.riede.org>
References: <Pine.GSO.4.21.0312072207280.2316-100000@waterleaf.sonytel.be>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:51343 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S265272AbTLGVoO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Dec 2003 16:44:14 -0500
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.21.0312072207280.2316-100000@waterleaf.sonytel.be> (from geert@linux-m68k.org on Sun, Dec 07, 2003 at 16:09:57 -0500)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2003.12.07 16:09, Geert Uytterhoeven wrote:
> 
> Mailing lists at vger.rutgers.edu are obsolete, use vger.kernel.org instead.
> Applies to 2.4.23 and 2.6.0-test11.

That reminds me, since OnStream is bankrupt, osst@linux1.onstream.nl
is no longer operational. Can we instead do:

--- linux/MAINTAINERS.orig	2003-11-26 07:52:57.000000000 +0100
+++ linux/MAINTAINERS	2003-12-07 22:04:52.000000000 +0100
@@ -73,7 +73,7 @@
 3C359 NETWORK DRIVER
 P:	Mike Phillips
 M:	mikep@linuxtr.net
-L:	linux-net@vger.rutgers.edu
+L:	linux-net@vger.kernel.org
 L:	linux-tr@linuxtr.net
 W:	http://www.linuxtr.net
 S:	Maintained
@@ -1345,7 +1345,7 @@
 P:	Willem Riede
 M:	osst@riede.org
-L:	osst@linux1.onstream.nl
+L:	osst-users@lists.sourceforge.net
-L:	linux-scsi@vger.rutgers.edu
+L:	linux-scsi@vger.kernel.org
 S:	Maintained

Thanks, Willem Riede.
