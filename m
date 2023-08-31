Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC8AC83F16
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 01:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345662AbjHaBt0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345652AbjHaBtS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 21:49:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51DCCD2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 18:49:15 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0E4AW009572;
        Thu, 31 Aug 2023 01:49:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=PxIRorTwFP20HT36XBS6u/Rvck9wmPAPtZStQ+C2hZ0=;
 b=Zcg4ixYoaA2kfFVo6VRo/1m3fx3t5IIOeSn7PPqY8lIY8onDHbZMIwO5QbB5vwc6Lulb
 8VGWV5maZT3BnZ/Da6yep96rLW9U0jDl5qpXzZsCIiq0WsyHr+I+Da/652s+hyreokQz
 hjDxFEcGcikrJ1b61CPi8zpBs3S4ny90vTdPhpBTnWf2VJwPAbBhEmX2Ja+BoLL85Enb
 w/+NITeLCAKWFFonHHsvSQayA65kUeoyghAokNh3JKXz/rKc/S6Y4zfH7lZQiPNCqTt5
 AGYRhBooxJ6zNkzaQrd5eYvy/TeSU9XT7KqamH9N50SpdlHgJl33KUpey6V/yVp1Rn+X gw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9j4gtbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:49:07 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37V13JMp032818;
        Thu, 31 Aug 2023 01:49:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6dqtxqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:49:06 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37V1mnL7000352;
        Thu, 31 Aug 2023 01:49:06 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3sr6dqtxfw-12;
        Thu, 31 Aug 2023 01:49:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     skashyap@marvell.com, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        njavali@marvell.com, mrangankar@marvell.com, bvanassche@acm.org,
        Yue Haibing <yuehaibing@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: qed: Remove unused declarations
Date:   Wed, 30 Aug 2023 21:48:39 -0400
Message-Id: <169344360103.1293881.4098191224188211362.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230822143338.19120-1-yuehaibing@huawei.com>
References: <20230822143338.19120-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-31_01,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=477 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308310014
X-Proofpoint-GUID: YvR_zMReFrbIix30AzNN7B_FFqJ5QhHo
X-Proofpoint-ORIG-GUID: YvR_zMReFrbIix30AzNN7B_FFqJ5QhHo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Aug 2023 22:33:38 +0800, Yue Haibing wrote:

> Thes declarations are never implemented, remove them.
> 
> 

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: qed: Remove unused declarations
      https://git.kernel.org/mkp/scsi/c/e1a87e29fbc8

-- 
Martin K. Petersen	Oracle Linux Engineering
