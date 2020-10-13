Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70580C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3719F21D7A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:44:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ymt6Rji2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgJMWnw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:43:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34500 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729036AbgJMWng (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:43:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMYZ2q023515;
        Tue, 13 Oct 2020 22:43:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JtLQCR+qgIBT+aF8USFopweRY01LXa6oPpA9TS6nqbk=;
 b=Ymt6Rji2GfPUfaHDo6oBWN+fw2JpP6VHS7PWaWlGBl6PT9B2fLypQW5mBGtHTQvobhpO
 lF67jhuR5E60Uf5rN+SbrOH9A3AmFcWTfSzYMneNJJ/Biuq0DrFZwVHUnC6dOh19Yslx
 88wPQ61tWjEr/rZZzderXjYr8Vaw7mCMZ+0yqshUawY+3Znl+z66kNqP6KZS2zn/73oS
 7PxzhFyPazqkzFpUysiBij1fpA1MuLE3qyUh7gHHGGhzOpbcAuzdDy/xwC1R4bDQTPI5
 JhsYSivkc4Vz4vUzECCowkbcx5i2xPVFpwTvNvNglfUK5MbWiAAO9BclU8POxUBVZxvN yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3434wkmr8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:43:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMZZMK162693;
        Tue, 13 Oct 2020 22:43:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 344by2v0j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:30 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09DMhTKt002716;
        Tue, 13 Oct 2020 22:43:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:29 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: 53c700: Remove set but not used variable
Date:   Tue, 13 Oct 2020 18:43:05 -0400
Message-Id: <160262862431.3018.1360093192942294967.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918071422.19566-1-zhengyongjun3@huawei.com>
References: <20200918071422.19566-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=920 spamscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 clxscore=1011
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=936
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 18 Sep 2020 15:14:22 +0800, Zheng Yongjun wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/scsi/53c700.c: In function NCR_700_intr:
> drivers/scsi/53c700.c:1488:27: warning: variable ‘state’ set but not used [-Wunused-but-set-variable]
> 
> drivers/scsi/53c700.c: In function NCR_700_queuecommand_lck:
> drivers/scsi/53c700.c:1742:26: warning: variable ‘direction’ set but not used [-Wunused-but-set-variable]
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: 53c700: Remove set but not used variable
      https://git.kernel.org/mkp/scsi/c/ffab5e016b9b

-- 
Martin K. Petersen	Oracle Linux Engineering
