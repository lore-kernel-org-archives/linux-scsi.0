Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A20EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 02:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiEQCQt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 22:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiEQCQs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 22:16:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050383B3D8
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2022 19:16:46 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GKoldm019534;
        Tue, 17 May 2022 02:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=qaeQZo5pTR+hO24S2MaIdPglcMq7Wnms+CjSI7Ct4D8=;
 b=zj/sM8wp5u9KrZAsVl7f38Crnq5uY9JlYWcc2maMs5PLg970DIgUiBiIB8CT++GDkknY
 7bsV7qcjG/e3uNa/cn24GBxkVoMfHQO69oe7GKqa+CoMKVvh+z5gyEkirzBbBUzThA33
 zowT1IuNzQsKrpZHsazAmzZ+FR2tGs4eFDvX9PsRIjijGTXRLHyD0hDuYLc5/Lx9unVT
 CRNZ8v6NO2vh9sHangKEImdJ0pMAKxMgcRGkTAovA97jQ/GBuJhc6yOj4G0Yw1s/q6+8
 9FONArDbJbzQdNG6Ejv4qnJaAxrMDhQzI15XZwbP3MzvQ69Zlc/sJnOquPLIBDnEoGAs ZQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241s4vwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 02:16:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24H2G8tp019199;
        Tue, 17 May 2022 02:16:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v83hm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 02:16:44 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24H2Ghvx019875;
        Tue, 17 May 2022 02:16:44 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v83hkf-3;
        Tue, 17 May 2022 02:16:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/12] lpfc: Update lpfc to revision 14.2.0.3
Date:   Mon, 16 May 2022 22:16:38 -0400
Message-Id: <165275376860.24722.13593341101681998909.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220506035519.50908-1-jsmart2021@gmail.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: LEVGNixuzMY_mBBAj-_5q88PkjFyFvyL
X-Proofpoint-ORIG-GUID: LEVGNixuzMY_mBBAj-_5q88PkjFyFvyL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 5 May 2022 20:55:07 -0700, James Smart wrote:

> Update lpfc to revision 14.2.0.3
> 
> This patch set contains fixes in several different areas including
> ref counting areas, oops, I/O length failures, etc.
> 
> The patches were cut against Martin's 5.19/scsi-queue tree
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[01/12] lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()
        https://git.kernel.org/mkp/scsi/c/84c6f99e3907
[02/12] lpfc: Fill in missing ndlp kref puts in error paths
        https://git.kernel.org/mkp/scsi/c/ba3d58a1df46
[03/12] lpfc: Fix ndlp put following a LOGO completion
        https://git.kernel.org/mkp/scsi/c/b7e952cbc63c
[04/12] lpfc: Inhibit aborts if external loopback plug is inserted
        https://git.kernel.org/mkp/scsi/c/ead76d4c09b8
[05/12] lpfc: Fix dmabuf ptr assignment in lpfc_ct_reject_event
        https://git.kernel.org/mkp/scsi/c/596fc8adb171
[06/12] lpfc: Use list_for_each_entry_safe on fc_nodes list in rscn_recovery_check
        https://git.kernel.org/mkp/scsi/c/4a0f4aff3ce5
[07/12] lpfc: Decrement outstanding gidft_inp counter if lpfc_err_lost_link
        https://git.kernel.org/mkp/scsi/c/dc8a71bd414f
[08/12] lpfc: Change VMID registration to be based on fabric parameters
        https://git.kernel.org/mkp/scsi/c/5099478e436f
[09/12] lpfc: Rework FDMI initialization after link up
        https://git.kernel.org/mkp/scsi/c/de3ec318fee3
[10/12] lpfc: Alter FPIN stat accounting logic
        https://git.kernel.org/mkp/scsi/c/e6f510414502
[11/12] lpfc: Use sg_dma_address and sg_dma_len macros for NVMe I/O
        https://git.kernel.org/mkp/scsi/c/a14396b6d139
[12/12] lpfc: Update lpfc version to 14.2.0.3
        https://git.kernel.org/mkp/scsi/c/fcb9e738667c

-- 
Martin K. Petersen	Oracle Linux Engineering
