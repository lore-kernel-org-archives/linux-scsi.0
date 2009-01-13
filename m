From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: [PATCH -next] libfc: needs CRC32
Date: Mon, 12 Jan 2009 17:05:00 -0700
Message-ID: <273D38FBE7C6FE46A1689FCD014A0B8B28A124F4@azsmsx505.amr.corp.intel.com>
References: <20090112154539.4857f533.sfr@canb.auug.org.au>
 <496B9112.8070908@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37395 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbZAMAFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2009 19:05:13 -0500
In-Reply-To: <496B9112.8070908@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> libfc uses crc32 functions, so cause it to be built
> via select:
> 
> drivers/built-in.o: In function `fc_frame_crc_check':
> (.text+0x75dae): undefined reference to `crc32_le'
> drivers/built-in.o: In function `fc_fcp_recv':
> fc_fcp.c:(.text+0x7b919): undefined reference to `crc32_le'
> fc_fcp.c:(.text+0x7b9d5): undefined reference to `crc32_le'
> fc_fcp.c:(.text+0x7ba54): undefined reference to `crc32_le'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Robert Love <robert.w.love@intel.com>

> ---
>  drivers/scsi/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20090112.orig/drivers/scsi/Kconfig
> +++ linux-next-20090112/drivers/scsi/Kconfig
> @@ -608,6 +608,7 @@ config SCSI_FLASHPOINT
>  config LIBFC
>  	tristate "LibFC module"
>  	select SCSI_FC_ATTRS
> +	select CRC32
>  	---help---
>  	  Fibre Channel library module
> 
> 
> --
> ~Randy

