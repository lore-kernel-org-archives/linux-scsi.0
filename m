Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D91C83F14
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 01:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242567AbjHaBs5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjHaBs5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 21:48:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDD6CD2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 18:48:54 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0Dki3010732;
        Thu, 31 Aug 2023 01:48:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=siOdtfQ/ACufZW/wJgeXtzBGx0thL3ddfFrqM17FUow=;
 b=h1v4yBYK8LkeC3O2Iw+NQ9oM2cEgPNgEe2qZU7deCTelpBnjo8ekik0Xc0aTOp8KVI11
 +aIs1XxVnBZjLX9Ski+OCq1znFoTZbAHT1K4NmNOzFxIz6RG6yDzEzpdWi0SpIrAtENZ
 A32b0kJfjvS+4t/R96AtB41VRvjUHwABUGIIfoV4bTrV5hRTNDJeWbEPLTg+nIR7NAZy
 HGDq75W9i6O7W9KS4BPGEJtNkm9igb4iA6a3okZqhB9vqnaMCDGc/RwDB/A7CHs2nZmz
 hIIJdobeibX6hYI/56P0UsbDUBZjIYO3uuKPyJGP6b06brybZNU2PKD5az6NokeBFfqh kg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9p00jxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:48:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37UNfBl0032779;
        Thu, 31 Aug 2023 01:48:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6dqtxhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:48:50 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37V1mnKj000352;
        Thu, 31 Aug 2023 01:48:49 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3sr6dqtxfw-1;
        Thu, 31 Aug 2023 01:48:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: sd: Remove the number of forward declarations
Date:   Wed, 30 Aug 2023 21:48:28 -0400
Message-Id: <169344360113.1293881.16748610686665883531.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230823210628.523244-1-bvanassche@acm.org>
References: <20230823210628.523244-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-31_01,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=800 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308310014
X-Proofpoint-ORIG-GUID: b_eqKhwOgRHhR8wIUoU90DTTxl3KYJ0y
X-Proofpoint-GUID: b_eqKhwOgRHhR8wIUoU90DTTxl3KYJ0y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 23 Aug 2023 14:06:28 -0700, Bart Van Assche wrote:

> Move the sd_pm_ops and sd_template data structures to just above
> init_sd() such that the number of forward function declarations can be
> reduced.
> 
> 

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: sd: Remove the number of forward declarations
      https://git.kernel.org/mkp/scsi/c/efcf965a1278

-- 
Martin K. Petersen	Oracle Linux Engineering
