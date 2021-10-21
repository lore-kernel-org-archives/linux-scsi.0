Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B2CC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF77D611C7
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhJUDpw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:45:52 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50318 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231210AbhJUDpW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:22 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L3dUmT020876;
        Thu, 21 Oct 2021 03:43:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=So8HsYdaYAjO3RipzP5rJ7bL45hqUK5K48XQOF7pfIc=;
 b=WN7jNlkT7tBpfAO7lOeuKw0vJtub2RrGu3hZmxUoAjKBDyWraP8ceMbQl4KUKJT0k0Tj
 UCo6iqzxi3y+cjlvEEAY0yyz7ifBROSg5O2idj2NPtT7YbgJKjdGPb9erL6LRjkg01vT
 qRZLvC4srgtX5OmfsHQGhOSCfM2OWeagXw15Aab+5FYARAflgTEGSDweR8HkbhvtrnGY
 prfyYwXHTjwqPK8lvbzr3vkuJO6L/Xpm+yWik16SJF77/8PPNOiZBmQcViygJPEI4LGY
 Nmfr07T95V/T4izzULbPgWkaZZkfbWjhC02PEnZH16N5S7KdSU2KApIvXg+Jn+18e8xE 1Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9v8vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3esxL078083;
        Thu, 21 Oct 2021 03:43:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:02 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu82082116;
        Thu, 21 Oct 2021 03:43:02 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-9;
        Thu, 21 Oct 2021 03:43:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] aha1542: use memcpy_{from,to}_bvec
Date:   Wed, 20 Oct 2021 23:42:40 -0400
Message-Id: <163478764105.7011.14624855567243842942.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211018060802.1815982-1-hch@lst.de>
References: <20211018060802.1815982-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: S_emgtbNEMdHs9uaiYUEQlzH5bHvPvT3
X-Proofpoint-GUID: S_emgtbNEMdHs9uaiYUEQlzH5bHvPvT3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Oct 2021 08:08:02 +0200, Christoph Hellwig wrote:

> Use the memcpy_{from,to}_bvec helpers instead of open coding them.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] aha1542: use memcpy_{from,to}_bvec
      https://git.kernel.org/mkp/scsi/c/e6ab6113526a

-- 
Martin K. Petersen	Oracle Linux Engineering
