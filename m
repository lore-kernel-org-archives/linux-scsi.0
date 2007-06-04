From: David Miller <davem@davemloft.net>
Subject: Re: [SCSI]: JAZZ ESP and SUN ESP need SPI_ATTRS
Date: Sun, 03 Jun 2007 18:38:36 -0700 (PDT)
Message-ID: <20070603.183836.35031446.davem@davemloft.net>
References: <20070603.173625.85704021.davem@davemloft.net>
	<20070603175604.0d500198.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43472
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbXFDBiW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jun 2007 21:38:22 -0400
In-Reply-To: <20070603175604.0d500198.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: randy.dunlap@oracle.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Sun, 3 Jun 2007 17:56:04 -0700

> On Sun, 03 Jun 2007 17:36:25 -0700 (PDT) David Miller wrote:
> 
> > 
> > Reported by Meelis Roos.
> > 
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > 
> > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > index 572034c..e2b2838 100644
> > --- a/drivers/scsi/Kconfig
> > +++ b/drivers/scsi/Kconfig
> > @@ -1532,6 +1532,7 @@ source "drivers/scsi/arm/Kconfig"
> >  config JAZZ_ESP
> >  	bool "MIPS JAZZ FAS216 SCSI support"
> >  	depends on MACH_JAZZ && SCSI
> > +	select CONFIG_SCSI_SPI_ATTRS
> 
> 	select SCSI_SPI_ATTRS
> (no CONFIG_)
> 
> also below.

My bad, sorry.  Here is the fixed version.

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 572034c..2b2f5c1 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1532,6 +1532,7 @@ source "drivers/scsi/arm/Kconfig"
 config JAZZ_ESP
 	bool "MIPS JAZZ FAS216 SCSI support"
 	depends on MACH_JAZZ && SCSI
+	select SCSI_SPI_ATTRS
 	help
 	  This is the driver for the onboard SCSI host adapter of MIPS Magnum
 	  4000, Acer PICA, Olivetti M700-10 and a few other identical OEM
@@ -1756,6 +1757,7 @@ config SUN3X_ESP
 config SCSI_SUNESP
 	tristate "Sparc ESP Scsi Driver"
 	depends on SBUS && SCSI
+	select SCSI_SPI_ATTRS
 	help
 	  This is the driver for the Sun ESP SCSI host adapter. The ESP
 	  chipset is present in most SPARC SBUS-based computers.
