From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Broadcom 8603 SAS/SATA driver, rough draft
Date: Mon, 24 Sep 2007 09:06:46 -0500
Message-ID: <1190642806.3355.12.camel@localhost.localdomain>
References: <20070923040437.GA30170@havoc.gtf.org>
	 <1190588723.3378.25.camel@localhost.localdomain>
	 <46F6FA11.2070501@garzik.org>
	 <1190591947.3378.31.camel@localhost.localdomain>
	 <46F70162.3000108@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57652 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757131AbXIXOGs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2007 10:06:48 -0400
In-Reply-To: <46F70162.3000108@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Sun, 2007-09-23 at 20:14 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > On Sun, 2007-09-23 at 19:43 -0400, Jeff Garzik wrote:
> >> James Bottomley wrote:
> >>> On Sun, 2007-09-23 at 00:04 -0400, Jeff Garzik wrote:
> >>>> Rather than sitting on this for far too long, I wanted to go ahead and
> >>>> get this out there.  I heard some chips might be trickling out into
> >>>> public hands.
> >>> The first thing to note is about the specs and the pre-production
> >>> hardware: the Linux Foundation has mechanism to get both into the hands
> >>> of interested developers; if you can point me to contacts, I can at
> >>> least get the NDA documentation programme ball rolling.
> >> Well, are there interested, motivated, skilled developers with time?  :)
> >>
> >> Otherwise it's a moot point.
> > 
> > We have GregKH's minions ... this would be a good project for them.
> 
> > Same answer ... GregKH has a legion ... lets use it.
> 
> This is a good project for somebody who knows how SAS behaves on the 
> wire, which is a rather limited group.
> 
> I'm willing to help anyone who proactively moves in this direction, but 
> they need to be proactive about it...  I am the person who will have to 
> make introductions at Broadcom, and convince Broadcom that new Person is 
> a highly capable SAS software engineer.
> 
> Telling bcm "I don't know this guy, its doubtful he knows SAS, but we 
> want to make him the primary engineer anyway" is not a very winning tale :)

I wasn't actually planning that ... I was planning to say we have an NDA
programme to allow them to get their docs and early access silicon in to
the hands of potential developers who can help on the driver.

> > SMP and STP, by the way, are simple frame in, frame out.  If it
> > identifies the initiator and target protocols and allows us to send
> > frames, we can probably transmit both protocols.
> [...]
> > That's going to be a bit of a bit oops ...
> [...]
> > well, I suppose it was designed for simple direct connection ...
> 
> That's the way it's looking.  There are a few avenues for exposing 
> IDENTIFY and OPEN frames and related details, but no obvious "any frame, 
> no problem" method like with the Marvell chip.
> 
> IMO it's also indicative that Marvell's chip uses a single set of 
> command and response queues, whereas Broadcom has command/response 
> queues for each "port" (bcm's term).

Heh, OK ... I'm happy to bet that the market won't be too appreciative
of a chip like this, unless its sold as pure SATA.  The only real reason
for HBAs to speak SAS as well as SATA is that most dual SAS/SATA
enclosures have internal expanders, which this chip won't be able to
talk to.

On the other hand, I think I can find a nice lever to move Marvell with,
so I'll take this on without needing potentially to compromise your
contacts.

James


