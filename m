From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Make advansys depend on CONFIG_VIRT_TO_BUS
Date: Thu, 18 Oct 2007 22:20:17 -0700
Message-ID: <20071018222017.514df7b9.randy.dunlap@oracle.com>
References: <20071019150431.996522c5.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:60890 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbXJSFWa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 01:22:30 -0400
In-Reply-To: <20071019150431.996522c5.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Fri, 19 Oct 2007 15:04:31 +1000 Stephen Rothwell wrote:

> At least for now.

Please explain "why" in the changelog (what changelog?).

E.g.:
so that make allmodconfig on powerpc will have a better chance
of building.

or whatever.

> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/scsi/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 30905ce..325533c 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -523,6 +523,7 @@ config SCSI_ADVANSYS
>  	tristate "AdvanSys SCSI support"
>  	depends on SCSI
>  	depends on ISA || EISA || PCI
> +	depends on VIRT_TO_BUS
>  	help
>  	  This is a driver for all SCSI host adapters manufactured by
>  	  AdvanSys. It is documented in the kernel source in


---
~Randy
