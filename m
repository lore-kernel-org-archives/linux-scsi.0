Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD0F1FA373F
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Oct 2022 03:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiJVDwm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Oct 2022 23:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJVDwh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2022 23:52:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C918929822A;
        Fri, 21 Oct 2022 20:52:36 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29M1ik3D007042;
        Sat, 22 Oct 2022 03:52:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=zmgGt/OSajWuxKWhi1MxXx9dqTO7xXT4aOmAWv3ISjU=;
 b=N4ZxEGVsnj1yq0QjBbayTYtZRwPpI+L7zBCs1l/zORrnoMgYdcOHZqgCQkOGJptaVYN3
 WotoNovKFe3znbMBFVToYDO2DJ8kkckxKqvnGapN1vbee95uO0qIQPx/4MiNx9Vh2axK
 +3BcYpXoBWOqtmoE4MAqmYb17sPfWMXgNqtkJZ4eRsTRSZckkwCmrKhqFvF+7hkzo8An
 vJ2QkyLRWDf5/nZnfLu+mxoLaHZSBaoRUyrRtEclw3FSq6IldXTs9eZ0cESIx5rDP3Yi
 YljowJxvujfAgpMh5QVn/VCsWu0Fo1isSEqIHgLk/z/cy2oUm/vO0zS2Fw2kEE7M8/A/ IQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7ndtuht1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 03:52:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29M1XU7f015238;
        Sat, 22 Oct 2022 03:52:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8hk85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 03:52:28 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29M3qOMO004796;
        Sat, 22 Oct 2022 03:52:28 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3kc6y8hk7g-6;
        Sat, 22 Oct 2022 03:52:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Keoseong Park <keosung.park@samsung.com>, jejb@linux.ibm.com,
        axboe@kernel.dk, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        beanhuo@micron.com, ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix typo in comments
Date:   Fri, 21 Oct 2022 23:52:21 -0400
Message-Id: <166641048601.3488171.15006827009593421272.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221019034530epcms2p2b10e072bb66b3fd6cdbe0e2423c11735@epcms2p2>
References: <CGME20221019034530epcms2p2b10e072bb66b3fd6cdbe0e2423c11735@epcms2p2> <20221019034530epcms2p2b10e072bb66b3fd6cdbe0e2423c11735@epcms2p2>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210220021
X-Proofpoint-ORIG-GUID: MvCvNplHfKBuX6Qd9_MJsiOzBi8iRVHN
X-Proofpoint-GUID: MvCvNplHfKBuX6Qd9_MJsiOzBi8iRVHN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 19 Oct 2022 12:45:30 +0900, Keoseong Park wrote:

> Change "drity" to "dirty".
> 
> 

Applied to 6.1/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Fix typo in comments
      https://git.kernel.org/mkp/scsi/c/307539eed463

-- 
Martin K. Petersen	Oracle Linux Engineering
