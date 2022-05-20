Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E66C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 01:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344382AbiETBJv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 21:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344308AbiETBJq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 21:09:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3C0134E2B
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 18:09:37 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24K0InW5015728;
        Fri, 20 May 2022 01:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=Ys+BWDCmMHk5pBz+1hyc+zXpSy4SDWUR+YhD2Izl4/o=;
 b=nWtF/pcbV4UVtAC2DIwZP9MqGee4zQ17+CP9WDSgWg6plW9a4Hopdqk3o7Sx21BhZRQr
 5vkAA2HIufSkzRNOGgvNseXgIvDiSoulyWYRdpNnoST/0bXPDujUEvvsZHCVmtMLbhrj
 FSXUt2ULwleVfiLpwHOVmNpFMNig5OYDXAK8+NGlgLMLEDBOGBZolilFP/O93d63bm0i
 mMLuBt9SosuJt4zokkQvDCSAzsCAMlGUs5nDr0tL2cpruFkMlH7il9Ua95cbLKd1a2x0
 A7/Iu3Ku4ZMsH5tUIUUT/BX0dmWq/3DM1dJ4pPoJeaWJxnMcmyVZK34w7kTf3BirGHJk SA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2372614s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 01:09:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24K15nUm020179;
        Fri, 20 May 2022 01:09:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37crytv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 01:09:35 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24K19GKX030710;
        Fri, 20 May 2022 01:09:34 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37crythd-15;
        Fri, 20 May 2022 01:09:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: update driver version to 42.100.00.00
Date:   Thu, 19 May 2022 21:09:14 -0400
Message-Id: <165300891229.11465.3836450910734297687.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220511072621.30657-2-sreekanth.reddy@broadcom.com>
References: <20220511072621.30657-1-sreekanth.reddy@broadcom.com> <20220511072621.30657-2-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: jb25lfMVblljWhPbDtWBAWsR7HdrWPm7
X-Proofpoint-ORIG-GUID: jb25lfMVblljWhPbDtWBAWsR7HdrWPm7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 11 May 2022 12:56:21 +0530, Sreekanth Reddy wrote:

> update driver version to 42.100.00.00
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] mpt3sas: update driver version to 42.100.00.00
      https://git.kernel.org/mkp/scsi/c/53d5088deff6

-- 
Martin K. Petersen	Oracle Linux Engineering
