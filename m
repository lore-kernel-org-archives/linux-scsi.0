From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] PA-RISC needs MMIO too
Date: Wed, 10 Sep 2003 02:25:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030910012506.GL18654@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:34947 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264341AbTIJBZH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Sep 2003 21:25:07 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org


PA-RISC needs mmaped IO too.  Patch from Grant Grundler.

--- drivers/scsi/aic7xxx/aic79xx_osm.h	8 Sep 2003 21:42:21 -0000	1.8
+++ drivers/scsi/aic7xxx/aic79xx_osm.h	8 Sep 2003 22:00:25 -0000	1.9
@@ -590,7 +590,8 @@ ahd_delay(long usec)
 
 
 /***************************** Low Level I/O **********************************/
-#if defined(__powerpc__) || defined(__i386__) || defined(__ia64__)
+#if defined(__powerpc__) || defined(__i386__) || defined(__ia64__) \
+	|| defined(__hppa__)
 #define MMAPIO
 #endif
 

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
