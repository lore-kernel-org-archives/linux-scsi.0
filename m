From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [patchset 0/24] Lots of the Accessors patches and !use_sg cleanup
Date: Wed, 12 Sep 2007 17:00:30 +0100 (BST)
Message-ID: <Pine.LNX.4.64N.0709121654580.24030@blysk.ds.pg.gda.pl>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:56344 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbXILQAq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Sep 2007 12:00:46 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Jeff Garzik <jeff@garzik.org>, "David S. Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>

On Tue, 11 Sep 2007, Boaz Harrosh wrote:

> [esp family] - Maciej W. Rozycki <macro@linux-mips.org>
> 0020 	drivers/scsi/NCR53C9x.c drivers/scsi/NCR53C9x.h
> 	drivers/scsi/dec_esp.c drivers/scsi/oktagon_esp.c
> 	drivers/scsi/sun3x_esp.c

 Not really, but I have suitable hardware and can test your changes to 
drivers/scsi/NCR53C9x.c, drivers/scsi/NCR53C9x.h and 
drivers/scsi/dec_esp.c only.  Fortunately it does not really matter that 
much, because the the whole family of drivers has been deprecated and is 
going away at some pace in favour to the framework around the new 
drivers/scsi/esp_scsi.c core.

 Thanks for your effort though!

  Maciej
