From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: IDs
Date: Tue, 7 Jan 2003 12:02:59 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030107120259.A16280@beaverton.ibm.com>
References: <UTC200301071854.h07IsBH22403.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <UTC200301071854.h07IsBH22403.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Tue, Jan 07, 2003 at 07:54:11PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-kernel@one-eyed-alien.net, zwane@holomorphy.com

On Tue, Jan 07, 2003 at 07:54:11PM +0100, Andries.Brouwer@cwi.nl wrote:

> > If we had a complete white/black list of devices with/without a unique id,
> > there would be no ambiguity.
> 
> You mean for the devices on the white list.
> But most devices will not be on the white list.

I mean if it is not on the white list, treat it as black listed or ask
for user/admin input, so we safely handle the id.

> Our perceptions differ, I think. My impression is that chaos
> is the norm, and well-behaved devices are the exception.

For usb storage, cd's, and cheap storage yes, chaos.

> As you say - we can make a best effort and get a string that
> with some luck identifies the device uniquely. But no guarantees
> given.

Yep.

> Maybe that again means that the S/Z distinction can be dropped.

We still want to tell page 0x83 (starts with a number) from page 0x80
(currently starts with S) from default values (currently starts with Z).
Dropping the Z in favour of an empty string would be good.

-- Patrick Mansfield
