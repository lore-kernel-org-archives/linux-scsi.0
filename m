From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [patchset 0/24] Lots of the Accessors patches and !use_sg cleanup
Date: Mon, 17 Sep 2007 12:46:14 +0200
Message-ID: <200709171246.15142.bzolnier@gmail.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:6976 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbXIQLHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Sep 2007 07:07:04 -0400
Received: by ug-out-1314.google.com with SMTP id z38so709388ugc
        for <linux-scsi@vger.kernel.org>; Mon, 17 Sep 2007 04:07:03 -0700 (PDT)
In-Reply-To: <46E6F92D.2090409@panasas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Jeff Garzik <jeff@garzik.org>, "David S. Miller" <davem@davemloft.net>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>

On Tuesday 11 September 2007, Boaz Harrosh wrote:
> Here are more accessors patches. I have tried
> to find Maintainers of drivers but please help me if
> I missed any.

[ ... ]

> 0010 	drivers/scsi/eata_pio.c - Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> ?

not me, according to MAINTAINTERS file:

EATA-PIO SCSI DRIVER
P:      Michael Neuffer
M:      mike@i-Connect.Net
L:      linux-eata@i-connect.net, linux-scsi@vger.kernel.org
S:      Maintained

BTW patch looks obviously OK

> 0024 	drivers/scsi/ide-scsi.c - Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

This reminds me that ide-scsi needs a real Maintainer, I don't have a time to
closely follow-up SCSI changes...

Thanks,
Bart
