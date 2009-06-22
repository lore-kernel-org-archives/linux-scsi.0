From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: New IDE maintainer (was Re: cmd64x: irq 14: nobody cared - system
 =?iso-8859-1?q?=09is_dreadfully?= slow)
Date: Mon, 22 Jun 2009 19:21:20 +0200
Message-ID: <200906221921.21709.arnd@arndb.de>
References: <20090621.141950.160759111.davem@davemloft.net> <4A3FB956.6060401@garzik.org> <20090622181100.43a56309@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:63611 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbZFVRVa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2009 13:21:30 -0400
In-Reply-To: <20090622181100.43a56309@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Greg Freemyer <greg.freemyer@gmail.com>, David Miller <davem@davemloft.net>, bzolnier@gmail.com, elendil@planet.nl, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Monday 22 June 2009, Alan Cox wrote:
> sgiioc4 is another obvious "modern machine" case. The rest are pretty
> obscure (eg mac68K drivers and IDE VLB drivers most of which don't
> actually work in the old IDE code even though there is code)

Actually, m68k, m32r and h8300 currently can't use libata at all
for one reason or another, mostly missing support for dma-mapping.h

Microblaze and the upcoming S+Core also lack DMA support right
now, but that should get rectified soon.

You could argue that still all of these fall into the 'obscure'
category, of course. With just a little effort on the architecture
side, it should be possible to convert almost any non-PCI ATA
chip to use drivers/ata/pata_platform.c or pata_of_platform.c.

	Arnd <><
