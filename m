From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Mon, 24 Mar 2003 08:29:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0303240827030.3010-100000@home.transmeta.com>
References: <1048519237.1982.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1048519237.1982.16.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


On 24 Mar 2003, James Bottomley wrote:
> > 
> > For disk-like media:
> > 
> > READ_10
> > WRITE_10
> 
> We do about the best we can for read and write.  For sd, we gauge the
> size of the command from the size of the medium:  <1Gb=> six byte, from
> 1Gb to 2Tb 10 byte, over 2Tb 16 byte, so I think this should all be
> fine.

Really? The code was _supposed_ to always start off with READ/WRITE_10's,
and then fall back to the old READ/WRITE_6 if it gets errors from that. Do 
we really have some broken random-number generator semantic still in teh 
SCSI layer? That sounds like a piece of crock.

		Linus

