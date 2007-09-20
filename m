From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH ver2 1/2] libata-scsi: Remove !use_sg code paths
Date: Thu, 20 Sep 2007 17:12:13 -0400
Message-ID: <46F2E22D.9030404@garzik.org>
References: <46E6F92D.2090409@panasas.com> <46E72B8D.1080508@panasas.com> <46E72E4F.9020508@garzik.org> <46EFF2C4.8050204@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:59525 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbXITVMz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2007 17:12:55 -0400
In-Reply-To: <46EFF2C4.8050204@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>

Boaz Harrosh wrote:
>      This is a minimal patch needed to remove use of !use_sg
>      but it is not a complete clean up of the !use_sg paths.
>      Libata-core still has the qc->flags & ATA_QCFLAG_SG
>      and !qc->n_elem code paths. Perhaps an ata maintainer
>      would have a go at it.
> 
>      - TODO: further cleanup of qc->flags & ATA_QCFLAG_SG
>        and !qc->n_elem code paths in libata-core
>      - TODO: Use scsi_dma_{map,unmap} where applicable.
> ---
>  drivers/ata/libata-scsi.c |   31 +++++++++----------------------
>  1 files changed, 9 insertions(+), 22 deletions(-)

applied 1-2


