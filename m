Return-Path: <SRS0=YASp=5T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D994C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 17:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D15320737
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 17:33:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DUO2FxlT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404457AbgDCRdZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Apr 2020 13:33:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46472 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404218AbgDCRdY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2020 13:33:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033HSE1Z011499;
        Fri, 3 Apr 2020 17:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+KjNjZ4jQ8rA5QWwc+4nBzWxqnv8XasqeFSuIWXOLHQ=;
 b=DUO2FxlTIrkXrtHZTCcpL7UlylSjl5N4NFlqDaDrTqr4ZCy7i9UYxKqnPPNUlttqC7WG
 aFfHa3Bsb252UKsIH8AANp7z5AiIf+DRKHfMBsp0VhYW2ozRtOhjS60Kcl8HPFqBSD77
 6VlADYRqJSVW6l9ixklX59NrlgfrEKECtQryl03age2F47dWqkg343N4Am7cPiwLrqm+
 xUcxPmuFxeF5i9/RU6FeabMpHD8A2dQ96BGKGUUaZkZsN81ACB/phq46LIZC5eTwyeER
 qPcflXqeMie5hdHpbNusIX9BrdF0fOHSwaRh7K3AdLuRHrauC+JoAG6cUmmpXm8ccqLa CQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 303cevjbur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 17:33:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033HRCc9032619;
        Fri, 3 Apr 2020 17:33:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 304sjtdgy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 17:33:21 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033HXKSq021545;
        Fri, 3 Apr 2020 17:33:20 GMT
Received: from [10.154.129.193] (/10.154.129.193)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 10:33:20 -0700
Subject: Re: [PATCH 2/2] MAINTAINERS: Update qla2xxx FC-SCSI driver maintainer
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200403084018.30766-1-njavali@marvell.com>
 <20200403084018.30766-3-njavali@marvell.com>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <28040b25-f1f7-4bdc-6efc-6d07fbd4bc7f@oracle.com>
Date:   Fri, 3 Apr 2020 12:33:19 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200403084018.30766-3-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030144
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 4/3/20 3:40 AM, Nilesh Javali wrote:
> Add njavali@marvell.com as new maintainer.
> Also add Marvell Upstream email alias to the maintainers list.
>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   MAINTAINERS | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7bd5e23648b1..c414536f3b3f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13714,7 +13714,8 @@ S:	Maintained
>   F:	drivers/scsi/qla1280.[ch]
>   
>   QLOGIC QLA2XXX FC-SCSI DRIVER
> -M:	hmadhani@marvell.com
> +M:	Nilesh Javali <njavali@marvell.com>
> +M:	GR-QLogic-Storage-Upstream@marvell.com
>   L:	linux-scsi@vger.kernel.org
>   S:	Supported
>   F:	Documentation/scsi/LICENSE.qla2xxx


Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

