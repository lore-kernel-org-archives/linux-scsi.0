Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FEAC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 04:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbiGNEWz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 00:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbiGNEWk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 00:22:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80328275FD
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 21:22:38 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E3n5Vg031530;
        Thu, 14 Jul 2022 04:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=en7xGQFGZFBLRrObXmfeAilau5eu9OlXwjXYlZTAMuU=;
 b=XO2wZHvHt0RwHnjvv774s81LJVBgvWbf8yYmJvTROS7Jqabf2mpjI1zFixQph4sQ3h9F
 QNKI6wrRlJOJB1elIhDaZpm4Uy1T4QZh3b2wPemt6Jy3LyJiLUhdT7sggFhq96nHZcE4
 6TuZSsv+xhMgkCoBwgyvwAQlXplxzthgb01z4Y5YFm3kshsqC9lv9z8JTSLeZQ2xdTFP
 MMmefSUPJcbGrWN8DxjuCKdBQdzqTXdxW/ErUHL22nudpIvtY6HfEzrlPGbj2RAC8KfB
 FbodlrP6EGXcotGyO97wRlLqA5skppCcHPFNuid3rUA3D+3+Gm5Z55qlmI3F4EraR26l xA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71r1bje9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E4AeWf039877;
        Thu, 14 Jul 2022 04:22:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:36 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 26E4MWBp023864;
        Thu, 14 Jul 2022 04:22:35 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jnc-6;
        Thu, 14 Jul 2022 04:22:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/12] lpfc: Update lpfc to revision 14.2.0.5
Date:   Thu, 14 Jul 2022 00:22:26 -0400
Message-Id: <165777182484.7272.889834319069530462.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220701211425.2708-1-jsmart2021@gmail.com>
References: <20220701211425.2708-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: S9EBn__kif3RsAcGeVaWxN9Eoax77iuN
X-Proofpoint-GUID: S9EBn__kif3RsAcGeVaWxN9Eoax77iuN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 1 Jul 2022 14:14:13 -0700, James Smart wrote:

> Update lpfc to revision 14.2.0.5
> 
> This patch set contains mainly fixes.
> 
> The patches were cut against Martin's 5.20/scsi-queue tree with patches
> for 14.2.0.4 (9 patches in 5.19/scsi-fixes) applied prior.
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[01/12] lpfc: Fix uninitialized cqe field in lpfc_nvme_cancel_iocb
        https://git.kernel.org/mkp/scsi/c/4ecc9b0271a7
[02/12] lpfc: Prevent buffer overflow crashes in debugfs with malformed user input
        https://git.kernel.org/mkp/scsi/c/f8191d40aa61
[03/12] lpfc: Set PU field when providing D_ID in XMIT_ELS_RSP64_CX iocb
        https://git.kernel.org/mkp/scsi/c/35251b4d79db
[04/12] lpfc: Remove extra atomic_inc on cmd_pending in queuecommand after VMID
        https://git.kernel.org/mkp/scsi/c/0948a9c53860
[05/12] lpfc: Fix possible memory leak when failing to issue CMF WQE
        https://git.kernel.org/mkp/scsi/c/2f67dc7970bc
[06/12] lpfc: Fix attempted FA-PWWN usage after feature disable
        https://git.kernel.org/mkp/scsi/c/43e19a96a789
[07/12] lpfc: Fix lost NVME paths during LIF bounce stress test
        https://git.kernel.org/mkp/scsi/c/ea92e173dc55
[08/12] lpfc: Revert RSCN_MEMENTO workaround for misbehaved configuration
        https://git.kernel.org/mkp/scsi/c/ffc566411ade
[09/12] lpfc: Refactor lpfc_nvmet_prep_abort_wqe into lpfc_sli_prep_abort_xri
        https://git.kernel.org/mkp/scsi/c/b21c9deb1479
[10/12] lpfc: Remove Menlo/Hornet related code
        https://git.kernel.org/mkp/scsi/c/7f86d2b84708
[11/12] lpfc: Update lpfc version to 14.2.0.5
        https://git.kernel.org/mkp/scsi/c/71faf8d30fdb
[12/12] lpfc: Copyright updates for 14.2.0.5 patches
        https://git.kernel.org/mkp/scsi/c/b3d11f195cbb

-- 
Martin K. Petersen	Oracle Linux Engineering
