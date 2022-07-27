Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CC4C19F28
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 03:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240282AbiG0DQa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 23:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240285AbiG0DQO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 23:16:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622FC3DF0E;
        Tue, 26 Jul 2022 20:16:05 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26R2oK83009181;
        Wed, 27 Jul 2022 03:16:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=C8wbhD03kpiG5zY2Qo2Kmg3cUC4odTyatbySnGiNUpQ=;
 b=RWEn9z7fn8cF6y6PXItPtMNbGMRjxErz/hwJnBidBsSmuTY6xI4xLCQFrm7a834U2342
 wh936VmFINo6kkzByOnavhY4rmH0s3FnBvtKZTtCd9dA6x/qeMkqEfZ4YsT5gWDgCJzI
 fi8F+ZG47Va4yXs1jpm/62glYNwK9u/q2QvRGxC1b6f8aeTiaN49kFaOUWZHYoJrywVN
 ogBxeEnbJr8pZibUp9tkGAwrIZuqK2NsiRZXkCK4uAGeeQ+hLC0XBTsda8amHaqLPpbb
 p6GPPgW4bXaP06kkjZPNydfoooAWR30WyPcv8OT0X3rmCnL2s2/udXTVxJQy58cdHren oQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9anyu44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 03:16:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26R0uGhZ035503;
        Wed, 27 Jul 2022 03:16:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh633p3uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 03:16:01 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26R3E0gs008228;
        Wed, 27 Jul 2022 03:16:00 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3hh633p3uc-1;
        Wed, 27 Jul 2022 03:16:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: delete a stray tab
Date:   Tue, 26 Jul 2022 23:15:54 -0400
Message-Id: <165889172880.804.12453475666654969136.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <YtVCFshEJNC7ELid@kili>
References: <YtVCFshEJNC7ELid@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=870 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207270009
X-Proofpoint-ORIG-GUID: UM1md8yiGhjKhPllB4EOLVSKeO1_LgOf
X-Proofpoint-GUID: UM1md8yiGhjKhPllB4EOLVSKeO1_LgOf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Jul 2022 14:20:54 +0300, Dan Carpenter wrote:

> This code is intended one more tab than it should be.
> 
> 

Applied to 5.20/scsi-queue, thanks!

[1/1] scsi: mpi3mr: delete a stray tab
      https://git.kernel.org/mkp/scsi/c/502f4c18704d

-- 
Martin K. Petersen	Oracle Linux Engineering
