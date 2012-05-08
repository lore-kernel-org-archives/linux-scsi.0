From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 0/3] scsi: usb-storage: hide errors for five devices
Date: Tue, 08 May 2012 17:37:33 +0200
Message-ID: <1336491453.1933.67.camel@x61.thuisdomein>
References: <Pine.LNX.4.44L0.1205081000250.1479-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:3366 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756106Ab2EHPhi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2012 11:37:38 -0400
In-Reply-To: <Pine.LNX.4.44L0.1205081000250.1479-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 10:02 -0400, Alan Stern wrote:
> On Tue, 8 May 2012, Paul Bolle wrote: 
> > 1) These patches try to hide those errors by:
> > - downgrading one error to a notice; and
> 
> That's a reasonable thing to do, IMO.
> 
> > - setting the NO_WP_DETECT quirk for these five devices.
> 
> But that isn't.  These quirks are intended for devices that crash when
> they receive the command in question.

Yes, these USB memory sticks don't crash. (They actually seem to work
just fine, something that I perhaps should have emphasized in the commit
descriptions.)

> They aren't meant to suppress sending commands to devices that can
> properly reject them.

Even the sticks that hit "bad_sense" (in sd_read_cache_type(), which I
forgot to mention in the comment descriptions)? Is that not as severe as
it suggests?

Of course, an easy way out would be to downgrade both the "Asking for
cache data failed" and the "No Caching mode page present" errors to
notices. But the SCSI people might disagree with that approach.


Paul Bolle

