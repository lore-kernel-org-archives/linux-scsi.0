Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C8ABC7EE23
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 01:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbjFHBnL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 21:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbjFHBmy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 21:42:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A56271B
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 18:42:45 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357N5k8Q017987;
        Thu, 8 Jun 2023 01:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=32tnZ3/OUw7brzTd6vSJp+kivr1yqZ1YRRYGri9Hwg4=;
 b=p4BQqnJwrLDGS8R4wJFEN+EuzqKJk5UeJSwKEhd6TDXkMOCPrdwKbEL2uCYLbvMsNT7t
 8PFuxlZXD8xilV3S/JXXywuNmNaqeVusxwxou3RHFrKW4iywO4Row+G1ymVIEsojPPh9
 iR16L6gPDZf77Jw35MaBkjCuKwYRJHqSRbEbPe61LZM9ioUS2DkUQsxgPcf4HCDVMO83
 BY3qxKwy/0gft/k7/m/fMwispnJiCahYkg/bChIgowOr2dQs+G84Wjj9RUtgZdIHZtjK
 42vk+wyOU9yL8ZxI2PrDaOr8q81eimzcFDKYOrHvH8znD/XMuwjArbTX+EVxMA9A7ILh WQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6ub3he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:42:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 357Nme8T036556;
        Thu, 8 Jun 2023 01:42:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6hyt9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:42:42 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3581gQV3031871;
        Thu, 8 Jun 2023 01:42:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3r2a6hyt3a-13;
        Thu, 08 Jun 2023 01:42:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 0/9] lpfc: Update lpfc to revision 14.2.0.13
Date:   Wed,  7 Jun 2023 21:42:17 -0400
Message-Id: <168618844274.2636448.787259883923516405.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230523183206.7728-1-justintee8345@gmail.com>
References: <20230523183206.7728-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_13,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=777 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306080011
X-Proofpoint-GUID: BZv23gRP1FIO0VRXKKn_3GvK0ivO26S2
X-Proofpoint-ORIG-GUID: BZv23gRP1FIO0VRXKKn_3GvK0ivO26S2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 23 May 2023 11:31:57 -0700, Justin Tee wrote:

> Update lpfc to revision 14.2.0.13
> 
> This patch set contains discovery bug fixes, firmware logging improvements,
> clean up of CQ handling, and statistics collection enhancements.
> 
> The patches were cut against Martin's 6.5/scsi-queue tree.
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/9] lpfc: Fix use-after-free rport memory access in lpfc_register_remote_port
      https://git.kernel.org/mkp/scsi/c/a4157aaf0fb4
[2/9] lpfc: Clear NLP_IN_DEV_LOSS flag if already in rediscovery
      https://git.kernel.org/mkp/scsi/c/fd57a687d441
[3/9] lpfc: Account for fabric domain ctlr device loss recovery
      https://git.kernel.org/mkp/scsi/c/73ded37869f8
[4/9] lpfc: Revise NPIV ELS unsol rcv cmpl logic to drop ndlp based on nlp_state
      https://git.kernel.org/mkp/scsi/c/9914a3d033d3
[5/9] lpfc: Change firmware upgrade logging to KERN_NOTICE instead of TRACE_EVENT
      https://git.kernel.org/mkp/scsi/c/b9951e1cffae
[6/9] lpfc: Clean up SLI-4 CQE status handling
      https://git.kernel.org/mkp/scsi/c/6a84d015082e
[7/9] lpfc: Enhance congestion statistics collection
      https://git.kernel.org/mkp/scsi/c/93190ac1d4e7
[8/9] lpfc: Update lpfc version to 14.2.0.13
      https://git.kernel.org/mkp/scsi/c/48abf8b4b563
[9/9] lpfc: Copyright updates for 14.2.0.13 patches
      https://git.kernel.org/mkp/scsi/c/b93f9eb8f4cd

-- 
Martin K. Petersen	Oracle Linux Engineering
