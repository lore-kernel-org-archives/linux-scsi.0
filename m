From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 24/24 ver3 ] ide-scsi.c: convert to data accessors and !use_sg cleanup
Date: Wed, 19 Sep 2007 21:59:09 +0200
Message-ID: <200709192159.09169.bzolnier@gmail.com>
References: <46E6F92D.2090409@panasas.com> <46E72F13.3090200@panasas.com> <46EFA81F.9090109@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:40933 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbXISUI1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Sep 2007 16:08:27 -0400
Received: by nf-out-0910.google.com with SMTP id g13so272656nfb
        for <linux-scsi@vger.kernel.org>; Wed, 19 Sep 2007 13:08:26 -0700 (PDT)
In-Reply-To: <46EFA81F.9090109@panasas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Jeff Garzik <jeff@garzik.org>, "David S. Miller" <davem@davemloft.net>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>

On Tuesday 18 September 2007, Boaz Harrosh wrote:
> 
>  - Convert ide-scsi to the new data accessors and cleanup
>    the !use_sg code paths.
> 
>   In old code the driver was trying to translate narrow commands,
>   if received, to wide commands. This code  path still assumed
>   scsi_cmnd->request_buffer is a linear char pointer.
>   This means that this driver was broken since 2.6.17.

2.6.17 so it has been broken for the last *six* kernel releases
(and 2.6.17 == 18 Jun 2006 so more than a year in the timescale).

This raises serious questions whether it is really worth to fix it

>   As suggested by Christoph Hellwig I set
>   use_10_for_rw = 1; and use_10_for_ms = 1;
>   for this device and completely killed the translation.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

anyway patch looks good

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
