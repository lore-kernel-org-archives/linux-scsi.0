Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 289C3C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 05:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbhLWFJb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Dec 2021 00:09:31 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3438 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232034AbhLWFJ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Dec 2021 00:09:29 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BN0bPpk026373;
        Thu, 23 Dec 2021 05:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=ka1fN9opoH/JSjBMBcYgvxhiqTk+BgBPu2S45svNXsw=;
 b=j8nbESWcHWKS2OksV0de6IXvrwK8GtupmTVWRsv7ROHiou1GtNxfNG9vTP1wDDUuTKNx
 Ka8Unte6gAEM1hZxZ7qEvFRCbhxuiISKqbtGTSPUn/H86X67OwWKWPaEk8PPkFERnUic
 2wqxNH/hlXTU6h75mZ++LUQXZg9a4wC+hjV6hJFtPUyJEV9cJ6+nC2DkpnO8EuUAilJY
 6lwZpGGBSyGdJisCBkTzzkSiMtwYB1289kjCbSNi0Js3dW1NoCDQLGnHv7NpA8TnjtOD
 V06SJskos9pepqS3NPf3Tcre2p1zzsdyFy0Pk/vd1XJ4aKSFerjqKvq/hNXB0PUp7Wbf Fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d4103a1fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 05:09:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BN50vxx102227;
        Thu, 23 Dec 2021 05:09:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3d17f68ve2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 05:09:25 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1BN59OTe125399;
        Thu, 23 Dec 2021 05:09:25 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3d17f68vdd-2;
        Thu, 23 Dec 2021 05:09:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     ram.vegesna@broadcom.com, james.smart@broadcom.com,
        Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] efct: don't pass GFP_DMA to dma_alloc_coherent
Date:   Thu, 23 Dec 2021 00:09:21 -0500
Message-Id: <164023594702.4594.11021890571310786373.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211214163605.416288-1-hch@lst.de>
References: <20211214163605.416288-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: wTmxSnucnDgAzUL5Zq0J8stboWu14RzY
X-Proofpoint-GUID: wTmxSnucnDgAzUL5Zq0J8stboWu14RzY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Dec 2021 17:36:05 +0100, Christoph Hellwig wrote:

> dma_alloc_coherent ignores the zone specifiers, so this is pointless and
> confusing.
> 
> 

Applied to 5.17/scsi-queue, thanks!

[1/1] efct: don't pass GFP_DMA to dma_alloc_coherent
      https://git.kernel.org/mkp/scsi/c/efac162a4e4d

-- 
Martin K. Petersen	Oracle Linux Engineering
