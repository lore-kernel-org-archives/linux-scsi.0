Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A84C64EC4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 02:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjCGC5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 21:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjCGC5i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 21:57:38 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C4F39CFC
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 18:57:37 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326NwnNP026409;
        Tue, 7 Mar 2023 02:57:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=bpy8cgwdBoX4dYBx3HOvbi3Smx3CN0uLf3Smm4ozZaM=;
 b=24QcfM8V24y4xAB4TnwlJpwFOroUGvjybruVZnO0QYLpao547Lz+jx/qsnJytpXuaQOf
 l0quxtNbONa8TqFz5rEfmMMO3bsA9FNOUk2GZnRXRTZ9f/PH5QrVPkLT4u1wC2X+ppsu
 WByBprUEDCd7tj+9k39478jBXgkUWAepA29iNe+P3qmWIOyc837UaImURhoueZA3uvyF
 WqYlB8wqCwRK/6IrfqCzzKSLzHK9bw0NRsyMgr4GkSxo3KzGJnSgtm/dF3a2w+7PAGTt
 3n/b5RJzW5pTNRzz+2/Ru368sb5Jqh59BrsydFPESuSO2JbceUdlsSvknb0/74DKEwLx fQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4180vf7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3271WcIM037529;
        Tue, 7 Mar 2023 02:57:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4txdvjj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:35 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3272vY2C009567;
        Tue, 7 Mar 2023 02:57:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p4txdvjhj-2;
        Tue, 07 Mar 2023 02:57:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sumit.saxena@broadcom.com
Subject: Re: [PATCH 0/3] Driver version update to 07.725.01.00-rc1
Date:   Mon,  6 Mar 2023 21:57:19 -0500
Message-Id: <167815780206.2075334.7134147620066453336.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230302105342.34933-1-chandrakanth.patil@broadcom.com>
References: <20230302105342.34933-1-chandrakanth.patil@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=687 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070025
X-Proofpoint-ORIG-GUID: ValzEhl4PMtdNlidtTZK1XhHIG5n61HC
X-Proofpoint-GUID: ValzEhl4PMtdNlidtTZK1XhHIG5n61HC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 02 Mar 2023 16:23:39 +0530, Chandrakanth Patil wrote:

> This patchset contains two critical fixes.
> 
> Chandrakanth Patil (3):
>   megaraid_sas: Update max supported LD IDs to 240
>   megaraid_sas: Add crash dump mode capability bit in MFI capabilities
>   Driver version update to 07.725.01.00-rc1
> 
> [...]

Applied to 6.3/scsi-fixes, thanks!

[1/3] megaraid_sas: Update max supported LD IDs to 240
      https://git.kernel.org/mkp/scsi/c/bfa659177dcb
[2/3] megaraid_sas: Add crash dump mode capability bit in MFI capabilities
      https://git.kernel.org/mkp/scsi/c/9bcb1d5a3d10
[3/3] Driver version update to 07.725.01.00-rc1
      https://git.kernel.org/mkp/scsi/c/a2033f9f9d78

-- 
Martin K. Petersen	Oracle Linux Engineering
