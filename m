From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] SCSI: dtc: Fixed a brace issue on return 0
Date: Tue, 25 Aug 2015 11:54:55 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1508241649310.19365@nippy.intranet>
References: <1435491896-9755-1-git-send-email-rudhresh.jk@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49848 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbbHYBzP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2015 21:55:15 -0400
In-Reply-To: <1435491896-9755-1-git-send-email-rudhresh.jk@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rudhresh <rudhresh.jk@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Sun, 28 Jun 2015, Rudhresh wrote:

> From: rudhresh <rudhresh.jk@gmail.com>
> 
> Return is not a function so parenthesis is not required
> 
> Signed-off-by: Rudhresh <rudhresh.jk@gmail.com>

Can you put your full name here?

You must address your patches to all of the interested parties (see 
scripts/get_maintainer.pl).

Please read Documentation/SubmittingPatches and adhere to the instructions 
therein.

-- 

>
> ---
>  drivers/scsi/dtc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
> index 4c74c7b..c793ecf 100644
> --- a/drivers/scsi/dtc.c
> +++ b/drivers/scsi/dtc.c
> @@ -363,7 +363,7 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
>  	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
>  	if (i > hostdata->spin_max_r)
>  		hostdata->spin_max_r = i;
> -	return (0);
> +	return 0;
>  }
>  
>  /****************************************************************
> @@ -417,7 +417,7 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
>  	rtrc(0);
>  	if (i > hostdata->spin_max_w)
>  		hostdata->spin_max_w = i;
> -	return (0);
> +	return 0;
>  }
>  
>  MODULE_LICENSE("GPL");
> 
