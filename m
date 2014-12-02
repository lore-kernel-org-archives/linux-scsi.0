From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH RESEND 5/5] ipr: Driver version 2.6.1
Date: Tue, 02 Dec 2014 16:25:29 -0500
Message-ID: <20141202162529.Horde.l1Hf4ogfpZ9ZyzLGMsvUoQ1@ltc.linux.ibm.com>
References: <201412021847.sB2IloUm009132@d03av05.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54573 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800AbaLBV0H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2014 16:26:07 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Tue, 2 Dec 2014 16:26:07 -0500
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 494C96E8061
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2014 16:17:28 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sB2LPXOA25690312
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 21:25:33 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sB2LPVH1013332
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 16:25:31 -0500
In-Reply-To: <201412021847.sB2IloUm009132@d03av05.boulder.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@hansenpartnership.com, hch@lst.de, linux-scsi@vger.kernel.org, anton@samba.org


Reviewed-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>

Thanks,
Wendy


Quoting Brian King <brking@linux.vnet.ibm.com>:

> Bump driver version.
>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>
>  drivers/scsi/ipr.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff -puN drivers/scsi/ipr.h~ipr_version_2_6_1 drivers/scsi/ipr.h
> --- scsi-queue/drivers/scsi/ipr.h~ipr_version_2_6_1	2014-12-02  
> 12:25:20.232176757 -0600
> +++ scsi-queue-bjking1/drivers/scsi/ipr.h	2014-12-02 12:43:38.004935750 -0600
> @@ -39,8 +39,8 @@
>  /*
>   * Literals
>   */
> -#define IPR_DRIVER_VERSION "2.6.0"
> -#define IPR_DRIVER_DATE "(November 16, 2012)"
> +#define IPR_DRIVER_VERSION "2.6.1"
> +#define IPR_DRIVER_DATE "(December 2, 2014)"
>
>  /*
>   * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
> _


