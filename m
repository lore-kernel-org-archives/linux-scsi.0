From: "Russell Johnson" <rjohnson@rtlogic.com>
Subject: RE: Megaraid corruption?
Date: Thu, 9 Dec 2004 11:26:06 -0700
Message-ID: <003401c4de1c$8c5fddc0$1e01a8c0@rtlogic.com>
References: <1102613697.8512.31.camel@TroysLinux.verari.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eagle.rtlogic.com ([216.87.68.236]:30695 "EHLO
	eagle.rtlogic.com") by vger.kernel.org with ESMTP id S261567AbULIS0K
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 13:26:10 -0500
In-Reply-To: <1102613697.8512.31.camel@TroysLinux.verari.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: res1uo0c@verizon.net
Cc: 'Tom Coughlan' <coughlan@redhat.com>, linux-scsi@vger.kernel.org

I'm running 2.6.7.

Did you try running a test without the megamgr running?  The bug that I had
didn't exhibit itself if nothing was running ioctls to the driver.  So by
disabling megamgr you would be possibly getting rid of the source of the
data corruption if your bug is the same that mine was.

Once you figure that out you can determine if you want to update to the 2.6
series or not.

Russ

> -----Original Message-----
> From: Troy Klein [mailto:res1uo0c@verizon.net] 
> Sent: Thursday, December 09, 2004 10:35 AM
> To: Russell Johnson
> Cc: 'Tom Coughlan'; linux-scsi@vger.kernel.org
> Subject: RE: Megaraid corruption?
> 
> 
> What kernel version are you running?  I am running 
> 2.4.21-20.ELsmp (RedHat EL).
> 
> Does the megaraid compile with 2.4 kernels and if so how is 
> that done the source appears to be for 2.6?
> 
> Troy
> 
> On Thu, 2004-12-09 at 10:26 -0700, Russell Johnson wrote:
> > There was a recent patch to the megaraid2 driver that fixed 
> corruption 
> > while some ioctl's were executing during file operations.  You 
> > mentioned using
> > megamgr.  If that is running in the background while you are
> > performing the
> > file copies, it could be causing the bug that was fixed in the most
> > recent
> > megaraid2 driver.
> > 
> > Try disabling megamgr and run your test...
> > 
> > Or try updating megaraid2 to the latest version.  I'm using
> > megaraid cmm: 2.20.2.0 (Release Date: Thu Aug 19 09:58:33 EDT 2004)
> > megaraid: 2.20.4.0 (Release Date: Mon Sep 27 22:15:07 EDT)
> > 
> 
> 



