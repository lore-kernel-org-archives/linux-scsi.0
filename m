From: Andries Brouwer <Andries.Brouwer@cwi.nl>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Sat, 5 Nov 2005 00:56:46 +0100
Message-ID: <20051104235646.GE27090@apps.cwi.nl>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com> <1131130707.3532.45.camel@mulgrave> <20051104203004.GF12384@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051104203004.GF12384@one-eyed-alien.net>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Timothy Thelin <Timothy.Thelin@wdc.com>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 04, 2005 at 12:30:04PM -0800, Matthew Dharm wrote:
> On Fri, Nov 04, 2005 at 12:58:27PM -0600, James Bottomley wrote:

> > What happens if you prevent USB mangling the scsi_level?  I think, for
> > the most part, we would handle 0 in about the same way as we handle 2.
> > However, we could gate the if around the CDB[1] mangling as
> > 
> > if (scsi_level != SCSI_UNKNOWN && scsi_level <= SCSI_2)
> > 
> > which should fix your problem, I think.
> 
> A long time ago, usb-storage didn't mangle the scsi_level.  And almost
> nothing worked.  Without a SCSI level, 6-byte commands get sent; only
> 10-byte commands will do.

Yes, that was long ago. Haven't things improved?

(For example, I seem to recall adding stuff like use_10_for_{ms,rw}
to make it possible for usb storage to tell the SCSI layer that it
prefers 10-byte commands. Maybe no cheating with SCSI level is needed
anymore?)

Andries
