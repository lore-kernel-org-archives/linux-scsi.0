From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: New IDE maintainer (was Re: cmd64x: irq 14: nobody cared -
 system  	is dreadfully slow)
Date: Mon, 22 Jun 2009 18:32:18 +0100
Message-ID: <20090622183218.15d340d5@lxorguk.ukuu.org.uk>
References: <20090621.141950.160759111.davem@davemloft.net>
	<4A3FB956.6060401@garzik.org>
	<20090622181100.43a56309@lxorguk.ukuu.org.uk>
	<200906221921.21709.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200906221921.21709.arnd@arndb.de>
Sender: linux-ide-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jeff Garzik <jeff@garzik.org>, Greg Freemyer <greg.freemyer@gmail.com>, David Miller <davem@davemloft.net>, bzolnier@gmail.com, elendil@planet.nl, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> Actually, m68k, m32r and h8300 currently can't use libata at all
> for one reason or another, mostly missing support for dma-mapping.h

That wants fixing and your ifdef patches looked a route to beat it into
some kind of shape

> side, it should be possible to convert almost any non-PCI ATA
> chip to use drivers/ata/pata_platform.c or pata_of_platform.c.

The ioc4 and the ppc ones are a bit harder as they have custom DMA
descriptor tables and stuff. The rest I agree.
