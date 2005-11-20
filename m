From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] Re: Myson Century USB enclosure problem
Date: Sun, 20 Nov 2005 10:14:24 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0511201010530.15941-100000@netrider.rowland.org>
References: <dlpbfk$4k5$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.rowland.org ([192.131.102.7]:44043 "HELO mx1.rowland.org")
	by vger.kernel.org with SMTP id S1751248AbVKTPO0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Nov 2005 10:14:26 -0500
In-Reply-To: <dlpbfk$4k5$1@sea.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chuan-kai Lin <cklin@cs.pdx.edu>
Cc: linux-usb-users@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Sun, 20 Nov 2005, Chuan-kai Lin wrote:

> Thanks for the patch and the explanation.  I have applied the patch and
> posted the usb-storage debug output in the same directory.
> 
>   http://www.cs.pdx.edu/~cklin/usb-error/
> 
> The kernel still failed to read the partition table.  However, to my
> untrained eyes, the log indicates that the SCSI core did revert back to
> 10-byte commands, so we are making progress.

It did switch back, and as far as the log shows, everything is now working
correctly.  That error message about "unable to read partition table" is
misleading; the kernel _was_ able to read the partition table.  It just
wasn't able to understand the contents.  You may need to run fdisk to 
check and reinitialize the partition table.

Alan Stern

