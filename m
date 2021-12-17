Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99C5C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Dec 2021 04:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhLQEEy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Dec 2021 23:04:54 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37494 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232618AbhLQEEt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Dec 2021 23:04:49 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BH2Xq4j004108;
        Fri, 17 Dec 2021 04:04:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=aXD2TQuu+MvQo6xdgMJWtTovEFO9lrrSGnIaTpWiZr4=;
 b=I6v5o/kTmdEVN8ry5X9VlgHk3+hXSIeikVdTtIOokWiw2ca9/COYTPO1pks4qL+weQYh
 bcLEYRSWOMDJD3keephYjOZd3BpldTB1cVyWRJ2h4ZC5CRTAIeU59SQPhl0VFpg+sX8k
 0CMCoLAIba0X29nGGIGWgoNw5awdoWPTouwmTx6TVeiiRAnG1uvMqqB98vxTanh3P9z0
 mmnHbn5uXIucrJFuVBWJpiOfOr6cbFa5lC8jH5f7g9xVjZuCtQh31b9kBROfkwuOIJdb
 BtuvfM7vAhUWNKiN8duvScCg4vExHF3UkHiglb7QZzq8LwBLaH5LOQDeRs/DBC3qjBSG mQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cykmcmkge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 04:04:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BH40hVA154441;
        Fri, 17 Dec 2021 04:04:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3cvh436duw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 04:04:45 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1BH44ici167096;
        Fri, 17 Dec 2021 04:04:44 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3cvh436duh-1;
        Fri, 17 Dec 2021 04:04:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     don.brace@microchip.com, jejb@linux.ibm.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        storagedev@microchip.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: hpsa: Remove an unused variable in 'hpsa_update_scsi_devices()'
Date:   Thu, 16 Dec 2021 23:04:40 -0500
Message-Id: <163971367437.637.18022597359309025330.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <9f80ea569867b5f7ae1e0f99d656e5a8bacad34e.1639084205.git.christophe.jaillet@wanadoo.fr>
References: <9f80ea569867b5f7ae1e0f99d656e5a8bacad34e.1639084205.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: QY48Zus_s-waqmI-H6srCMDwVt_ET--e
X-Proofpoint-GUID: QY48Zus_s-waqmI-H6srCMDwVt_ET--e
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 9 Dec 2021 22:11:56 +0100, Christophe JAILLET wrote:

> 'lunzerobits' is unused. Remove it.
> 
> This a left over of commit 2d62a33e05d4("hpsa: eliminate fake lun0
> enclosures")
> 
> 

Applied to 5.17/scsi-queue, thanks!

[1/1] scsi: hpsa: Remove an unused variable in 'hpsa_update_scsi_devices()'
      https://git.kernel.org/mkp/scsi/c/8c2d04551545

-- 
Martin K. Petersen	Oracle Linux Engineering
