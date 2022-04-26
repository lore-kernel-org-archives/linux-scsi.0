Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BE3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 04:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243643AbiDZEED (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 00:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243647AbiDZED4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 00:03:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2773112741
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 21:00:48 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PLWaoV031587;
        Tue, 26 Apr 2022 04:00:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=KYZV5oYNzMZxfD8wmL6euL7f6csCR+sD57V0J52cMcw=;
 b=H9Jd6CTxBrg2RHpW2cC4+HQBwJ2JD8HkStA90b68TSMgFyMhfah5goGO+a9T6eL3vmup
 BfwGvxJOsuCyN/8RNYPeHkK6q2R89QWNAjpT8axMwJlPkfS8ew5TStVngTR471K26U7V
 IHQmk/p1qWWRy91/rdZzo9r2MidMm+vBXuYzHhqBvFteLblaE3v0AdUsrq28HSREABaF
 5WkIOpSejBvoH9e8xz9IWKX6rGJLqjfWrl5km5fT7mnGLk+i9HnaoBXsbTkksfxDRABR
 Hw78zqibJfBY8EH4WwqdIht5qXT9gO8gpMMQj0Qua08VtNx0jhhYd6UM0DKN2a/R6ZkN Gw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb5jvyv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 04:00:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23Q40Rpe029570;
        Tue, 26 Apr 2022 04:00:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yj3v1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 04:00:47 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 23Q40juT030030;
        Tue, 26 Apr 2022 04:00:46 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yj3v10-3;
        Tue, 26 Apr 2022 04:00:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/26] lpfc: Update lpfc to revision 14.2.0.2
Date:   Tue, 26 Apr 2022 00:00:42 -0400
Message-Id: <165094528687.21993.15421363661681698559.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 5O_XEwOY4xTBN-GBjkeerJiVsmraxLZH
X-Proofpoint-ORIG-GUID: 5O_XEwOY4xTBN-GBjkeerJiVsmraxLZH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Apr 2022 15:19:42 -0700, James Smart wrote:

> Update lpfc to revision 14.2.0.2
> 
> This patch set a bunch of small fixes, several discovery fixes,
> a few logging enhancements, and a rework patch to get rid of
> overloaded structure fields.
> 
> The patches were cut against Martin's 5.18/scsi-queue tree
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[01/26] lpfc: Tweak message log categories for ELS/FDMI/NVME Rescan
        https://git.kernel.org/mkp/scsi/c/b83a8c21f3fe
[02/26] lpfc: Move cfg_log_verbose check before calling lpfc_dmp_dbg
        https://git.kernel.org/mkp/scsi/c/e294647b1aed
[03/26] lpfc: Fix diagnostic fw logging after a function reset
        https://git.kernel.org/mkp/scsi/c/a6de9a2fa0d6
[04/26] lpfc: Zero SLI4 fcp_cmnd buffer's fcpCntl0 field
        https://git.kernel.org/mkp/scsi/c/787d0580ca18
[05/26] lpfc: Requeue SCSI I/O to upper layer when fw reports link down
        https://git.kernel.org/mkp/scsi/c/b6474465e962
[06/26] lpfc: Fix SCSI I/O completion and abort handler deadlock
        https://git.kernel.org/mkp/scsi/c/03cbbd7c2f5e
[07/26] lpfc: Clear fabric topology flag before initiating a new FLOGI
        https://git.kernel.org/mkp/scsi/c/3483a44bdfb4
[08/26] lpfc: Fix null pointer dereference after failing to issue FLOGI and PLOGI
        https://git.kernel.org/mkp/scsi/c/577a942df3de
[09/26] lpfc: Protect memory leak for NPIV ports sending PLOGI_RJT
        https://git.kernel.org/mkp/scsi/c/672d1cb40551
[10/26] lpfc: Update fc_prli_sent outstanding only after guaranteed IOCB submit
        https://git.kernel.org/mkp/scsi/c/31e887864eb2
[11/26] lpfc: Transition to NPR state upon LOGO cmpl if link down or aborted
        https://git.kernel.org/mkp/scsi/c/76395c88d0af
[12/26] lpfc: Remove unnecessary NULL pointer assignment for ELS_RDF path
        https://git.kernel.org/mkp/scsi/c/d531d9874da8
[13/26] lpfc: Move MI module parameter check to handle dynamic disable
        https://git.kernel.org/mkp/scsi/c/39a1a86b9da2
[14/26] lpfc: Correct CRC32 calculation for congestion stats
        https://git.kernel.org/mkp/scsi/c/5295d19d4f97
[15/26] lpfc: Fix call trace observed during I/O with CMF enabled
        https://git.kernel.org/mkp/scsi/c/d6d45f67a111
[16/26] lpfc: Revise FDMI reporting of supported port speed for trunk groups
        https://git.kernel.org/mkp/scsi/c/c364c453d30a
[17/26] lpfc: Remove false FDMI NVME FC-4 support for NPIV ports
        https://git.kernel.org/mkp/scsi/c/6c8a3ce64b2c
[18/26] lpfc: Register for Application Services FC-4 type in Fabric topology
        https://git.kernel.org/mkp/scsi/c/6c983d327b9e
[19/26] lpfc: Introduce FC_RSCN_MEMENTO flag for tracking post RSCN completion
        https://git.kernel.org/mkp/scsi/c/1045592fc968
[20/26] lpfc: Fix field overload in lpfc_iocbq data structure
        https://git.kernel.org/mkp/scsi/c/d51cf5bd926c
[21/26] lpfc: Refactor cleanup of mailbox commands
        https://git.kernel.org/mkp/scsi/c/ef47575fd982
[22/26] lpfc: Change FA-PWWN detection methodology
        https://git.kernel.org/mkp/scsi/c/1b6f71f7fcb6
[23/26] lpfc: Update stat accounting for READ_STATUS mbox command
        https://git.kernel.org/mkp/scsi/c/f4fbf4acaa50
[24/26] lpfc: Expand setting ELS_ID field in ELS_REQUEST64_WQE
        https://git.kernel.org/mkp/scsi/c/fd4a0c6da5c1
[25/26] lpfc: Update lpfc version to 14.2.0.2
        https://git.kernel.org/mkp/scsi/c/4af4d0e2ea94
[26/26] lpfc: Copyright updates for 14.2.0.2 patches
        https://git.kernel.org/mkp/scsi/c/66c20a97367a

-- 
Martin K. Petersen	Oracle Linux Engineering
