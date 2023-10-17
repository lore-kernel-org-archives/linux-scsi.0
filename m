Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449D9CDB465
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 01:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbjJQBML (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 21:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbjJQBMK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 21:12:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EFF9B
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 18:12:09 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GKO4Cn011132;
        Tue, 17 Oct 2023 01:12:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=uKN96ExXynINecz3aeCXS1peUJ9uYglROwv/2kz9+Zg=;
 b=iJ+fxiviIvV4OZrhfCtplmohlpnzIxuPY5iFpngM3GueffZB6q5v91aMBaf7ofT2fO3T
 6OvFBpmQ+zdM4nCoVC/qGgaNdGHmp3Lqoug/E2SRq2JRsYEjKsGjpnNvJt2/Usi61lZX
 bD5cY+fhxXGehxE1v70wzAZhXEnXTzqx/8JgXxjz3TYc/4kvhLYXPMX214FgSR8bVJdC
 aQ73ol4QFpoUr8DZVpRbd+VtHC/JksK0ad9PAqtxTmNboDFLSpFmq+MZTh9sSBZ7fEnA
 BbQf79QYtj2nlwtFmj96Asbl0/rgyCdPOHViFuJc3g7UQamVViF2EzIJ8YQv47ca+j6z LQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjync0v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:07 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GMYNDG027092;
        Tue, 17 Oct 2023 01:12:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg5366pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:06 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39H1C3sm039761;
        Tue, 17 Oct 2023 01:12:06 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3trg5366mf-4;
        Tue, 17 Oct 2023 01:12:06 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 0/6] lpfc: Update lpfc to revision 14.2.0.15
Date:   Mon, 16 Oct 2023 21:11:51 -0400
Message-Id: <169750286929.2183937.12992417801253060653.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231009161812.97232-1-justintee8345@gmail.com>
References: <20231009161812.97232-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=785 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170008
X-Proofpoint-GUID: IaeM1NiOYNLY21ppitGocu0G_4J9rFYD
X-Proofpoint-ORIG-GUID: IaeM1NiOYNLY21ppitGocu0G_4J9rFYD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 09 Oct 2023 09:18:06 -0700, Justin Tee wrote:

> Update lpfc to revision 14.2.0.15
> 
> This patch set contains error handling fixes, ELS bug fixes, and logging
> improvements.
> 
> The patches were cut against Martin's 6.7/scsi-queue tree.
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[1/6] lpfc: Remove unnecessary zero return code assignment in lpfc_sli4_hba_setup
      https://git.kernel.org/mkp/scsi/c/0506814609fb
[2/6] lpfc: Treat IOERR_SLI_DOWN I/O completion status the same as pci offline
      https://git.kernel.org/mkp/scsi/c/d472a76603d8
[3/6] lpfc: Reject received PRLIs with only initiator fcn role for NPIV ports
      https://git.kernel.org/mkp/scsi/c/12e896c74280
[4/6] lpfc: Validate ELS LS_ACC completion payload
      https://git.kernel.org/mkp/scsi/c/a3c3c0a806f1
[5/6] lpfc: Introduce LOG_NODE_VERBOSE messaging flag
      https://git.kernel.org/mkp/scsi/c/41c831bbb0f2
[6/6] lpfc: Update lpfc version to 14.2.0.15
      https://git.kernel.org/mkp/scsi/c/8a9a690b5ad5

-- 
Martin K. Petersen	Oracle Linux Engineering
