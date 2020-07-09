Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 859E7C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 19:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CC4D206DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 19:37:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RM+NcPrK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgGITho (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 15:37:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38482 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgGITho (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 15:37:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069JWerv006149;
        Thu, 9 Jul 2020 19:37:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=UU/JaDNo7nq3M6nXNlc8uGnAJ2g+0bGqx+PhDh4JV2k=;
 b=RM+NcPrKRIxNncxn0OsxZES7BfvJ3+7LN/Hr2eSSU0pQxGonl0NrDCJvD4wExDK14rWU
 COyCIHCGCyQcNM9RD3dxq2TPyq88JGB+zO+RrX4RTT8dolY5ekGYVNFBaAp0CsldQX3f
 ufxqGftkXSxi5tBtED7w+OmGCXirFX3t0MZXd5hRyALFC8DnnNyFr1N+cOTYi6LEl49/
 +boNckUepJI4kcYzUho+bMpQEZoCU8psz6QsigJkCRcYiA6a8lMHCp95NsiV+zQoGjLb
 GN3BgL7AQDKPlzDjFyPR/KzlEzcRThhaPiPfxvJMFaBKCcv3H+w/bc4fXcYAEoqcn3AW Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 325y0akt2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 09 Jul 2020 19:37:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069JTJTb105778;
        Thu, 9 Jul 2020 19:37:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 325k3hfqg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jul 2020 19:37:39 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 069JbceI009921;
        Thu, 9 Jul 2020 19:37:38 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jul 2020 12:37:37 -0700
Subject: Re: [PATCH -next] scsi: target: Remove unused variable 'tpg'
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200709114636.69256-1-weiyongjun1@huawei.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <d2cbe2c2-f4f3-7d70-1c87-22619e13126a@oracle.com>
Date:   Thu, 9 Jul 2020 14:37:36 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200709114636.69256-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1011 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090132
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/9/20 6:46 AM, Wei Yongjun wrote:
> Gcc report warning as follows:
> 
> drivers/target/target_core_pr.c:1162:26: warning:
>  variable 'tpg' set but not used [-Wunused-but-set-variable]
>  1162 |  struct se_portal_group *tpg;
>       |                          ^~~
> 
> After commit 63c9ffe473d3 ("scsi: target: Check enforce_pr_isids
> during registration"), 'tpg' is never used, so removing it to
> avoid build warning.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/target/target_core_pr.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 300b03b1b696..8fc88654bff6 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -1159,7 +1159,6 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
>  {
>  	struct t10_reservation *pr_tmpl = &dev->t10_pr;
>  	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
> -	struct se_portal_group *tpg;
>  
>  	spin_lock(&pr_tmpl->registration_lock);
>  	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
> @@ -1170,7 +1169,6 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
>  		if (pr_reg->pr_reg_nacl != nacl)
>  			continue;
>  
> -		tpg = pr_reg->pr_reg_nacl->se_tpg;
>  		/*
>  		 * If this registration does NOT contain a fabric provided
>  		 * ISID, then we have found a match.
> 

Sorry. That was my fault. Thanks.

Reviewed-by: Mike Christie <michael.christie@oracle.com>

