From: Jeff Garzik <jeff@garzik.org>
Subject: Re: dmesg spam
Date: Mon, 04 Feb 2008 15:24:28 -0500
Message-ID: <47A7747C.2040702@garzik.org>
References: <20080203143033.cfea0501.akpm@linux-foundation.org>	 <200802041524.55700.bzolnier@gmail.com>	 <20080204120548.79f3fe57.akpm@linux-foundation.org>	 <47A7721C.5020505@garzik.org> <1202156442.3096.107.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:52736 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758306AbYBDUYd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Feb 2008 15:24:33 -0500
In-Reply-To: <1202156442.3096.107.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

James Bottomley wrote:
> It's here in sr_ioctl.c:

Ah, indeed.  My grep-fu sucks today.


> I'm not averse to simply nuking the printk ... it's probably valueless
> in a modern kernel, since something dbussy is supposed to tell you to
> put a CD in the drive, not something in the kernel.

The reverse...  dbussy/HAL is implementing autodetection of media 
insertion, by polling ad infinitum.

	Jeff


