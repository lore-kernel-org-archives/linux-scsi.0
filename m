Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B59C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 18:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240237AbiEXSMA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 14:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240148AbiEXSLz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 14:11:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EB75DD17;
        Tue, 24 May 2022 11:11:54 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHnEUc017393;
        Tue, 24 May 2022 18:11:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=lIVU5BWX5FvBJwbsc37hYobPjaRhme/2XRmwJeITknQ=;
 b=nxML7mM+BzQieICsKoEyGaWKMxUwGkTD+xUpv8taeDB3bJCCfB0E/af6METupFontEya
 7wUGFsdglwfO2PKrulVAIw3eWuztOtQSc77UQ4AzrIF0/OnbrSibc1xdtgneLOeP+hkT
 O5FmkjH1SoqESrIqNubKwfI4jRSstrzpmTAPzfoQzsI0AcVuzTY50jJx9/B04RBgUotA
 nIlJ+rG8ibmTP3RFjKH5b8AvVh4/9M1UO963jHumTADQLLVQvG31elBU3qGFY5Tjn2RL
 uYzAncmBz88lQ2HTN8Ye1am/n/6DzxDyZLcVir90sShmXd10YJumWVffd5fvvaPPpmrx ZQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tb83n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:11:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OHoIk6016351;
        Tue, 24 May 2022 18:11:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x50s61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:11:48 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24OIAvnA039045;
        Tue, 24 May 2022 18:11:47 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x50s3r-9;
        Tue, 24 May 2022 18:11:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Don Brace <don.brace@microchip.com>,
        Julia Lawall <Julia.Lawall@inria.fr>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        storagedev@microchip.com, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: smartpqi: fix typo in comment
Date:   Tue, 24 May 2022 14:11:41 -0400
Message-Id: <165341587530.22286.16052034568851427400.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220521111145.81697-58-Julia.Lawall@inria.fr>
References: <20220521111145.81697-58-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: RcGFiqLSOJaRViJKcmfO2X6aM5rG2QTF
X-Proofpoint-ORIG-GUID: RcGFiqLSOJaRViJKcmfO2X6aM5rG2QTF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 21 May 2022 13:11:08 +0200, Julia Lawall wrote:

> Spelling mistake (triple letters) in comment.
> Detected with the help of Coccinelle.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: smartpqi: fix typo in comment
      https://git.kernel.org/mkp/scsi/c/8946ea283808

-- 
Martin K. Petersen	Oracle Linux Engineering
