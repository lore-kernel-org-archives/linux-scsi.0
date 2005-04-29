From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [Question] Does the kernel ignore errors writng to disk?
Date: Fri, 29 Apr 2005 08:25:17 +0100 (BST)
Message-ID: <Pine.LNX.4.60.0504290824280.28101@hermes-1.csi.cam.ac.uk>
References: <OFDAC458FF.56F50513-ON88256FF1.007F29BD-88256FF1.007FD60F@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:25048 "EHLO
	ppsw-7.csi.cam.ac.uk") by vger.kernel.org with ESMTP
	id S262449AbVD2HZY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2005 03:25:24 -0400
In-Reply-To: <OFDAC458FF.56F50513-ON88256FF1.007F29BD-88256FF1.007FD60F@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, brace@hp.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, mike.miller@hp.com

On Thu, 28 Apr 2005, Bryan Henderson wrote:
> >O_SYNC doesn't work completely on several file systems and only on the
> >latest kernels with some of the common ones.
> 
> Hmmm.  You didn't mention such a restriction when you suggested fsync() 
> before.  Does fsync() work completely on these kernels where O_SYNC 
> doesn't?  Considering that a simple implementation of O_SYNC just does the 
> equivalent of an fsync() inside every write(), that would be hard to 
> understand.

Some file systems implement their fsync() function as "return 0;" so no, 
you cannot rely on it at all.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer / IRC: #ntfs on irc.freenode.net
WWW: http://linux-ntfs.sf.net/ & http://www-stu.christs.cam.ac.uk/~aia21/
