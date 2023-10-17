Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B7A9CDB465
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 01:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbjJQBMH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 21:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbjJQBMG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 21:12:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A329B
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 18:12:05 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GKOA4p013034;
        Tue, 17 Oct 2023 01:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=X0uH6I9ywveZUSHCMXtz93kW1W5TAabAH/kTqbdk97w=;
 b=EivBKtM9tLVf1zKLQ4hW4mDKgRkQpoBurBy+92BBF6J+UmxxH+UAB+dPN6m9GrfCxtCo
 VLy7Yk1iWqXd5KIEycV125RZU0Kc/dX3+L3OIS+cV2hNGOyFJ0+oDKdy71GGQvJd3L9l
 /rmI1W4F+Qldc2Lb7qObEVisHgPEOaomICRPc+7U6J0wcVPDqd1I2huHVsqjw9Qyi6Op
 ZbHr2ksQjOrBwUywaoHUZmZewssbJY3J6KJa4fXU+ybKdCdYaNCJ7mr77/GViD9NJ/71
 jjtdUkfD+ZvDd5Yf0rsH6GBaokwrCfKtTNFsxwvszeJm0QX9fe6LHK6RgPg3f3rpQDq4 Mw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk3jm24y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GMp6Fn026887;
        Tue, 17 Oct 2023 01:12:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg5366my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:03 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39H1C3sg039761;
        Tue, 17 Oct 2023 01:12:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3trg5366mf-1;
        Tue, 17 Oct 2023 01:12:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] megaraid_sas: Driver version update to 07.727.03.00-rc1
Date:   Mon, 16 Oct 2023 21:11:48 -0400
Message-Id: <169750286925.2183937.7625592269181066795.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231003110021.168862-1-chandrakanth.patil@broadcom.com>
References: <20231003110021.168862-1-chandrakanth.patil@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=913 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170008
X-Proofpoint-GUID: i8sfo65ZZKEk9XM8R-5RdN4pxy1zIXHF
X-Proofpoint-ORIG-GUID: i8sfo65ZZKEk9XM8R-5RdN4pxy1zIXHF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 03 Oct 2023 16:30:17 +0530, Chandrakanth patil wrote:

> This set of patches includes critical fixes, and updates to the
> maintainer list.
> 
> Chandrakanth patil (4):
>   megaraid_sas: Increase register read retry rount from 3 to 30 for
>     selected registers
>   megaraid_sas: Log message when controller reset is requested but not
>     issued
>   megaraid_sas: Driver version update to 07.727.03.00-rc1
>   megaraid_sas: Revision of Maintainer List
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[1/4] megaraid_sas: Increase register read retry rount from 3 to 30 for selected registers
      https://git.kernel.org/mkp/scsi/c/8e3ed9e78651
[2/4] megaraid_sas: Log message when controller reset is requested but not issued
      https://git.kernel.org/mkp/scsi/c/2d83fb023c90
[3/4] megaraid_sas: Driver version update to 07.727.03.00-rc1
      https://git.kernel.org/mkp/scsi/c/0938f9fa4208
[4/4] megaraid_sas: Revision of Maintainer List
      https://git.kernel.org/mkp/scsi/c/be6f21817e0b

-- 
Martin K. Petersen	Oracle Linux Engineering
