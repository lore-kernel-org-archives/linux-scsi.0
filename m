From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Large disk drives
Date: Wed, 5 Nov 2014 11:34:11 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1411051130470.1531-100000@iolanthe.rowland.org>
References: <1415203668.13212.2.camel@jarvis>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43768 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754590AbaKEQeM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2014 11:34:12 -0500
In-Reply-To: <1415203668.13212.2.camel@jarvis>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Dale R. Worley" <worley@alum.mit.edu>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Wed, 5 Nov 2014, James Bottomley wrote:

> On Tue, 2014-11-04 at 11:14 -0500, Alan Stern wrote:
> > On Tue, 4 Nov 2014, James Bottomley wrote:
> > 
> > > On Mon, 2014-11-03 at 16:06 -0500, Dale R. Worley wrote:
> > > > Was there any resolution as to how large disk drives would be handled
> > > > if their interface did not support the "capacity" request that would
> > > > tell how large they were?
> > > 
> > > Realistically no ... unless someone comes up with a reliable heuristic
> > > to give us the size.
> > 
> > I posted a patch to allow the user to override the reported capacity:
> > 
> > 	http://marc.info/?l=linux-scsi&m=140993840113445&w=2
> > 
> > Nobody responded to it.
> 
> Sorry, meant to.  In principle I'm OK with this as the lever for the
> hack (largely because it means we don't need to do anything) but will
> the distributions support it?

While I can't speak for the distributions, it's reasonable to assume 
that if something becomes part of the upstream kernel then they will 
include it.

> OK, but I still don't understand how windows gets the partition table on
> there in the first place ... that must surely be some sort of guess the
> disk size hack.

It's simpler than that: The drive is attached directly to the computer
(i.e., via SATA rather than USB) when the partition table is created.  
With no USB-SATA bridge chip to mess things up, there's no problem
determining the correct capacity.

Alan Stern

