From: Matthew Wilcox <willy@debian.org>
Subject: PARISC changes to drivers/scsi
Date: Sun, 10 Nov 2002 21:22:26 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021110212226.A12011@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from willy by www.linux.org.uk with local (Exim 3.33 #5)
	id 18AzXG-0007Ig-00
	for linux-scsi@vger.kernel.org; Sun, 10 Nov 2002 21:22:26 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Since you guys are starting to discuss stuff pertaining to Linux/PARISC,
I'd like to be sure you're aware of our current changes vs Linus' tree.
I wouldn't call our current tree even remotely stable in 2.5, so I
wasn't planning on submitting these bits.  But do feel free to cherrypick
anything you want from this patch and incorporate it.  If you notice any
bugs, all the better; I don't think anyone one the PA side is paying
particular attention to these drivers and changes to SCSI that affect
them at the moment.

You can see the patch at
http://ftp.linux.org.uk/pub/linux/willy/patches/parisc-scsi.diff

If you care to see our full diff vs Linus 2.5.46 (bear in mind some of
this has gone into -bk recently), you can get it from
http://ftp.parisc-linux.org/2.5/kernel-src/CVS2546_PA7-LINUS_2546.diff.gz

-- 
Revolutions do not require corporate support.
