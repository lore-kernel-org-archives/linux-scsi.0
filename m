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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE8EC4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2218A23A5B
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:58:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VWLI2LF4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgIVD6B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:58:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42236 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728898AbgIVD5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:52 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3nsv1149270;
        Tue, 22 Sep 2020 03:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=pUTdjZkoHtGRXB/YjX+KfHGaBNuopQG2hScRt7TzXq0=;
 b=VWLI2LF4lc9N1ar7vHp6+askHn5pxEorxNi1JV6/Fb6wVzGdDbGdL6AriesGjGi1WLez
 6NjdxtXrebtCP1Rh8KGz4Jcf3at6yuX1gwOp6O9zVqfnGGcI/qXDh9FPsooUuZq2N6NS
 qwvPKP249PcUDBg0VSCrVFMvDRNoAxhYMVvYD6tPInfFLG2ZVhYad0uyQfd31ipBFQhc
 SUzVUaZ/Tcm8F7cqREd7VVw+1hJeT5A73/kwsjvii8qX7qmvsSqq6xXjml2cx14gAPLQ
 akk7pWNsE/yca/i0IaozeXQKhrLcY0rZKT6F8ozg7w/97IGAS+jbBD/X4pMaTpM6VYC1 Cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33n7gad5uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3tLWX020830;
        Tue, 22 Sep 2020 03:57:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33nuwxk7av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:45 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vixF009718;
        Tue, 22 Sep 2020 03:57:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:44 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     YueHaibing <yuehaibing@huawei.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] scsi: aic94xx: Remove unused inline function
Date:   Mon, 21 Sep 2020 23:57:08 -0400
Message-Id: <160074695008.411.14340220393075261394.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200909135711.35728-1-yuehaibing@huawei.com>
References: <20200909135711.35728-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 9 Sep 2020 21:57:11 +0800, YueHaibing wrote:

> There is no caller in tree, so can remove it.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: aic94xx: Remove unused inline function
      https://git.kernel.org/mkp/scsi/c/3f4fee002b00

-- 
Martin K. Petersen	Oracle Linux Engineering
