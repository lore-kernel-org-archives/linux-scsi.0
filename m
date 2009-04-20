From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: fix debug macro call in ipr_reset_restore_cfg_space()
Date: Mon, 20 Apr 2009 17:11:13 -0500
Message-ID: <49ECF301.7050809@linux.vnet.ibm.com>
References: <1240255436.7458.145.camel@zeppelin.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:51274 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078AbZDTWL3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2009 18:11:29 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e37.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3KMAvZB022591
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 16:10:57 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3KMBSrP086772
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 16:11:28 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3KMBSVI011414
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 16:11:28 -0600
In-Reply-To: <1240255436.7458.145.camel@zeppelin.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kleber S. Souza" <klebers@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Acked by: Brian King <brking@linux.vnet.ibm.com>

Kleber S. Souza wrote:
> The key functions of the ipr driver call two macros defined in 'ipr.h',
> 'ENTER' and 'LEAVE', upon entering and leaving the functions, in order
> to print debug messages when the driver is loaded with the option
> 'debug=1'. Before returning, ipr_reset_restore_cfg_space() calls 'ENTER'
> where it should call 'LEAVE'. This patch calls the right macro before
> returning from the function.
> 
> 
> 
> Signed-off-by: Kleber S. Souza <klebers@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index c09d775..23f4af2 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -6522,7 +6522,7 @@ static int ipr_reset_restore_cfg_space(struct
> ipr_cmnd *ipr_cmd)
>                 }
>         }
> 
> -       ENTER;
> +       LEAVE;
>         return IPR_RC_JOB_CONTINUE;
>  }
> 
> --
> 
> 


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


