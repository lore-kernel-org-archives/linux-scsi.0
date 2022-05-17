Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1C5C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 02:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbiEQCRI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 22:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236124AbiEQCQ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 22:16:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066893CA78;
        Mon, 16 May 2022 19:16:58 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GKjIkv009400;
        Tue, 17 May 2022 02:16:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=EDZx3noKrdncNz/1cvortvCCaSiIFzGoHAED5uODYmY=;
 b=ZUgAq9w26MDCIv2e46/lE1LUwy3l0EA2qcxUSLWAUDm6B98RyP3Chog43/1p9CxYQJow
 O2WoGm2FwyZIw+E/CQmjzpWjZZyYQq/lb6dfOVaiiI2wBfuWgXsDBDM0CgQibiugWRgl
 +BwIEJ4sKeMTbQoyyFsfAccZo/CTMaJn1wuKZJw/TO2iHWXuxP/QX70PEu/OpTRKro+G
 yxH34Z75lY0wMQjxGg9181A2gdx+4OQZZQ64AKbbIrPPah7nTKUvTyw6dOsfYlnhEfdF
 LuNjcS06sdtRbf2jApFEB4zAijHyb/JAdTXt9UPHSL/OWQMdC2mplHbCs45F4wx9GXZy Dw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytmwjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 02:16:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24H2G8Bp019232;
        Tue, 17 May 2022 02:16:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v83hmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 02:16:46 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24H2Ghw3019875;
        Tue, 17 May 2022 02:16:45 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v83hkf-5;
        Tue, 17 May 2022 02:16:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, hch@lst.de,
        sagi@grimberg.me, michael.christie@oracle.com
Subject: Re: [PATCH 1/3] target/iscsi: rename iscsi_cmd to iscsit_cmd
Date:   Mon, 16 May 2022 22:16:40 -0400
Message-Id: <165275376861.24722.17710637076786131.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220428092939.36768-1-mgurtovoy@nvidia.com>
References: <20220428092939.36768-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: ODsEWbcH5sMk7Op0QYBD8ZS5-zVX8QEO
X-Proofpoint-ORIG-GUID: ODsEWbcH5sMk7Op0QYBD8ZS5-zVX8QEO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 28 Apr 2022 12:29:37 +0300, Max Gurtovoy wrote:

> The structure iscsi_cmd naming is used by the iscsi initiator driver.
> Rename the target cmd to iscsit_cmd to have more readable code.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/3] target/iscsi: rename iscsi_cmd to iscsit_cmd
      https://git.kernel.org/mkp/scsi/c/66cd9d4ef74a
[2/3] target/iscsi: rename iscsi_conn to iscsit_conn
      https://git.kernel.org/mkp/scsi/c/be36d683fc29
[3/3] target/iscsi: rename iscsi_session to iscsit_session
      https://git.kernel.org/mkp/scsi/c/0873fe44e780

-- 
Martin K. Petersen	Oracle Linux Engineering
