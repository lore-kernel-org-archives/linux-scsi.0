Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C8FC4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343694AbiDGNhp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343674AbiDGNhd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC191119
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:22 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237BuqvO000758
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=cO9r6gIu4fWMpbZbWDsuVpYoMFvD0hGBrgw05aQRVGY=;
 b=s2q3aqhkeOSh5MLCKcQrKMTiQZ1zHSvChq20zvGTK4S85YBudzQbupPR1wKjyBwSF1ht
 ypmcCwyctT7UoCd5+k8iL7zkU9pX0CrE4liJ4sAs/x8IWFtpxcpWjoGJbfG6G90U/HwL
 4D1jwd3Kiy9vBjGBJR93+LsykFbJLQAsOe0g2frIfZgrQNvUT9U3GIPJorD/2cf1z3+l
 w3i7qyMazR24dJsz0No8y9oFtUi7IQi6QeU7Qwc0g0ENphwegcTzyICNjn/KzbqRCIh3
 Djp4sJmN2OvCtkQrmKDGn88EN2oe0pT7hUDULy+NSiv+JJVMy7Zqm7HwHlFMPEDpvyEh yQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3suw22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:21 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVdm036886
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:20 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJLi032479
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:20 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-2;
        Thu, 07 Apr 2022 13:35:20 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: bnx2i: Fix spelling mistake "mis-match" -> "mismatch"
Date:   Thu,  7 Apr 2022 09:35:01 -0400
Message-Id: <164929679002.15424.4116730724375719073.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220319231445.21696-1-colin.i.king@gmail.com>
References: <20220319231445.21696-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: qKgv2ca3GuIaPpxEuHrzo44vY1UhQt_X
X-Proofpoint-GUID: qKgv2ca3GuIaPpxEuHrzo44vY1UhQt_X
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 19 Mar 2022 23:14:45 +0000, Colin Ian King wrote:

> There are a few spelling mistakes in some error messages. Fix them.
> 
> 

Applied to 5.18/scsi-fixes, thanks!

[1/1] scsi: bnx2i: Fix spelling mistake "mis-match" -> "mismatch"
      https://git.kernel.org/mkp/scsi/c/a6b758b0420b

-- 
Martin K. Petersen	Oracle Linux Engineering
