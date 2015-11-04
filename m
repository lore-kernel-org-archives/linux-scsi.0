From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 5/5] ipr: Driver version 2.6.3.
Date: Wed, 04 Nov 2015 13:51:25 -0500
Message-ID: <20151104135125.Horde.HIVw5DBxrqbeogUGz2-MlQ1@ltc.linux.ibm.com>
References: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
 <1446575170-18656-5-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:49706 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031139AbbKDSvf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 13:51:35 -0500
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Wed, 4 Nov 2015 13:51:34 -0500
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 0A61138C8046
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2015 13:51:32 -0500 (EST)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tA4IpVer51445942
	for <linux-scsi@vger.kernel.org>; Wed, 4 Nov 2015 18:51:31 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tA4IoDhu025010
	for <linux-scsi@vger.kernel.org>; Wed, 4 Nov 2015 13:50:14 -0500
In-Reply-To: <1446575170-18656-5-git-send-email-krisman@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com

Reviewed-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Thanks,
Wendy

Quoting Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>:

> Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
> index b16bcd1..a34c7a5 100644
> --- a/drivers/scsi/ipr.h
> +++ b/drivers/scsi/ipr.h
> @@ -39,8 +39,8 @@
>  /*
>   * Literals
>   */
> -#define IPR_DRIVER_VERSION "2.6.2"
> -#define IPR_DRIVER_DATE "(June 11, 2015)"
> +#define IPR_DRIVER_VERSION "2.6.3"
> +#define IPR_DRIVER_DATE "(October 17, 2015)"
>
>  /*
>   * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
> --
> 2.1.0


