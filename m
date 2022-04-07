Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432C0C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343731AbiDGNiF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343697AbiDGNhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF778267A
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:28 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237BEAHX004957
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=wLSDqSM9F3JJ2Fxa7DkHdYfjZXUYELIysc1sRClSD+c=;
 b=w2FtjN9ROR6cNbkeiBib6tfVaaaMUvaIyFuLX2U5/s+SCBEE+XLWR4Uy/8gPFph8LxNJ
 4zD86afVABGUnHoWKBVyv60z38wvoDqYh7+VlZTM5Hconb7z123pnvsAeY8Y7JK11o7A
 731x8jwka3n5vvy1TIDDKQ7/miuLAn1i4gLotAIED1gzVV6C3tMOKK4jmUx/HsWZFnB2
 fcpXjRFQBenbOyzH9Ki47B7WElyNVi81ppiVrOuLpCYoGCxFXpFUXrcazC/9Mug5Htx2
 P4HEuhfno+zyDtZRlg9lK9M+hoS64jHlxXNNzz+a+3ezN4pHtambBjxWDA/NiowWdCJ8 VA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d933yne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLW6A036951
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:27 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJM0032479
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:26 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-10;
        Thu, 07 Apr 2022 13:35:26 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] lpfc: Update lpfc to revision 14.2.0.1
Date:   Thu,  7 Apr 2022 09:35:09 -0400
Message-Id: <164929678998.15424.8259497448274956941.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220317032737.45308-1-jsmart2021@gmail.com>
References: <20220317032737.45308-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: deITYobC2m7fGvbPlCHROOGcZziZaCdV
X-Proofpoint-GUID: deITYobC2m7fGvbPlCHROOGcZziZaCdV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 16 Mar 2022 20:27:33 -0700, James Smart wrote:

> Update lpfc to revision 14.2.0.1
> 
> This patch set contains 3 fixes for errors detected during eeh error
> injection.
> 
> The patches were cut against Martin's 5.18/scsi-staging tree
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/4] lpfc: Improve PCI EEH Error and Recovery Handling
      https://git.kernel.org/mkp/scsi/c/35ed9613d83f
[2/4] lpfc: Fix unload hang after back to back PCI EEH faults
      https://git.kernel.org/mkp/scsi/c/a4691038b407
[3/4] lpfc: Fix queue failures when recovering from PCI parity error
      https://git.kernel.org/mkp/scsi/c/df0101197c4d
[4/4] lpfc: Update lpfc version to 14.2.0.1
      https://git.kernel.org/mkp/scsi/c/4f3beb36b1e4

-- 
Martin K. Petersen	Oracle Linux Engineering
