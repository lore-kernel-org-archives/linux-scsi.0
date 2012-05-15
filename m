From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/3] scsi: usb-storage: hide errors for five devices
Date: Tue, 15 May 2012 17:36:13 +0100
Message-ID: <20120515173613.3c8c2f1f@pyramind.ukuu.org.uk>
References: <1336491453.1933.67.camel@x61.thuisdomein>
	<Pine.LNX.4.44L0.1205081240450.1479-100000@iolanthe.rowland.org>
	<20120515153539.GA25206@kroah.com>
	<1337099344.13455.9.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45485 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965661Ab2EOQd0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2012 12:33:26 -0400
In-Reply-To: <1337099344.13455.9.camel@x61.thuisdomein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 15 May 2012 18:29:04 +0200
Paul Bolle <pebolle@tiscali.nl> wrote:

> On Tue, 2012-05-15 at 08:35 -0700, Greg Kroah-Hartman wrote:
> > > > Of course, an easy way out would be to downgrade both the "Asking for
> > > > cache data failed" and the "No Caching mode page present" errors to
> > > > notices. But the SCSI people might disagree with that approach.
> > > 
> > > Well, let's see what they say.
> > 
> > What ever happened here, are these 3 patches acceptable, or do they need
> > to be reworked or something else?
> 
> Nothing happened after Alan's message.
> 
> So, currently only the first patch was acceptable (to Alan, that is, but
> it touched the SCSI code).
> 
> At least, I haven't seen a reply from the SCSI people. Perhaps the best
> thing to do is to submit a series of one or two trivial patches that
> just downgrade the errors involved to notices. That should lead to
> feedback by the SCSI people.

Possibly we should have a hostadapter flag indicating if the cache noise
is expected nuisance or not. That way if hardcore SCSI on real cables
wants to keeep it then it can still be shut up for USB where its the
norm and just irrelevant noise.
