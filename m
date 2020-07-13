Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F675C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 17:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1F0C20663
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 17:06:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ar9oAFYf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbgGMRGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 13:06:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35758 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbgGMRGN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 13:06:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DGquSp070440;
        Mon, 13 Jul 2020 17:06:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=y1GjRcCwLl6K5BghuR9VMww4uWOUesST3gzhqcype4M=;
 b=Ar9oAFYfsMUFWZJh6vhy9R+x6UG8xVy8yCwyV5ddgyCYyysohQPP3b6G5Zm0EBxYJIiy
 KTccIIChY1fsk1luAbNU3NLlswFkOfCOq5Y+R4YAT87u3F/F7QlGQuhxn774jqSWLT/c
 wkhBSiKH01W9uir60DYZ3bfogQ2D3k2x94A8pmVtMXFOKtYXyYjfeQvD9WRWTxv+tE4g
 fkxa6j7uAoh1V5DZhjQn+Z0tDegBB0Ung1A7eIm2FRBHntMeSWMdFvjFTxQw91ZuLoM9
 TPczlV5OeEhsPkn+fmO/6eTG6Wx4zi6k2fTgvOAtXTxTlO+Y3p49wFZmfKs97FVtsStr vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32762n867g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 17:06:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DGsaNi039219;
        Mon, 13 Jul 2020 17:06:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 327qbvwxur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 17:06:02 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06DH61P7010206;
        Mon, 13 Jul 2020 17:06:01 GMT
Received: from [10.154.152.183] (/10.154.152.183)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 10:06:00 -0700
Subject: Re: [PATCH -next] scsi: target: Remove unused variable 'tpg'
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200709114636.69256-1-weiyongjun1@huawei.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <1fdb8a6d-e820-257c-3c94-b0a470beeb71@oracle.com>
Date:   Mon, 13 Jul 2020 12:05:58 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709114636.69256-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1011 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130122
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 7/9/20 6:46 AM, Wei Yongjun wrote:
> Gcc report warning as follows:
> 
> drivers/target/target_core_pr.c:1162:26: warning:
>   variable 'tpg' set but not used [-Wunused-but-set-variable]
>   1162 |  struct se_portal_group *tpg;
>        |                          ^~~
> 
> After commit 63c9ffe473d3 ("scsi: target: Check enforce_pr_isids
> during registration"), 'tpg' is never used, so removing it to
> avoid build warning.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>   drivers/target/target_core_pr.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 300b03b1b696..8fc88654bff6 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -1159,7 +1159,6 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
>   {
>   	struct t10_reservation *pr_tmpl = &dev->t10_pr;
>   	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
> -	struct se_portal_group *tpg;
>   
>   	spin_lock(&pr_tmpl->registration_lock);
>   	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
> @@ -1170,7 +1169,6 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
>   		if (pr_reg->pr_reg_nacl != nacl)
>   			continue;
>   
> -		tpg = pr_reg->pr_reg_nacl->se_tpg;
>   		/*
>   		 * If this registration does NOT contain a fabric provided
>   		 * ISID, then we have found a match.
> 
Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                     Oracle Linux Engineering
