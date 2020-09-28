Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50458C2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 21:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9444208FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 21:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sM6I+Ib8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgI1VGp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 17:06:45 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50890 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgI1VGp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 17:06:45 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SKxrHM192833;
        Mon, 28 Sep 2020 21:06:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ifl4HVFv/9MzfbYQJz6+eFDULlco7rg+DkArJPfXGOU=;
 b=sM6I+Ib8T/XfgmQgRSDZnjJwmjGraFjqjgOwSf2BKkUjw6rzfOtOYC1LP/mGewRKms5R
 jQVauzpmp4IruAr2JvFTn73k5qJ8anHjALR4vHKYmQAIkoTCgTvoiKEURklE70glG4lS
 TN18ktE958ikdY0FDIG1i9WPj+43e7yVTo4b4vsNxnQ1jD1IwfRJRC7UyLPLaoKyIMBX
 5CpNrkGfzyUQhwKrwCXJLwwHfMsu1C6UmGcWsJxT5Urd3jo0779//6uO7Pii/Cu6oY0o
 fNf6tnzkOHqjoerKYtw+vVINh13yEtMsnfg54+0z2DcQQ1qobbDAkw1VOgD8sbTq9R5E HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33su5aqfr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 21:06:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SL6NTC152417;
        Mon, 28 Sep 2020 21:06:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33tfhwr9an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 21:06:43 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SL6fIh005595;
        Mon, 28 Sep 2020 21:06:41 GMT
Received: from [10.154.166.223] (/10.154.166.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 14:06:41 -0700
Subject: Re: [PATCH 7/7] qla2xxx: Update version to 10.02.00.103-k
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200928055023.3950-1-njavali@marvell.com>
 <20200928055023.3950-8-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Message-ID: <c88e06e1-29ab-2a7a-38e0-6af3a1808415@oracle.com>
Date:   Mon, 28 Sep 2020 16:06:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200928055023.3950-8-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280161
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/20 12:50 AM, Nilesh Javali wrote:
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_version.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
> index 0f5a5f17dcef..120e511d2ed5 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -7,9 +7,9 @@
>   /*
>    * Driver version
>    */
> -#define QLA2XXX_VERSION      "10.02.00.102-k"
> +#define QLA2XXX_VERSION      "10.02.00.103-k"
>   
>   #define QLA_DRIVER_MAJOR_VER	10
>   #define QLA_DRIVER_MINOR_VER	2
>   #define QLA_DRIVER_PATCH_VER	0
> -#define QLA_DRIVER_BETA_VER	102
> +#define QLA_DRIVER_BETA_VER	103
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                         Oracle Linux Engineering
