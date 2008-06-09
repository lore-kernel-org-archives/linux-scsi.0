From: Greg KH <greg@kroah.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Mon, 9 Jun 2008 16:07:47 -0700
Message-ID: <20080609230747.GD23391@kroah.com>
References: <200806010415.05290.chris2553@googlemail.com> <20080606110345.581fdc77.akpm@linux-foundation.org> <1212777612.16182.21.camel@localhost.localdomain> <200806080619.17531.chris2553@googlemail.com> <1212950276.3574.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36401 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759592AbYFIXJU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 19:09:20 -0400
Content-Disposition: inline
In-Reply-To: <1212950276.3574.7.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: chris2553@googlemail.com, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org

On Sun, Jun 08, 2008 at 01:37:56PM -0500, James Bottomley wrote:
> > Because of this oddity, I've also built 2.6.26-rc5-git2 with verbose USB 
> > debugging on. A boot log from that kernel is attached. You will see lots of 
> > ETIME errors from usb. A log from a similarly verbose 2.6.25.5 kernel does not 
> > show these errors. usb-devel added to cc list.
> 
> I'm starting to think this might be a distribution problem.  I tried
> booting my laptop on your config (only system I have with ata_piix)
> without an initrd (bit painful for fedora 9) and I didn't see any slow
> downs (in fact it was a lot faster than previously; makes note to file
> bug with redhat about their initramfs).

What distro is this being seen on?  I know that openSUSE 11.0 betas did
have a bug in their init scripts that was causing a long delay, much
like this one.  But it has been fixed in the later releases
(hopefully...)

thanks,

greg k-h
