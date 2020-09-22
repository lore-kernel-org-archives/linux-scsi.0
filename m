Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86446C4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36DD823A32
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m7muJC4e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgIVD5v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:57:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60924 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728890AbgIVD5t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3nHK9040988;
        Tue, 22 Sep 2020 03:57:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=+2J6NWp7QtI2g6+1NY5wB8JmnyvBSWGXccQzRl73YAE=;
 b=m7muJC4eFrGV2kUb7Jil5pGkYt9sJrnP9bur6TLKznvUWn6nTnBiKy7Vl4AcnQ672FFq
 dEKP8+dYtGjJ9iZLoMlJcSvXqTYI0WPF3RxUQq45vCXUYUHqgvhDcy/sosa78OtMS5gg
 d/b1N24sGbvC7WRJx8SWrTgbMH51JnIrQ5YHzr5GRPL+vUHFYhHpqCxgTvZgE2Xku7sn
 onKaQ6OfgR+bu//oSAqZy39Y+lykqVgcdBmetUcfkOM4HQbwyU3DlWT6i8R1iietCIfZ
 wXV8pNYA1hjAgshmaYz6jKpo9Kq5EAo3YRtTq2A2f5+CywwNSUPvCwPSd5dDGXAP8jAL rA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33ndnuagns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3uIc7149662;
        Tue, 22 Sep 2020 03:57:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33nujmm8t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:37 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3va8D009594;
        Tue, 22 Sep 2020 03:57:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:35 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        hare@kernel.org, lee.jones@linaro.org, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: myrs: make some symbols static
Date:   Mon, 21 Sep 2020 23:57:03 -0400
Message-Id: <160074695011.411.2283383360788310932.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915084008.2826835-1-yanaijie@huawei.com>
References: <20200915084008.2826835-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=911 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=925 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Sep 2020 16:40:08 +0800, Jason Yan wrote:

> This addresses the following sparse warning:
> 
> drivers/scsi/myrs.c:1532:5: warning: symbol 'myrs_host_reset' was not
> declared. Should it be static?
> drivers/scsi/myrs.c:1922:27: warning: symbol 'myrs_template' was not
> declared. Should it be static?
> drivers/scsi/myrs.c:2036:31: warning: symbol 'myrs_raid_functions' was
> not declared. Should it be static?
> drivers/scsi/myrs.c:2046:6: warning: symbol 'myrs_flush_cache' was not
> declared. Should it be static?

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: myrs: Make some symbols static
      https://git.kernel.org/mkp/scsi/c/ebe41b991d37

-- 
Martin K. Petersen	Oracle Linux Engineering
