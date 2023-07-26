Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F674C001DE
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 02:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjGZCFR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 22:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjGZCFP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 22:05:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48C12109
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 19:05:14 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PJIZZi020279;
        Wed, 26 Jul 2023 02:05:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=C/jRme2MOEGAjnnJat2Ircr7WaOS+t0kF4+33C/CzzQ=;
 b=Rcc/7JIudMny3bAxfKmF/Yf6ONF96gtiePURlsOolJhDvanbVtfDq1xBsstQZiMf8VyM
 4gL/a6AjS9EbWTpU5AS845laAE18ki2uldcuHsAwY+mdd0yIzaRL0tAyNG+sMPQ4r61k
 1qQdphioansHf3bZK9DCkBLawwLvF03eXnhzb8D1jLlSoLX9x+vh/olV5VWqd7hlVr+B
 qnVkxuXTLl3dnjzAllZ4BmuN1/dv+pI3EcC8k9eLnaaiTGqAsnFBgrAJ5+HxMks3IauD
 30/KykZlhxtYnACwWLL5f6AAxOlsVbXlg6ugcKVRjJnieU38FMb6BJ23cJRklHAtJ7Tt 8Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05hdxdnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PNhxif022977;
        Wed, 26 Jul 2023 02:05:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j5jd1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:10 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36Q253NZ038905;
        Wed, 26 Jul 2023 02:05:10 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s05j5jcwf-5;
        Wed, 26 Jul 2023 02:05:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 00/12] lpfc: Update lpfc to revision 14.2.0.14
Date:   Tue, 25 Jul 2023 22:04:50 -0400
Message-Id: <169033702312.2256288.11963583438511315018.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230712180522.112722-1-justintee8345@gmail.com>
References: <20230712180522.112722-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_14,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=634
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260016
X-Proofpoint-ORIG-GUID: MJWomJaVhctUkHYSoTC_yPpxEGjSjfty
X-Proofpoint-GUID: MJWomJaVhctUkHYSoTC_yPpxEGjSjfty
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 12 Jul 2023 11:05:10 -0700, Justin Tee wrote:

> Update lpfc to revision 14.2.0.14
> 
> This patch set contains logging improvements, kref handling fixes,
> discovery bug fixes, and refactoring of repeated code.
> 
> The patches were cut against Martin's 6.6/scsi-queue tree.
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[01/12] lpfc: Pull out fw diagnostic dump log message from driver's trace buffer
        https://git.kernel.org/mkp/scsi/c/4cf7cfa8bae1
[02/12] lpfc: Simplify fcp_abort transport callback log message
        https://git.kernel.org/mkp/scsi/c/1a5cd3d073ee
[03/12] lpfc: Remove extra ndlp kref decrement in FLOGI cmpl for loop topology
        https://git.kernel.org/mkp/scsi/c/869ab8b8a31c
[04/12] lpfc: Qualify ndlp discovery state when processing RSCN
        https://git.kernel.org/mkp/scsi/c/377d7abadd74
[05/12] lpfc: Revise ndlp kref handling for dev_loss_tmo_callbk and lpfc_drop_node
        https://git.kernel.org/mkp/scsi/c/90cec07f53e9
[06/12] lpfc: Set Establish Image Pair service parameter only for Target Functions
        https://git.kernel.org/mkp/scsi/c/04c320011492
[07/12] lpfc: Make fabric zone discovery more robust when handling unsolicited LOGO
        https://git.kernel.org/mkp/scsi/c/9388da303766
[08/12] lpfc: Abort outstanding ELS cmds when mailbox timeout error is detected
        https://git.kernel.org/mkp/scsi/c/089ea22e374a
[09/12] lpfc: Refactor cpu affinity assignment paths
        https://git.kernel.org/mkp/scsi/c/d668b368efc2
[10/12] lpfc: Clean up SLI-4 sysfs resource reporting
        https://git.kernel.org/mkp/scsi/c/81907422cac0
[11/12] lpfc: Update lpfc version to 14.2.0.14
        https://git.kernel.org/mkp/scsi/c/cfb9b8f506d5
[12/12] lpfc: Copyright updates for 14.2.0.14 patches
        https://git.kernel.org/mkp/scsi/c/71fe5ddac546

-- 
Martin K. Petersen	Oracle Linux Engineering
