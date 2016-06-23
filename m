From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] tcm_qla2xxx: fix spelling mistake: "seperator" ->
 "separator"
Date: Thu, 23 Jun 2016 13:26:38 -0400 (EDT)
Message-ID: <938501055.927953.1466702798033.JavaMail.zimbra@redhat.com>
References: <1466701945-8510-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:49744 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbcFWR0n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2016 13:26:43 -0400
In-Reply-To: <1466701945-8510-1-git-send-email-colin.king@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Colin King" <colin.king@canonical.com>
> To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>,
> linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Sent: Thursday, June 23, 2016 1:12:25 PM
> Subject: [PATCH] tcm_qla2xxx: fix spelling mistake: "seperator" -> "separator"
> 
> From: Colin Ian King <colin.king@canonical.com>
> 
> trivial fix to spelling mistake in pr_err message
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 6643f6f..46fe6f4 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1738,7 +1738,7 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
>  
>  	p = strchr(tmp, '@');
>  	if (!p) {
> -		pr_err("Unable to locate NPIV '@' seperator\n");
> +		pr_err("Unable to locate NPIV '@' separator\n");
>  		return ERR_PTR(-EINVAL);
>  	}
>  	*p++ = '\0';
> --
> 2.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Simple change, and its fine
Reviewed-by Laurence Oberman <loberman@redhat.com>
