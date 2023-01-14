Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A45C3DA78
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Jan 2023 03:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjANDUd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjANDUb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 22:20:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B1088DEA
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2023 19:20:30 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30E2u45u007316;
        Sat, 14 Jan 2023 03:20:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=/xkg1Dk049/5CCQUFIMTQ5eYRNUMqmiBq8WkiveaFBE=;
 b=XxKgASYDWVjnAUqRg6P665zkN7iLHrAxREYzqSTM60JMTCvVcPABWCMvlM4/BG+ih2gR
 LH7xLQreYzECN/FVi0nBlFZeVhOtoB54aJ1CrqzvpnxazMJWQ7aU//a7hbLv/1fdUldR
 xNpEuvHqb8BnTwNp4nOK7XDCIdh9CkxhDSFE985LmYRB6gzyHLwvdkVotG/XwfmtY6PF
 RedivkjEBnqfN1CfpTg4ywg7mqB0g+LLpI/qpqK+GiTBIOGG4u+ilnBWYlsG5OMyLx52
 Xs8XFvpC3ptOObeReawZZ6wGaXWqi5j2F+LQ3U6nljllMvKbXOxm95r9K2WjnOOV+9IR fA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3jtug2fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 03:20:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30E2d4ZJ008300;
        Sat, 14 Jan 2023 03:20:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n3ksx0pde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 03:20:12 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30E3KBJK012010;
        Sat, 14 Jan 2023 03:20:11 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3n3ksx0pcp-1;
        Sat, 14 Jan 2023 03:20:11 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.vnet.ibm.com, chenxiang <chenxiang66@hisilicon.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH 0/2] hisi_sas: Some misc update
Date:   Fri, 13 Jan 2023 22:20:06 -0500
Message-Id: <167366638827.3070030.2753985937564950422.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <1672805000-141102-1-git-send-email-chenxiang66@hisilicon.com>
References: <1672805000-141102-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_12,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=748 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301140021
X-Proofpoint-GUID: _bM6hZEsOcfco7c0_XnHHqsj8hMvT2md
X-Proofpoint-ORIG-GUID: _bM6hZEsOcfco7c0_XnHHqsj8hMvT2md
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 04 Jan 2023 12:03:18 +0800, chenxiang wrote:

> There are two bugfixes related to hisi sas driver:
> - Use abort task set command to reset SAS disks when discovered;
> - Set a port invalid only if there is no devices attached when refreshing
> port id;
> 
> Xingui Yang (1):
>   scsi: hisi_sas: Use abort task set to reset SAS disks when discovered
> 
> [...]

Applied to 6.2/scsi-fixes, thanks!

[1/2] scsi: hisi_sas: Use abort task set to reset SAS disks when discovered
      https://git.kernel.org/mkp/scsi/c/037b48057e8b
[2/2] scsi: hisi_sas: Set a port invalid only if there is no devices attached when refreshing port id
      https://git.kernel.org/mkp/scsi/c/f58c89700630

-- 
Martin K. Petersen	Oracle Linux Engineering
