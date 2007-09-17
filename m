From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patchset 0/24] Lots of the Accessors patches and !use_sg
	cleanup
Date: Mon, 17 Sep 2007 08:51:30 -0500
Message-ID: <1190037090.3386.3.camel@localhost.localdomain>
References: <46E6F92D.2090409@panasas.com>
	 <200709171246.15142.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44797 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753511AbXIQNvf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Sep 2007 09:51:35 -0400
In-Reply-To: <200709171246.15142.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Jeff Garzik <jeff@garzik.org>, "David S. Miller" <davem@davemloft.net>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>, osst@riede.org

On Mon, 2007-09-17 at 12:46 +0200, Bartlomiej Zolnierkiewicz wrote:
> 0024  drivers/scsi/ide-scsi.c - Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com>
> 
> This reminds me that ide-scsi needs a real Maintainer, I don't have a
> time to
> closely follow-up SCSI changes...

Er, well, I thought it had been dead for some time ... we decided its
many bugs were virtually unfixable in 2.5.  Willem Riede
<osst@riede.org> had been trying to keep it working with chewing gum and
bailing wire for the onstream tape unit.

Realistically (and I hate myself for saying this) libata-pata does
provide a much better alternative for the ATAPI devices.  Is it just
time to recognise the inevitable and kill ide-scsi?

James


