From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: iRiver H100 series and usb-storage issues
Date: Mon, 7 Jun 2004 16:22:48 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406071616200.666-100000@ida.rowland.org>
References: <87brjvw3w9.fsf@ceramic.fifi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:4356 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265035AbUFGUWs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2004 16:22:48 -0400
In-Reply-To: <87brjvw3w9.fsf@ceramic.fifi.org>
List-Id: linux-scsi@vger.kernel.org
To: Philippe Troin <phil@fifi.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On 7 Jun 2004, Philippe Troin wrote:

> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > I just noticed this thread on linux-kernel:
> > 
> > http://marc.theaimsgroup.com/?l=linux-kernel&m=108372064000188&w=2
> > 
> > Apparently under some circumstances the iRiver H100 returns 0 bytes 
> > transferred with GOOD status and residue=512 for a READ(10) command 
> > asking for 1 sector.  As far as I know this is legal, and it indicates the 
> > command should simply be retried.
> 
> That's correct.  However, the iRiver H1xx will also commit a USB
> protocol violation by not returning a CSW (Command Status
> Wrapper).  That's what screws up the transfer.

In the log you posted (at the URL above) the CSW was returned correctly.  
The same is true for the messages you referred to.  So that was not the 
source of the problem.

> Please note that:
> 
>  1. I am just repeating what I have been told by various people and
>     claim no knowledge of the USB or SCSI layers.  In other words, I
>     could be all wrong :-)
> 
>  2. I do not own a H1xx anymore, having returned mine.

Do you know of anyone who has contributed to any versions of this thread 
and still does have an H1xx?

Alan Stern

