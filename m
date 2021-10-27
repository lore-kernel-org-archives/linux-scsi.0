Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDEAC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 04:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8DFC61073
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 04:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhJ0ECy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 00:02:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61950 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229441AbhJ0ECx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 00:02:53 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R0mpLp014956;
        Wed, 27 Oct 2021 04:00:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=S+iUQkqK8y5W3fP2e670HdQJxnqDIpoakO/WPxLlFEE=;
 b=Pua1RbAUma3XxVq0+hwqe1hvmwJzIWGp8y4F0mTfxFtxDXAzQ6GbtaT8xoBe00TRQ+VN
 uMw3k6oSfuRewffMvW0aR74ptDvC6eZkcI9HBGdHEEPhA7D9UYpMqB1CmLkZeoKsd7tm
 5OqpFXbGJea/wuuyRY7/T9moc5AHUE8D70COLaS2Wo56S55SP3Pb9GsY89Yu4GfgAtc+
 jv0BLglB2B6xPrjRha3lazZw0SGs+Wz+Imu113zSHT8JEEzcl3BaVj9RS+5Ac+AWCkWi
 Xw1iTxdIZGABSIWMMTkj4DCrehhbFaGUbnAwSe6oD19/XKxce2dCoApk/ouLVD0DipJD zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fj0g92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 04:00:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19R3xw5h068729;
        Wed, 27 Oct 2021 04:00:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3bx4gqcnac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 04:00:26 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19R40O5G070915;
        Wed, 27 Oct 2021 04:00:26 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3bx4gqcn88-3;
        Wed, 27 Oct 2021 04:00:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/8] lpfc: Update lpfc to revision 14.0.0.3
Date:   Wed, 27 Oct 2021 00:00:21 -0400
Message-Id: <163530706458.10775.13953794183234723341.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211020211417.88754-1-jsmart2021@gmail.com>
References: <20211020211417.88754-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: TcY0cXlXb553E77g_ooGk6vs2ow1FMhN
X-Proofpoint-ORIG-GUID: TcY0cXlXb553E77g_ooGk6vs2ow1FMhN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 20 Oct 2021 14:14:09 -0700, James Smart wrote:

> Update lpfc to revision 14.0.0.3
> 
> This patch set contains several bug fixes.
> 
> The patches were cut against Martin's 5.16/scsi-queue tree
> 
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/8] lpfc: Revert LOG_TRACE_EVENT back to LOG_INIT prior to driver_resource_setup
      https://git.kernel.org/mkp/scsi/c/a516074c2026
[2/8] lpfc: Wait for successful restart of SLI3 adapter during host sg_reset
      https://git.kernel.org/mkp/scsi/c/d305c253af69
[3/8] lpfc: Correct sysfs reporting of loop support after SFP status change
      https://git.kernel.org/mkp/scsi/c/7a1dda943630
[4/8] lpfc: Fix use-after-free in lpfc_unreg_rpi() routine
      https://git.kernel.org/mkp/scsi/c/79b20beccea3
[5/8] lpfc: Allow PLOGI retry if previous PLOGI was aborted
      https://git.kernel.org/mkp/scsi/c/15af02d8a585
[6/8] lpfc: Fix link down processing to address NULL pointer dereference
      https://git.kernel.org/mkp/scsi/c/1854f53ccd88
[7/8] lpfc: Allow fabric node recovery if recovery is in progress before devloss
      https://git.kernel.org/mkp/scsi/c/af984c87293b
[8/8] lpfc: Update lpfc version to 14.0.0.3
      https://git.kernel.org/mkp/scsi/c/83c3a7beaef7

-- 
Martin K. Petersen	Oracle Linux Engineering
