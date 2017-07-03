From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: qedf: fix spelling mistake: "offlading" ->
 "offloading"
Date: Mon, 3 Jul 2017 12:17:07 -0700
Message-ID: <7a0f8b50-1f7a-2d3d-4b2c-e52cfa282764@linux.vnet.ibm.com>
References: <20170703094401.11946-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36477 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753254AbdGCTRN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2017 15:17:13 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v63JEgIs019865
        for <linux-scsi@vger.kernel.org>; Mon, 3 Jul 2017 15:17:12 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bfqtga9q6-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 03 Jul 2017 15:17:12 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
        Mon, 3 Jul 2017 15:17:12 -0400
In-Reply-To: <20170703094401.11946-1-colin.king@canonical.com>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

On 07/03/2017 02:44 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake in QEDF_INFO message
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/qedf/qedf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index b58bba4604e8..dc93e968a448 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -1227,7 +1227,7 @@ static void qedf_rport_event_handler(struct fc_lport *lport,
>  
>  		if (rdata->spp_type != FC_TYPE_FCP) {
>  			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
> -			    "Not offlading since since spp type isn't FCP\n");
> +			    "Not offloading since since spp type isn't FCP\n");

Seems like a "since" could be dropped here as well.

-Tyrel

>  			break;
>  		}
>  		if (!(rdata->ids.roles & FC_RPORT_ROLE_FCP_TARGET)) {
> 
