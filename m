From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [patchset 0/24] Lots of the Accessors patches and !use_sg cleanup
Date: Mon, 17 Sep 2007 22:05:35 +0200
Message-ID: <200709172205.36070.bzolnier@gmail.com>
References: <46E6F92D.2090409@panasas.com> <200709171246.15142.bzolnier@gmail.com> <1190037090.3386.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:1755 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbXIQUDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Sep 2007 16:03:18 -0400
Received: by ug-out-1314.google.com with SMTP id z38so8129ugc
        for <linux-scsi@vger.kernel.org>; Mon, 17 Sep 2007 13:03:16 -0700 (PDT)
In-Reply-To: <1190037090.3386.3.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Jeff Garzik <jeff@garzik.org>, "David S. Miller" <davem@davemloft.net>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>, osst@riede.org


On Monday 17 September 2007, James Bottomley wrote:
> On Mon, 2007-09-17 at 12:46 +0200, Bartlomiej Zolnierkiewicz wrote:
> > 0024  drivers/scsi/ide-scsi.c - Bartlomiej Zolnierkiewicz
> > <bzolnier@gmail.com>
> > 
> > This reminds me that ide-scsi needs a real Maintainer, I don't have a
> > time to
> > closely follow-up SCSI changes...
> 
> Er, well, I thought it had been dead for some time ... we decided its

>From looking at git log output I suspect that it has been dead since
October 2006 (but I hasn't verified this yet so I may be wrong).

> many bugs were virtually unfixable in 2.5.  Willem Riede
> <osst@riede.org> had been trying to keep it working with chewing gum and
> bailing wire for the onstream tape unit.

Yes, osst driver seems to be the main user of ide-scsi nowadays,
other ATAPI devices has (better) native IDE support...

> Realistically (and I hate myself for saying this) libata-pata does
> provide a much better alternative for the ATAPI devices.  Is it just
> time to recognise the inevitable and kill ide-scsi?

Agreed, libata-pata is a much better version of ide-scsi. ;-)

If there is general consensus about ide-scsi removal I think that we
should start with disabling ide-scsi Kconfig entry in 2.6.24 to later
remove the ide-scsi driver completely in 2.6.25.

Bart
