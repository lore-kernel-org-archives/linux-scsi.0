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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE43C4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ABC323A5B
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:59:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gzyOPXIR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgIVD7m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:59:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49918 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgIVD7l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:59:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3xUQV097336;
        Tue, 22 Sep 2020 03:59:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=+7jGhh8AwxbhuMpYaT4YK6/veornAHDUb9JB8jO3Zu0=;
 b=gzyOPXIR3W/vwXpK9NMwoO0X6pCiu4Q4xhk+iV/1A+WjCf0KNiDrdqa3+N8YvmQXrqeh
 LGYQLzTquJENa+qQaCZ2QCZWA1mN4TIy4G3j9OODlQCZDggQMvk42+mCBFU2/FcRf30C
 U+Qu4Pxluj28pUPsXTLsPZ/Puat21RPEjaS2klpEpqDrOMi96zVPsRFDxLAV/VIKiqjd
 UKzjVVt2BOit1UQVS1h6w+smT2GeyhkWTMHJlEetgD5yoaR0f2rCVD5m0eGbDTLYhmhJ
 K5fFVKW1zQLswvbqcTYuhRdY7wFWwzq5GN0CE6fGIW0p8KQ+zrv9K6TanORRS/lxWON5 zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33q5rg8tbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:59:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3uKIX073524;
        Tue, 22 Sep 2020 03:57:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33nurs310p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:29 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vSf6032610;
        Tue, 22 Sep 2020 03:57:28 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:27 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: fnic: remove unneeded semicolon
Date:   Mon, 21 Sep 2020 23:56:58 -0400
Message-Id: <160074695008.411.3891148780306847793.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911091057.2938685-1-yanaijie@huawei.com>
References: <20200911091057.2938685-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=963 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=995 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220031
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 11 Sep 2020 17:10:57 +0800, Jason Yan wrote:

> This addresses the following coccinelle warning:
> 
> drivers/scsi/fnic/fnic_main.c:446:2-3: Unneeded semicolon

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: fnic: Remove unneeded semicolon
      https://git.kernel.org/mkp/scsi/c/bff8b14b0974

-- 
Martin K. Petersen	Oracle Linux Engineering
