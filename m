From: Andi Kleen <andi@firstfloor.org>
Subject: Re: PATCH[1/1] pmcraid driver fix to remove duplicate struct member
Date: Tue, 26 Oct 2010 19:39:05 +0200
Message-ID: <20101026173905.GE29961@basil.fritz.box>
References: <alpine.LNX.1.10.1010251536390.29896@rslab235.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:35161 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab0JZRjM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2010 13:39:12 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.1010251536390.29896@rslab235.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, andi@firstfloor.org

On Mon, Oct 25, 2010 at 03:41:54PM -0700, Anil Ravindranath wrote:
> 
> The following patch fixes removal of a duplicate struct member definition.
> 
> Signed-off-by: Anil Ravindranath<anil_ravindranath@pmc-sierra.com>

Thanks. This fixes the problem for me.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi

> 
> pmcraid.h |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- scsi-misc-2.6.orig/drivers/scsi/pmcraid.h	2010-10-25 17:24:23.000000000 -0700
> +++ scsi-misc-2.6/drivers/scsi/pmcraid.h	2010-10-25 17:23:51.000000000 -0700
> @@ -568,7 +568,6 @@
>  	struct pmcraid_control_block *ioa_cb;
>  	dma_addr_t ioa_cb_bus_addr;
>  	dma_addr_t dma_handle;
> -	u8 *sense_buffer;
>  
>  	/* pointer to mid layer structure of SCSI commands */
>  	struct scsi_cmnd *scsi_cmd;
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
