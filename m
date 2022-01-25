Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B682C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 05:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240918AbiAYFym (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 00:54:42 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:59868 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235546AbiAYFlZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 00:41:25 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20P1lZGM016164;
        Tue, 25 Jan 2022 05:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=R3IcTpp6nYCa1fh4Tewpi6PxkCDIUR2z9aA4F5qiOY0=;
 b=xMeq6/eMuOpUcfADITUtAHkuVanaChbmmiGonBmLCtLB8X8LCWxO2FT7jZ8wFBMYjl0m
 XUXC/VwHiwODR9MrvIYpa11NTBvOjPBzTBTGBvoB2h0iwxEgp1L2E4wOGCIEJmBa6M5h
 2hw6uLxRHG48bX3TuGoTOQixZRcY6HHMjk/pyLt3dCJRaqLAQYCslKFINyaDPmqJu48W
 7JmJS4B4ydhnXnBMJcjadP2iLnXY5+WCbKgWp3ETT0rEoITUPhI6px9mXBbUnHoP9OLj
 MCozWKGTwyDjvrbo2LIwFgpR0A/DZrIxKG8pR6jHa0GmRytKx0jPCJNqSlS6Ot6bW9AA mQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dsxvfhw4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 05:41:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20P5ex3r182063;
        Tue, 25 Jan 2022 05:41:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3dr71x1st0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 05:41:05 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 20P5evOh181790;
        Tue, 25 Jan 2022 05:41:05 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3dr71x1sgc-9;
        Tue, 25 Jan 2022 05:41:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     xkernel.wang@foxmail.com, bvanassche@acm.org, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, alim.akhtar@samsung.com
Subject: Re: [PATCH v2] scsi: ufs: ufshcd-pltfrm: check the return value of devm_kstrdup()
Date:   Tue, 25 Jan 2022 00:40:45 -0500
Message-Id: <164308671270.32373.13488934927194632781.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <tencent_4257E15D4A94FF9020DDCC4BB9B21C041408@qq.com>
References: <tencent_4257E15D4A94FF9020DDCC4BB9B21C041408@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: UjLU95K2vd0wms_fHjdFGKGQxlBdDO1p
X-Proofpoint-ORIG-GUID: UjLU95K2vd0wms_fHjdFGKGQxlBdDO1p
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 16 Jan 2022 11:06:49 +0800, xkernel.wang@foxmail.com wrote:

> From: Xiaoke Wang <xkernel.wang@foxmail.com>
> 
> devm_kstrdup() returns pointer to allocated string on success,
> NULL on failure. So it is better to check the return value of it.
> 
> 

Applied to 5.17/scsi-fixes, thanks!

[1/1] scsi: ufs: ufshcd-pltfrm: check the return value of devm_kstrdup()
      https://git.kernel.org/mkp/scsi/c/a65b32748f45

-- 
Martin K. Petersen	Oracle Linux Engineering
