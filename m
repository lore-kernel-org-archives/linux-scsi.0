Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E632C61DA4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 16:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbjBNQ6E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Feb 2023 11:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbjBNQ5x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2023 11:57:53 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112448A75
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 08:57:52 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31EGY94H005527;
        Tue, 14 Feb 2023 16:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=U2WBEEE3e8HBucFSXp26PXiwP0UCtWbM8NRUo3tWf7M=;
 b=sXyfS7CgB+wvMB7VbsiLII7OMRRoHpKc+EFdPKvrxSHAql84GX+SlkbwPlFoP3Oui27S
 cC2OM8Ss0ezNyY3w5acdg9PvxLg7g19TnOZF+eijFSrsvJmbkOuzdvAmQf0/qD42g6Z5
 zUnmEb9OE7j6luwRFqgVaaq4m9OFarQj3+267XKa/ICQEMDRxfb2b9UEvhNs87nbT2Nm
 VRfhA8Ha3lO3STG5BcxESf5qmxNs8S8LgkokyX9Hp3jKHFnM2iYX3/qG9G1WCNKuG0s3
 1Sp++Kk1/e1lYP8VAKE8F+aiIzhsmBA3wiyEhwdqGfekLUgJrKu6SxPE7XOxk1UsG9z3 Ww== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xb5yx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 16:57:43 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31EGrmft009621;
        Tue, 14 Feb 2023 16:57:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f5uug5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 16:57:41 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31EGuHod039739;
        Tue, 14 Feb 2023 16:57:41 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3np1f5uuff-2;
        Tue, 14 Feb 2023 16:57:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: Re: [PATCH] scsi: ufs: Fix kernel-doc syntax
Date:   Tue, 14 Feb 2023 11:57:28 -0500
Message-Id: <167639371124.486235.952607941313619417.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202220155.561115-1-bvanassche@acm.org>
References: <20230202220155.561115-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_11,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=901 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302140144
X-Proofpoint-ORIG-GUID: gLLZB0kM2bclP6QJcQbyHItZ9IFLyngn
X-Proofpoint-GUID: gLLZB0kM2bclP6QJcQbyHItZ9IFLyngn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 02 Feb 2023 14:01:42 -0800, Bart Van Assche wrote:

> Fix the following kernel-doc warnings:
> 
> drivers/ufs/core/ufs-mcq.c:87: warning: Function parameter or member 'hba' not described in 'ufshcd_mcq_config_mac'
> drivers/ufs/core/ufs-mcq.c:87: warning: Function parameter or member 'max_active_cmds' not described in 'ufshcd_mcq_config_mac'
> drivers/ufs/core/ufs-mcq.c:107: warning: Function parameter or member 'hba' not described in 'ufshcd_mcq_req_to_hwq'
> drivers/ufs/core/ufs-mcq.c:107: warning: Function parameter or member 'req' not described in 'ufshcd_mcq_req_to_hwq'
> drivers/ufs/core/ufs-mcq.c:128: warning: Function parameter or member 'hba' not described in 'ufshcd_mcq_decide_queue_depth'
> 
> [...]

Applied to 6.3/scsi-queue, thanks!

[1/1] scsi: ufs: Fix kernel-doc syntax
      https://git.kernel.org/mkp/scsi/c/b62c8292d223

-- 
Martin K. Petersen	Oracle Linux Engineering
