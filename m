From: Matthew Wilcox <willy@debian.org>
Subject: Re: ahc1542 fun
Date: Wed, 26 May 2004 18:52:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040526175217.GU29154@parcelfarce.linux.theplanet.co.uk>
References: <40B401AE.9060707@pobox.com> <20040526064430.GA21531@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:33412 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265755AbUEZRwT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 13:52:19 -0400
Content-Disposition: inline
In-Reply-To: <20040526064430.GA21531@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Wed, May 26, 2004 at 02:44:30AM -0400, hch@infradead.org wrote:
> This needs fixing in mca.h and mca-legacy.h.  The debian kernel package
> has a fix that I don't quite like.  I'll rework it in the next days and
> submit it.

What I have in the PA tree is:

Index: include/linux/mca.h
===================================================================
RCS file: /var/cvs/linux-2.6/include/linux/mca.h,v
retrieving revision 1.4.46.1
retrieving revision 1.4
diff -u -p -r1.4.46.1 -r1.4
--- include/linux/mca.h 23 May 2004 23:31:15 -0000      1.4.46.1
+++ include/linux/mca.h 8 Oct 2003 20:53:03 -0000       1.4
@@ -12,7 +12,9 @@
 #include <linux/device.h>
 
 /* get the platform specific defines */
+#ifdef CONFIG_MCA
 #include <asm/mca.h>
+#endif
 
 /* The detection of MCA bus is done in the real mode (using BIOS).
  * The information is exported to the protected code, where this

Any use?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
