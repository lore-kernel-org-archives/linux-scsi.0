From: Greg KH <greg@kroah.com>
Subject: Re: PATCH: usb-storage: fix typo
Date: Fri, 24 Jan 2003 00:26:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030124082645.GB13260@kroah.com>
References: <20030119143058.A31114@one-eyed-alien.net> <20030119171602.D31114@one-eyed-alien.net> <20030123044306.GA6584@kroah.com> <20030123114040.B12788@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030123114040.B12788@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Thu, Jan 23, 2003 at 11:40:40AM -0800, Matthew Dharm wrote:
> Well, it's stored in my local tree as a large series of deltas.  But I'd
> settle for just being able to boot the kernel with debugging enabled and
> try it myself.
> 
> The problem is, it doesn't make any sense if split up into smaller pieces.
> The change from old hotplug system to new hotplug system really is one
> package.  I mean, I could send you the delta where I convert the probe
> mechanism to use the new system, but then it's just going to blow up when a
> device is detached.

But your patch did much more than just change systems, as you noted
(typedef changes, etc.).  Splitting it up into smaller pieces would help
in trying to figure out where the problem in the patch might be.

As it is, I can't do that :(

> I'll keep working on getting a booting configuration.  Some people have
> suggested turning off framebuffer support, but that's already off....

Hm, don't know what to say, I'm typing from 2.5.59 right now...

Good luck,

greg k-h
