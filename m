Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67301C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 03:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbiBODTy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 22:19:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiBODTv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 22:19:51 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE1120194;
        Mon, 14 Feb 2022 19:19:42 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F2QVt8001610;
        Tue, 15 Feb 2022 03:19:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=qRvvfBAi4GqpHyNUpNrfzYFP33nuCc6PWM+bhkMygO8=;
 b=uazAOWwQNka84g4kbaqeQnjnEFkY+BNWAn6JqSeZSmjOvrv4d9hqy7LY14dfKCx0APve
 t8elVfJjAmsBsJXR3S+KbXiejoUCooCvdDmEs7rcGbRxCPWJwMhEo4P3sH0Ud936MN7p
 T2qIVzt+/0d5nNULXTfZMSevGE0mS+aKPYiP60zmUzgwPAmXSYfhdujlGoo7bkHA7tXm
 V1/UryCCXX44nBrQkzCjgM3cBMA9WQVokddxXhBjlduh5DOby7L+m039huUt23fgIA2L
 kJqXznmbf56iFpfx/hroIfkNYAVk+VY2IsQsBrmQgrNVD0AYlusRqcbenm536ExzTcTD TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e63p26hcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:19:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21F3Gtpq058111;
        Tue, 15 Feb 2022 03:19:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3e620wpgth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:19:33 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21F3JMPI064243;
        Tue, 15 Feb 2022 03:19:33 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3e620wpgqq-9;
        Tue, 15 Feb 2022 03:19:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, damien.lemoal@opensource.wdc.com,
        Yang Li <yang.lee@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>,
        jinpu.wang@cloud.ionos.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next v3] scsi: pm8001: clean up some inconsistent indentin
Date:   Mon, 14 Feb 2022 22:19:21 -0500
Message-Id: <164489513313.15031.18022734177726143464.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220208025500.29511-1-yang.lee@linux.alibaba.com>
References: <20220208025500.29511-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: hjATiPO3AlS6IovEBQu7SGxjlC3Wu4VC
X-Proofpoint-GUID: hjATiPO3AlS6IovEBQu7SGxjlC3Wu4VC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 8 Feb 2022 10:55:00 +0800, Yang Li wrote:

> Eliminate the follow smatch warning:
> drivers/scsi/pm8001/pm8001_ctl.c:760 pm8001_update_flash() warn:
> inconsistent indenting
> 
> 

Applied to 5.18/scsi-queue, thanks!

[1/1] scsi: pm8001: clean up some inconsistent indentin
      https://git.kernel.org/mkp/scsi/c/106b7a2549b4

-- 
Martin K. Petersen	Oracle Linux Engineering
