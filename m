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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1F2C4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB7F923A34
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eQrNtSk1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgIVD5v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:57:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728592AbgIVD5m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3nBmc040960;
        Tue, 22 Sep 2020 03:57:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Ro1h1kSA0fFTAVnoyLL7GPBx+bL6hQX8R69Us6jt56g=;
 b=eQrNtSk1cjFRfpeGCnU5FpRRC7mGZYo25xGBOyfIPlRL84SQr0YZNNkVYX/GXuSNqRb2
 nivJbGdnQx7OrprcY7rqmC20SWwNHygm7JY0SjusN5Rm+X1rvVXr3yii6/IRrCl3l++j
 U9zjgHS8tRguFH87xaGLWMNALHiRn2C9gz6D8tkdeodHfIfHHL1lhNQOYhoY167o4XFM
 1v4o3XtnNFsuUITfzii7zc8tu/Ky4Z5i+Lx6uWQxhd06CNekfZbcT57PNyYs9mNm2sTk
 UuuomvBMgXkLmv1xxg20uUjaeiLKqIW0sZPI+TCGGAlQMiEDB9LFge6GGROVg8p8Ro7U 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33ndnuagnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3uK4d073492;
        Tue, 22 Sep 2020 03:57:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33nurs30y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:28 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vQrH009558;
        Tue, 22 Sep 2020 03:57:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:26 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        skashyap@marvell.com, lee.jones@linaro.org,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        jhasan@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: bnx2fc: make a bunch of symbols static in bnx2fc_fcoe.c
Date:   Mon, 21 Sep 2020 23:56:57 -0400
Message-Id: <160074695011.411.15237620952258149268.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200912033758.142601-1-yanaijie@huawei.com>
References: <20200912033758.142601-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=985 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=994 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 12 Sep 2020 11:37:58 +0800, Jason Yan wrote:

> This eliminates the following sparse warning:
> 
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:53:1: warning: symbol
> 'bnx2fc_global_lock' was not declared. Should it be static?
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:111:6: warning: symbol
> 'bnx2fc_devloss_tmo' was not declared. Should it be static?
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:116:6: warning: symbol
> 'bnx2fc_max_luns' was not declared. Should it be static?
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:121:6: warning: symbol
> 'bnx2fc_queue_depth' was not declared. Should it be static?
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:126:6: warning: symbol
> 'bnx2fc_log_fka' was not declared. Should it be static?

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: bnx2fc: Make a bunch of symbols static in bnx2fc_fcoe.c
      https://git.kernel.org/mkp/scsi/c/5c2ef01448e9

-- 
Martin K. Petersen	Oracle Linux Engineering
