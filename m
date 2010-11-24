From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Wed, 24 Nov 2010 09:48:11 -0500
Message-ID: <20101124144811.GA29196@infradead.org>
References: <549123.75632.qm@web31809.mail.mud.yahoo.com>
 <1290593429.14652.33.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1290593429.14652.33.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: ltuikov@yahoo.com, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 24, 2010 at 10:10:29AM +0000, James Bottomley wrote:
> The final question is is it worth it?  Since USB devices are supposed to
> be hot unpluggable, surely a USB device with a write back cache would be
> a disaster: no-one will SYNC the cache on a surprise unplug anyway ...
> therefore there shouldn't really be any of them surviving in the wild
> (famous last words, I suppose).

There's tons of USB devices with writeback caches.  Recent windows
version tend to use the FUA bit a lot because of this.  And the linux
usb storage target implementation thus has a hook to ignore the FUA bit,
and it's probably not the only one..
