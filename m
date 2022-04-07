Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB3AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343678AbiDGNiK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343699AbiDGNhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE85C2644
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:30 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237BoiKn004892
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=+8HjjRfjx+eu4BHTLgLm6SuPvVt1Min+Pbz5F/ZGx3E=;
 b=G9oYYPEkN95VLn0WsZpeZ8gv70pTUWpTUw5N8GBbPVAnyUXL0lESCtl4/2DgzfAfP0ml
 w5z4thlGYAEdIrq39GR3Gpth+mT/UMmRkZW6EYz7XhgGwF5/RShcuPvqb/RwoMwNtxEM
 COTbEq2Wlih6e/FJ62W74ZZ0rX3BBT+fPAeHgEvBBBHqu1l4RkRdKBG4uWIDuyDodLNG
 RKuG3csMfkO5pxGkpFMf8oIAelKqnu952PNECm9Hi4pLyhOoGNN/+TyDNxFMXHr69ykq
 yHSwIFIxuZykdraaeVdn4f1sTD1Z1v+TerCK2pYqiT7G0W9hr1WR7SlvIHr3wdlCYn8t 6A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d933ynf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:29 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVn7036817
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:28 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJM4032479
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:27 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-12;
        Thu, 07 Apr 2022 13:35:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sr: fix typo in CDROM(CLOSETRAY|EJECT) handling
Date:   Thu,  7 Apr 2022 09:35:11 -0400
Message-Id: <164929678999.15424.847039795505032538.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220323002242.21157-1-kgroeneveld@lenbrook.com>
References: <20220323002242.21157-1-kgroeneveld@lenbrook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: f_XzLeBaOW75qfSGUZoK8LdkGpoa53-l
X-Proofpoint-GUID: f_XzLeBaOW75qfSGUZoK8LdkGpoa53-l
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Mar 2022 20:22:42 -0400, Kevin Groeneveld wrote:

> Commit 2e27f576abc6 ("scsi: scsi_ioctl: Call scsi_cmd_ioctl() from
> scsi_ioctl()") seems to have a typo as it is checking ret instead of
> cmd in the if statement checking for CDROMCLOSETRAY and CDROMEJECT.
> This changes the behaviour of these ioctls as the cdrom_ioctl
> handling of these is more restrictive than the scsi_ioctl version.
> 
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/1] scsi: sr: fix typo in CDROM(CLOSETRAY|EJECT) handling
      https://git.kernel.org/mkp/scsi/c/bc5519c18a32

-- 
Martin K. Petersen	Oracle Linux Engineering
