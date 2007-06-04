From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [SCSI]: JAZZ ESP and SUN ESP need SPI_ATTRS
Date: Sun, 3 Jun 2007 17:56:04 -0700
Message-ID: <20070603175604.0d500198.randy.dunlap@oracle.com>
References: <20070603.173625.85704021.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:36761 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbXFDA5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jun 2007 20:57:08 -0400
In-Reply-To: <20070603.173625.85704021.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Sun, 03 Jun 2007 17:36:25 -0700 (PDT) David Miller wrote:

> 
> Reported by Meelis Roos.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 572034c..e2b2838 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -1532,6 +1532,7 @@ source "drivers/scsi/arm/Kconfig"
>  config JAZZ_ESP
>  	bool "MIPS JAZZ FAS216 SCSI support"
>  	depends on MACH_JAZZ && SCSI
> +	select CONFIG_SCSI_SPI_ATTRS

	select SCSI_SPI_ATTRS
(no CONFIG_)

also below.

>  	help
>  	  This is the driver for the onboard SCSI host adapter of MIPS Magnum
>  	  4000, Acer PICA, Olivetti M700-10 and a few other identical OEM
> @@ -1756,6 +1757,7 @@ config SUN3X_ESP
>  config SCSI_SUNESP
>  	tristate "Sparc ESP Scsi Driver"
>  	depends on SBUS && SCSI
> +	select CONFIG_SCSI_SPI_ATTRS
>  	help
>  	  This is the driver for the Sun ESP SCSI host adapter. The ESP
>  	  chipset is present in most SPARC SBUS-based computers.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
