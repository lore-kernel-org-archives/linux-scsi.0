Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54613C61DA4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 03:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjCJDOg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 22:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjCJDOd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 22:14:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0D6EBDB0
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 19:14:32 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329Lx5ml004313;
        Fri, 10 Mar 2023 03:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=yqiYFjRERYYFirIfuVemNBKZzXIx2XEqCRU8faOtPug=;
 b=bjGgvq54m/BjytnSHopxENUsk/7Wla7tbWlFoLqq/uoXy+y0g7PFHWhzf0R+c2rzvdpv
 8RtMHgkJNMT/lohz5VspTnrljoUxaVQ/G/fyLnjyhDUZNeDWL9kRDWiTy28mRBSjgiou
 D9dxJdt6ChU2AsGtqg4pIkeE/VLkNfLxbg4qXIleteriagrykGpm4BL050cOx4ehYLsv
 9OpPurZXfV+vqx+QoguW4GlAFy+Q/AmKS0wvYv9CQ8YVwkcc9nBwOe18YWP+LpCmrIJ1
 gS+vBdM9wiQH7pCvGEr5GVDTAkVh/NB+qVxGepqAZZexegreLjJT5RNp/dPAO+qrMQO7 Ow== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn98nq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 03:14:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32A1DHZd026532;
        Fri, 10 Mar 2023 03:14:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g9w39k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 03:14:30 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32A3ETDG023573;
        Fri, 10 Mar 2023 03:14:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p6g9w39jg-2;
        Fri, 10 Mar 2023 03:14:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 00/10] lpfc: Update lpfc to revision 14.2.0.11
Date:   Thu,  9 Mar 2023 22:14:22 -0500
Message-Id: <167841804069.2362455.4903455011536753055.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230301231626.9621-1-justintee8345@gmail.com>
References: <20230301231626.9621-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_14,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=698
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100023
X-Proofpoint-GUID: TNAjJx6O4SWTWpp0w9bo-MwtTxeEil7L
X-Proofpoint-ORIG-GUID: TNAjJx6O4SWTWpp0w9bo-MwtTxeEil7L
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 01 Mar 2023 15:16:16 -0800, Justin Tee wrote:

> Update lpfc to revision 14.2.0.11
> 
> This patch set contains bug fixes for buffer overflow, resource management,
> discovery, and HBA error status handling.
> 
> The patches were cut against Martin's 6.3/scsi-queue tree.
> 
> [...]

Applied to 6.4/scsi-queue, thanks!

[01/10] lpfc: Protect against potential lpfc_debugfs_lockstat_write buffer overflow
        https://git.kernel.org/mkp/scsi/c/c6087b82a914
[02/10] lpfc: Reorder freeing of various dma buffers and their list removal
        https://git.kernel.org/mkp/scsi/c/bf21c9bb624c
[03/10] lpfc: Fix lockdep warning for rx_monitor lock when unloading driver
        https://git.kernel.org/mkp/scsi/c/c0d6071aa26f
[04/10] lpfc: Record LOGO state with discovery engine even if aborted
        https://git.kernel.org/mkp/scsi/c/06578ac65e2a
[05/10] lpfc: Defer issuing new PLOGI if received RSCN before completing REG_LOGIN
        https://git.kernel.org/mkp/scsi/c/1d0f9fea5d7f
[06/10] lpfc: Correct used_rpi count when devloss tmo fires with no recovery
        https://git.kernel.org/mkp/scsi/c/db651ec22524
[07/10] lpfc: Skip waiting for register ready bits when in unrecoverable state
        https://git.kernel.org/mkp/scsi/c/27c2bcf00ade
[08/10] lpfc: Revise lpfc_error_lost_link reason code evaluation logic
        https://git.kernel.org/mkp/scsi/c/796876fdaefe
[09/10] lpfc: Update lpfc version to 14.2.0.11
        https://git.kernel.org/mkp/scsi/c/13b149bbcf73
[10/10] lpfc: Copyright updates for 14.2.0.11 patches
        https://git.kernel.org/mkp/scsi/c/22871fe3b682

-- 
Martin K. Petersen	Oracle Linux Engineering
