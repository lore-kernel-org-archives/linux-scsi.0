From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] SCSI, libata: add support for ATA_16	commands	to	libata
 ATAPI devices
Date: Wed, 03 Jan 2007 12:58:10 -0500
Message-ID: <459BEEB2.9000903@rtr.ca>
References: <200701021935.07840.liml@rtr.ca>	 <1167788405.3687.25.camel@mulgrave.il.steeleye.com>	 <459B4243.5080804@rtr.ca>	 <1167838307.2789.12.camel@mulgrave.il.steeleye.com>	 <459BCF82.5000906@garzik.org> <1167839851.2789.17.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1167839851.2789.17.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, Linux IDE <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
>
> Er I've only seen one patch ... I did ask if there was another to add
> the ATA_16 interpretation ... did that get lost by the SCSI reflector?

Ahh.. my apologies on that, James.

The two patches apply and build independently,
and the second patch was only for libata, so it was
sent only to the linux-ide list.

There's actually a third patch as well, to fix a one-line
bug in sr.c that prevents *any* SG_IO from ever working
on ATAPI as well.

I'll email you the full set.

Cheers!

