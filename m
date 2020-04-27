Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB97DC7C881
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 14:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A760206BF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 14:11:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nSnHxoQ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgD0OLb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 10:11:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50882 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbgD0OLa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 10:11:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RDwgT9122711;
        Mon, 27 Apr 2020 14:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=FfKryTHGii14z6nNgtAaaZd9AI5n9IUL50y5SfEQqos=;
 b=nSnHxoQ0eVCpX8eiRTyg4uNU9A8jpQHUKG6XY9p2Pp2rV2fLoH9Ma/1zsL67YDkntYQ9
 F/Qd+hu3A4Mgc56dlT1BPezRlGnHdx/XAbnF37KbS7UjsGHY9b9dHc//1ffkJhGjY/Y6
 TQTbRu6hhrJvYtCm6EgPqW6wt4i10zbgLlyTiEFuUZx4aPPePt2hf87mLWEHYxtj0N/O
 Ax1i9tDRuiORMMtWGgq1DK+Kqyt0mcpamWaPoqer0EAKYo2uqghIF2CquOh66MvyBW0F
 9HvgHqqnTMdUT8a5Sn8qHReFP7/SRKx7ewCUzHau4lKCB4zxX7VLleCvirSBVxTYn9os NA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30nucfst4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 14:11:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RE81YS073130;
        Mon, 27 Apr 2020 14:11:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30mxww96ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 14:11:20 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03REBJJg002137;
        Mon, 27 Apr 2020 14:11:19 GMT
Received: from [10.154.123.249] (/10.154.123.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 07:11:18 -0700
Subject: Re: [PATCH v4 03/11] qla2xxx: Sort BUILD_BUG_ON() statements
 alphabetically
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-4-bvanassche@acm.org>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <99215663-7fa2-e784-b3cd-745febae916b@oracle.com>
Date:   Mon, 27 Apr 2020 09:11:06 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427030310.19687-4-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9603 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9603 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270119
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/26/20 10:03 PM, Bart Van Assche wrote:
> Before adding more BUILD_BUG_ON() statements, sort the existing statements
> alphabetically.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_os.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index d190db5ea7d9..497544413aa0 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7835,11 +7835,11 @@ qla2x00_module_init(void)
>   	BUILD_BUG_ON(sizeof(struct init_cb_24xx) != 128);
>   	BUILD_BUG_ON(sizeof(struct init_cb_81xx) != 128);
>   	BUILD_BUG_ON(sizeof(struct pt_ls4_request) != 64);
> +	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
> +	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
>   	BUILD_BUG_ON(sizeof(struct sns_cmd_pkt) != 2064);
>   	BUILD_BUG_ON(sizeof(struct verify_chip_entry_84xx) != 64);
>   	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
> -	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
> -	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
>   
>   	/* Allocate cache for SRBs. */
>   	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
