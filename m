From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating
	autosense
Date: Thu, 11 Nov 2010 08:57:17 -0800
Message-ID: <20101111165717.GA8526@kroah.com>
References: <20101111134450.GB12291@kroah.com> <892012.17950.qm@web31804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:57348 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419Ab0KKQ43 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 11:56:29 -0500
Content-Disposition: inline
In-Reply-To: <892012.17950.qm@web31804.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 08:49:51AM -0800, Luben Tuikov wrote:
> --- On Thu, 11/11/10, Greg KH <greg@kroah.com> wrote:
> > On Fri, Oct 22, 2010 at 02:12:51PM
> > -0700, Luben Tuikov wrote:
> > > This patch solves two things:
> > > 1) Enables autosense emulation code to correctly
> > > interpret descriptor format sense data, and
> > > 2) Fixes a bug whereby the autosense emulation
> > > code would overwrite descriptor format sense data
> > > with SENSE KEY HARDWARE ERROR in fixed format, to
> > > incorrectly look like this:
> > > 
> > > Oct 21 14:11:07 localhost kernel: sd 7:0:0:0:
> > [sdc]? Sense Key : Recovered Error [current]
> > [descriptor]
> > > Oct 21 14:11:07 localhost kernel: Descriptor sense
> > data with sense descriptors (in hex):
> > > Oct 21 14:11:07 localhost kernel:? ? ?
> > ? 72 01 04 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> > > Oct 21 14:11:07 localhost kernel:? ? ?
> > ? 00 4f 00 c2 00 50
> > > Oct 21 14:11:07 localhost kernel: sd 7:0:0:0:
> > [sdc]? ASC=0x4 ASCQ=0x1d
> > > 
> > > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> > 
> > I need to get the ack from the usb-storage
> > maintainer.? Can you get that
> > so that I can apply this?
> 
> Hi Greg,
> 
> I don't know who the usb-storage maintainer is, as I've mostly
> contributed to linux-scsi. Do you?

$ ./scripts/get_maintainer.pl --roles --file drivers/usb/storage/usb.c
Matthew Dharm <mdharm-usb@one-eyed-alien.net> (maintainer:USB MASS STORAGE...)
Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM)
linux-usb@vger.kernel.org (open list:USB MASS STORAGE...)
usb-storage@lists.one-eyed-alien.net (open list:USB MASS STORAGE...)
linux-kernel@vger.kernel.org (open list)

Or you can just look in the MAINTAINERS file :)

> I know Alan acked this patch. Is it him? Any reason you didn't CC the
> usb-storage maintainer in this email?  Can you reply back to this
> thread CC-ing him? The only email I have in my address book is yours.

Please resend your patch to Matthew, and the people and lists listed
above.  I need his ack before I can take it.

thanks,

greg k-h
