From: "Steven N. Hirsch" <shirsch@adelphia.net>
Subject: Re: sym53c8xx_2 negotiates improperly
Date: Sun, 15 Oct 2006 20:49:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0610152043090.5170@monarch.fast.net>
References: <Pine.LNX.4.64.0610151329300.8184@monarch.fast.net>
 <1160934902.3544.14.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0610151406320.8184@monarch.fast.net>
 <1160939042.3544.24.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0610151749080.6669@monarch.fast.net>
 <1160950861.3544.30.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta11.adelphia.net ([68.168.78.205]:37548 "EHLO
	mta11.adelphia.net") by vger.kernel.org with ESMTP id S1750787AbWJPAtc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 20:49:32 -0400
In-Reply-To: <1160950861.3544.30.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Steven N. Hirsch" <shirsch@adelphia.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 15 Oct 2006, James Bottomley wrote:

> Please don't drop linux-scsi ... it's always possible someone else will
> be interested in the Q&A.
> 

Sorry!

> > Is there a means to completely disable PPR negotiation with some hope of 
> > getting U160 operation?
> 
> No, that's impossible: PPR negotiation is physically required for u160
> and above.
> 
> > I have a support request in to Seagate, but I'm guessing this unit is an 
> > OEM pull and they'll tell me to go fly a kite...

I should hire myself out as a psychic.  That's exactly the response I 
received from them (though slightly more polite).

Do you or anyone have even a WAG as to how I can trick this thing into 
negotiating at u160?  There was an older thread on this list where someone 
discovered that their drive was very unhappy about having anything faster 
than 12.5 ns (aka factor of '9') mentioned(?)  I don't pretend to fully 
understand it, but since the drive in question was an SX series 
workstation drive of similar vintage I'm wondering if this makes sense to 
anyone.  If so, what could I do to tailor the initial PPR request?

In the meantime, I'm going to try the drive on an Adaptec 29160 in another 
machine and see what transpires.

Steve

