Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBDEC7EE24
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 02:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjEQCMt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 May 2023 22:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbjEQCMr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2023 22:12:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5704810CA
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 19:12:46 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GJxXW8007611;
        Wed, 17 May 2023 02:12:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=oBvuQBsJfuZ7E6sVVNh0YFIzrTe+qKDFGVwsU6DZPGQ=;
 b=jDQHMQINl8hwgMY01A8xEW2cQ+AOGBWr13SMEHs1AGe3ZP8rJH5cS5ALaZZ3QVKv9cdX
 HNNMXiRse58SB9yAn3vns6p6cY80RW8SZInA67/9aW/TCUnu5/UD/xyVK2U15cU5WM9O
 rplRwsq2qVdezGvKVmAS+R3XnXomTdvmX7qcDQI2AF8jrnm8P/tXNmWRgpAeTbY0GJtU
 3gFACT9Zcpa46vjh6M6yEg3vwUJTFxgnGPpEqSBOQczubX29K4mxjRIOfBl65RbJCEHe
 wHEXU/lZVXgaDRckw8wGZE9du6pk283Di2h/ZrZA/HCdlRCpQBsplbsrZEdl70kAK/0h 1Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj33uvctc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 02:12:44 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34GNF0bG025041;
        Wed, 17 May 2023 02:12:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj104tw15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 02:12:43 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34H2CdOE016064;
        Wed, 17 May 2023 02:12:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qj104tw04-3;
        Wed, 17 May 2023 02:12:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 0/7] lpfc: Update lpfc to revision 14.2.0.12
Date:   Tue, 16 May 2023 22:12:26 -0400
Message-Id: <168428950401.722180.7041861596217482884.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230417191558.83100-1-justintee8345@gmail.com>
References: <20230417191558.83100-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_14,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=394 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305170016
X-Proofpoint-GUID: 0Pcwu8VNbeah5150Z3eX9YQXDbpu1lHj
X-Proofpoint-ORIG-GUID: 0Pcwu8VNbeah5150Z3eX9YQXDbpu1lHj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 17 Apr 2023 12:15:51 -0700, Justin Tee wrote:

> Update lpfc to revision 14.2.0.12
> 
> This patch set contains fixes flagged by code analyzer tools, introduces a
> new CQE status to handle DMA errors, and replaces the usage of blk
> interrupts with threaded interrupts.
> 
> The patches were cut against Martin's 6.4/scsi-queue tree.
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/7] lpfc: Fix verbose logging for scsi commands issued to SES devices
      https://git.kernel.org/mkp/scsi/c/84c868a702f5
[2/7] lpfc: Fix double free in lpfc_cmpl_els_logo_acc caused by lpfc_nlp_not_used
      https://git.kernel.org/mkp/scsi/c/97f975823f81
[3/7] lpfc: Match lock ordering of lpfc_cmd->buf_lock and hbalock for abort paths
      https://git.kernel.org/mkp/scsi/c/78e9e35004fd
[4/7] lpfc: Update congestion warning notification period
      https://git.kernel.org/mkp/scsi/c/779d61dfb9ea
[5/7] lpfc: Add new RCQE status for handling DMA failures
      https://git.kernel.org/mkp/scsi/c/5fc849d8056d
[6/7] lpfc: Replace blk_irq_poll intr handler with threaded irq
      https://git.kernel.org/mkp/scsi/c/a7b94c159210
[7/7] lpfc: Update lpfc version to 14.2.0.12
      https://git.kernel.org/mkp/scsi/c/fd9ffa6c747f

-- 
Martin K. Petersen	Oracle Linux Engineering
