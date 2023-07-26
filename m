Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE65EB64DD
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 02:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjGZCF6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 22:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGZCFx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 22:05:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDD9121
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 19:05:53 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PJIpoq029464;
        Wed, 26 Jul 2023 02:05:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=QA5Okt0i1DhcfIQsJMeVSCZWYqTNcpsn1HiwShKK+YY=;
 b=ntJibuKMcYbUlaMwcUSweqD7waxP/DLu4Szb+xBHoBjgIWJa0dVzwhw+W73d7AztdPXx
 J7GtKvHCCIEGg9jwb/se9MLGuYwqcWtGrSFNNKV52eoBf87cH/gMKH+Zaypj+JBTMYZB
 s2lP7hXAyu4V7jSpGpjoFpQiEomD4mEF1XcqyQtCWV8cM/UJ3S6E5EZpzaPl4O4SU2Cc
 TN20/dg8aDAUz0mPkmZ05khgJC1U7z+JLcQ5tDuxdLRA02sC1r/3AeC2Kerv/ps4U3+b
 9dTJ3EpB2z8oKXf5JCseubcCwoaK9Ab6IvpGEIDkXQUFUGaNWVGkRIIEHTFA0HGd/lXS QQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05q1xf5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36Q0RR7U023050;
        Wed, 26 Jul 2023 02:05:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j5jd0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:10 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36Q253NX038905;
        Wed, 26 Jul 2023 02:05:09 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s05j5jcwf-4;
        Wed, 26 Jul 2023 02:05:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.vnet.ibm.com, chenxiang <chenxiang66@hisilicon.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linuxarm@huawei.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/3] Some misc changes
Date:   Tue, 25 Jul 2023 22:04:49 -0400
Message-Id: <169033702302.2256288.11487691638323579348.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <1689045300-44318-1-git-send-email-chenxiang66@hisilicon.com>
References: <1689045300-44318-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_14,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=959
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260016
X-Proofpoint-GUID: QtGnou0nygAyQllh7RFr6nDHAFd1Vbnq
X-Proofpoint-ORIG-GUID: QtGnou0nygAyQllh7RFr6nDHAFd1Vbnq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 11 Jul 2023 11:14:57 +0800, chenxiang wrote:

> This series contain some fixes including:
> - Fix completed I/O analysed as failed
> - Block requests before a debugfs snapshot
> - Delete unused lock in function hisi_sas_port_notify_formed()
> 
> Xingui Yang (1):
>   scsi: hisi_sas: Fix normally completed I/O analysed as failed
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/3] scsi: hisi_sas: Fix normally completed I/O analysed as failed
      https://git.kernel.org/mkp/scsi/c/f5393a5602ca
[2/3] scsi: hisi_sas: Block requests before a debugfs snapshot
      https://git.kernel.org/mkp/scsi/c/32be33747d5d
[3/3] scsi: hisi_sas: Delete unused lock in hisi_sas_port_notify_formed()
      https://git.kernel.org/mkp/scsi/c/29f45ed18aa9

-- 
Martin K. Petersen	Oracle Linux Engineering
