Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B363C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 05:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbiFHFhx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 01:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbiFHFhn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 01:37:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA438169DFF
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 20:04:46 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257Na3Uw014272;
        Wed, 8 Jun 2022 02:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=2dhzMdOl9wyyTGOmmbgO0+0AuirYhxVpvoPLjPDFOkk=;
 b=0atDqKaP0ISaWN/2vrXVNM2L4O4MZwnVWPFeX8LYVh9RuTRte4GtiCFdc9CCDzy/0N8r
 zWG3hj6qsIx6UDSmNjmoiXx/Cy4eWOJhUWRtxIZoczz40wEeKILEayQ/9TJmR57L3STV
 PqnLDfiGT7QlNw1KzH72UVe1uu2cQ60F3EilN/7lKQhUBjd/2TAgzrale2EeKE1GrvS8
 w6wFsYliQmoBlCcSpLCsT/l+coqq8Y/nzIP8yAjAwzFzxDQPOWkYUcZYRwZfuxBeY/4t
 ayLBqocBshNxRWvEmg/U1teqFTZNXS+OHKyy6P1kX+tT7s1oNUOpjkHZCHthfVtfSmgo Kw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ggvxmwff9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 02:28:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2582ASHt037889;
        Wed, 8 Jun 2022 02:28:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu3349y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 02:28:02 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2582RxlT032073;
        Wed, 8 Jun 2022 02:28:01 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu33499-3;
        Wed, 08 Jun 2022 02:28:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/9] lpfc: Update lpfc to revision 14.2.0.4
Date:   Tue,  7 Jun 2022 22:27:55 -0400
Message-Id: <165465514542.8982.8078251769362214979.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220603174329.63777-1-jsmart2021@gmail.com>
References: <20220603174329.63777-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 0HAFNHlLCDE1Wnw6Mub7LaYPFPD9BODA
X-Proofpoint-ORIG-GUID: 0HAFNHlLCDE1Wnw6Mub7LaYPFPD9BODA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 3 Jun 2022 10:43:20 -0700, James Smart wrote:

> Update lpfc to revision 14.2.0.4
> 
> This patch set contains mainly fixes. Also adds some additional logging
> for NVMe command completions when errors, and enabling of nvme-fc flush
> handling on async event cmds.
> 
> The patches were cut against Martin's 5.19/scsi-queue tree
> 
> [...]

Applied to 5.19/scsi-fixes, thanks!

[1/9] lpfc: Correct BDE type for XMIT_SEQ64_WQE in ct_reject_event
      https://git.kernel.org/mkp/scsi/c/44ba9786b673
[2/9] lpfc: Resolve some cleanup issues following abort path refactoring
      https://git.kernel.org/mkp/scsi/c/24e1f056677e
[3/9] lpfc: Resolve some cleanup issues following SLI path refactoring
      https://git.kernel.org/mkp/scsi/c/e27f05147bff
[4/9] lpfc: Address null pointer dereference after starget_to_rport()
      https://git.kernel.org/mkp/scsi/c/6f808bd78e82
[5/9] lpfc: Resolve null ptr dereference after an ELS LOGO is aborted
      https://git.kernel.org/mkp/scsi/c/b1b3440f437b
[6/9] lpfc: Fix port stuck in bypassed state after lip in PT2PT topology
      https://git.kernel.org/mkp/scsi/c/336d63615466
[7/9] lpfc: Add more logging of cmd and cqe information for aborted NVME cmds
      https://git.kernel.org/mkp/scsi/c/ea7bd1f39331
[8/9] lpfc: Allow reduced polling rate for nvme_admin_async_event cmd completion
      https://git.kernel.org/mkp/scsi/c/2e7e9c0c1ec0
[9/9] lpfc: Update lpfc version to 14.2.0.4
      https://git.kernel.org/mkp/scsi/c/1af48fffd7ff

-- 
Martin K. Petersen	Oracle Linux Engineering
