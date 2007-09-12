From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 09/24] libata-scsi: convert to use the data buffer accessors
Date: Tue, 11 Sep 2007 20:09:51 -0400
Message-ID: <46E72E4F.9020508@garzik.org>
References: <46E6F92D.2090409@panasas.com> <46E72B8D.1080508@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:45922 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759217AbXILAKg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Sep 2007 20:10:36 -0400
In-Reply-To: <46E72B8D.1080508@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>

I would much rather see the !use_sg cleanup in a separate patch series...

	Jeff



