From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 12:55:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020620195504.GJ32698@kroah.com>
References: <200206200711.RAA10165@thucydides.inspired.net.au> <Pine.LNX.4.44.0206200800260.8012-100000@home.transmeta.com> <20020620165553.GA16897@win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020620165553.GA16897@win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Linus Torvalds <torvalds@transmeta.com>, Martin Schwenke <martin@meltin.net>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>

On Thu, Jun 20, 2002 at 06:55:53PM +0200, Andries Brouwer wrote:
> USB device 0000:0000
> figure out some name...

<snip>

Heh, this is the first time anyone has ever reported those names to me.
Yes, the names aren't very useful yet, but give us time, patches gladly
accepted to fix this :)

The physical representation of the USB trees within the PCI tree is
(imho) a _vast_ improvement over anything we have had before, and that
is currently working quite well.

Now to hook up the USB bus code to the struct bus_type style code, like
PCI now is...

thanks,

greg k-h
