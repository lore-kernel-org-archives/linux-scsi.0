From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: ipr: fix incorrect indentation of assignment
 statement
Date: Fri, 1 Dec 2017 10:30:46 -0600
Message-ID: <fd65226e-5c5f-365a-b425-3eb4975dc9b8@linux.vnet.ibm.com>
References: <20171201133327.15515-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47750 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750994AbdLAQaw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Dec 2017 11:30:52 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vB1GTKOh140478
        for <linux-scsi@vger.kernel.org>; Fri, 1 Dec 2017 11:30:52 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ek8p8f69b-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 01 Dec 2017 11:30:51 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Fri, 1 Dec 2017 09:30:50 -0700
In-Reply-To: <20171201133327.15515-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Brian King <brking@us.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/01/2017 07:33 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Remove one extraneous level of indentation on an assignment statement.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/ipr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index cc0187965eee..e07dd990e585 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -9653,8 +9653,8 @@ static int ipr_alloc_cmd_blks(struct ipr_ioa_cfg *ioa_cfg)
>  			if (i == 0) {
>  				entries_each_hrrq = IPR_NUM_INTERNAL_CMD_BLKS;
>  				ioa_cfg->hrrq[i].min_cmd_id = 0;
> -					ioa_cfg->hrrq[i].max_cmd_id =
> -						(entries_each_hrrq - 1);
> +				ioa_cfg->hrrq[i].max_cmd_id =
> +					(entries_each_hrrq - 1);
>  			} else {
>  				entries_each_hrrq =
>  					IPR_NUM_BASE_CMD_BLKS/
> 

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
