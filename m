From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: Thu, 30 Oct 2003 15:00:36 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310301457300.1440-100000@ida.rowland.org>
References: <1067540819.4199.23.camel@pathost1.iomegacorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:21508 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262792AbTJ3UAh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 15:00:37 -0500
In-Reply-To: <1067540819.4199.23.camel@pathost1.iomegacorp.com>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: patmans@us.ibm.com, ronald@kuetemeier.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

On 30 Oct 2003, Pat LaVarre wrote:

> > I am very doubtful that this will work, or rather that it will work with
> > all devices.  I've seen _lots_ of reports of USB devices that can't handle
> > page 8, with all sorts of combinations of values for len attempted.
> 
> Are we confident that back then we tried the Win value for len?
> 
> Are we confident the Win value is x1C = header + optional block
> descriptor + page?

Not at all.  You mentioned that it might be because you had seen it in a 
trace posted not long ago.  But I think that was a trace from a Linux 
host, not a Windows host.  Anyway, as you can see from Ronald's most 
recent test, using that request didn't work with his device.

> Win may have logic different than sd for whether to bother trying page
> x08.  Indeed, Win may often assume writable by default, and wait to go
> boom later if a disk turns out to be read-only.

I don't know what Windows does.  I've heard rumors that it determines 
whether the drive is writable by actually trying to write a block and 
checking to see if the write worked.

Alan Stern


