From: Greg KH <greg@kroah.com>
Subject: Re: 53C8XX /sys/devices/pci*/*/config revisited
Date: Sun, 15 May 2005 10:57:30 -0700
Message-ID: <20050515175730.GA3898@kroah.com>
References: <m3br7c4ur6.fsf@merlin.emma.line.org> <1116155603.6270.16.camel@laptopd505.fenrus.org> <1116156415.6270.19.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:12221 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S261157AbVEOR5g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 May 2005 13:57:36 -0400
Content-Disposition: inline
In-Reply-To: <1116156415.6270.19.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matthias Andree <matthias.andree@gmx.de>, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, gregkh@kroah.com

On Sun, May 15, 2005 at 01:26:55PM +0200, Arjan van de Ven wrote:
> 
> > if hal reads more than 64 bytes of config space (heck if it reads config
> > space at all) then it's terminally broken.
> 
> this brings up a bug in the kernel though....
> the config file is user readable! That's just plain dangerous and imo it
> should be a root-only file as a result.

No, it's safe (or it should be), just like /proc/bus/pci is readable by
anyone for libpci.

thanks,

greg k-h
