Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F8BC67868
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 05:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbiIAFNF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 01:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbiIAFNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 01:13:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619E41286E0
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 22:13:00 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VNmwuG026986;
        Thu, 1 Sep 2022 05:12:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=Kzli8W+s401GPIgTrtaFzi9w/cwVCyUueVVGIUqgmCs=;
 b=vNuddQFcjkbARIhWOF7hddOsYlJuNmywOsNB9ugAsXD5tYIWU6XJUbWwBF8nCUBj9uAf
 +T1WfwP9Cem93mPgQLd2YJL1eZdltcAxkBVd2KT7fg1su3aZnkhyJFuIqWmImSByAnWw
 Vz4mLOcyPrxthiwJXndusfOqiuOXO4jiIN/45AsuPTmfPW3FCxi8j3RKSWDUYjFNd59d
 FrkYD9q5Xbq6UBkUjyWRQA0KimBWjeBrtmYBqIaFkiuwrxzHvbM8hvmjh8xtQz5rDUBG
 x6NL+siQsQ3FjJ2sSan0PH/PmBnsR1jjBXvtgZMZX9U8eZP+v53nzFSgru+cACtZ4gxg Fw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7avsk03p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 05:12:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2813MSer033688;
        Thu, 1 Sep 2022 05:12:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ja6gr3g39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 05:12:58 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2815CsXR008754;
        Thu, 1 Sep 2022 05:12:58 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ja6gr3g0k-7;
        Thu, 01 Sep 2022 05:12:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] lpfc: Update lpfc to revision 14.2.0.6
Date:   Thu,  1 Sep 2022 01:12:51 -0400
Message-Id: <166200877449.26143.8292896256953917188.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220819011736.14141-1-jsmart2021@gmail.com>
References: <20220819011736.14141-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_02,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 phishscore=0 mlxlogscore=806 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010022
X-Proofpoint-GUID: 6j2Di2QrRlqqOxr-ONvBb4h0g3AT0DEv
X-Proofpoint-ORIG-GUID: 6j2Di2QrRlqqOxr-ONvBb4h0g3AT0DEv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 Aug 2022 18:17:29 -0700, James Smart wrote:

> Update lpfc to revision 14.2.0.6
> 
> This patch set contains fixes and removal of dead code.
> 
> The patches were cut against Martin's 5.20/scsi-queue tree
> 
> James Smart (7):
>   lpfc: Fix unsolicited FLOGI receive handling during PT2PT discovery
>   lpfc: Fix null ndlp ptr dereference in abnormal exit path for GFT_ID
>   lpfc: Rework MIB Rx Monitor debug info logic
>   lpfc: Add warning notification period to CMF_SYNC_WQE
>   lpfc: Remove SANDiags related code
>   lpfc: Update lpfc version to 14.2.0.6
>   lpfc: Copyright updates for 14.2.0.6 patches
> 
> [...]

Applied to 6.1/scsi-queue, thanks!

[1/7] lpfc: Fix unsolicited FLOGI receive handling during PT2PT discovery
      https://git.kernel.org/mkp/scsi/c/439b93293ff2
[2/7] lpfc: Fix null ndlp ptr dereference in abnormal exit path for GFT_ID
      https://git.kernel.org/mkp/scsi/c/59b7e210a522
[3/7] lpfc: Rework MIB Rx Monitor debug info logic
      https://git.kernel.org/mkp/scsi/c/bd269188ea94
[4/7] lpfc: Add warning notification period to CMF_SYNC_WQE
      https://git.kernel.org/mkp/scsi/c/71ddeeaf5bd5
[5/7] lpfc: Remove SANDiags related code
      https://git.kernel.org/mkp/scsi/c/2af33e5a031f
[6/7] lpfc: Update lpfc version to 14.2.0.6
      https://git.kernel.org/mkp/scsi/c/b5c6c88e5809
[7/7] lpfc: Copyright updates for 14.2.0.6 patches
      https://git.kernel.org/mkp/scsi/c/1775c2080eb1

-- 
Martin K. Petersen	Oracle Linux Engineering
