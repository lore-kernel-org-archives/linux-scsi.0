From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH RESEND] mptscsih: Fix first line of kernel-doc for a few
 functions
Date: Wed, 31 Mar 2010 09:13:12 -0700
Message-ID: <20100331091312.bcd848c2.randy.dunlap@oracle.com>
References: <1266157055.10567.13.camel@localhost>
	<1269404879.18314.276.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:45837 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab0CaQOH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2010 12:14:07 -0400
In-Reply-To: <1269404879.18314.276.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: James Bottomley <James.Bottomley@suse.de>, Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org

On Wed, 24 Mar 2010 04:27:59 +0000 Ben Hutchings wrote:

> The function name must be followed by a space, hypen, space, and a
> short description.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

James, will you be handling this patch or should I?


> ---
>  drivers/message/fusion/mptscsih.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index 4a7d1af..53516ed 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -2560,9 +2560,7 @@ mptscsih_getclear_scsi_lookup(MPT_ADAPTER *ioc, int i)
>  }
>  
>  /**
> - * mptscsih_set_scsi_lookup
> - *
> - * writes a scmd entry into the ScsiLookup[] array list
> + * mptscsih_set_scsi_lookup - write a scmd entry into the ScsiLookup[] array list
>   *
>   * @ioc: Pointer to MPT_ADAPTER structure
>   * @i: index into the array
> @@ -2725,7 +2723,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req,
>  
> 
>  /**
> - *	mptscsih_get_completion_code -
> + *	mptscsih_get_completion_code - get completion code from MPT request
>   *	@ioc: Pointer to MPT_ADAPTER structure
>   *	@req: Pointer to original MPT request frame
>   *	@reply: Pointer to MPT reply frame (NULL if TurboReply)
> -- 

Thanks,
---
~Randy
