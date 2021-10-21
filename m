Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C29C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C4E6611CB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhJUDqG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:46:06 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:60562 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231338AbhJUDpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:32 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L2ffsm029728;
        Thu, 21 Oct 2021 03:43:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=8wCALJOrcgDE47eIRjzIDfnEf3dcSMielbcbWvuXZMU=;
 b=UH3YNpGQTcij993D+E1jbd8LpQGtdU5q/suXX12v/TXLs/VugSlnuHh3w6WozrFrjecS
 I/xI0nwdIqNa5d/twgRGu63fPJEmablkLxV2XS6yEuoLackLwv8g0NR1KckKmsY0eihR
 i4X3dQN4WiwEX5zZFX5k8REg2geTkghLKEkNCJWY8+gGQaWst5Vo62d+9VW5/pCAxzfZ
 nLTp41qsb9G3YL+JP4UhKA1TZI5QvgwvTAr+lyAjxpEdSai8SXxrlhZIBinOfQ/tzlpp
 BV4ix0x2xra+aGDGfwjo7ZccHXDlFLhTAUGmpiZWl/2mbRfNs1ItGQeG0xenWe6gxd/X bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj3ww8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3esRo078107;
        Thu, 21 Oct 2021 03:43:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshemat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:15 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu8Q082116;
        Thu, 21 Oct 2021 03:43:14 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-21;
        Thu, 21 Oct 2021 03:43:14 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Varun Prakash <varun@chelsio.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: target: cxgbit: enable Delayed ACK
Date:   Wed, 20 Oct 2021 23:42:52 -0400
Message-Id: <163478764104.7011.14143909934375873978.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1634135109-5044-1-git-send-email-varun@chelsio.com>
References: <1634135109-5044-1-git-send-email-varun@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 8tgqfWyqp2rH7SMeRvQtJK5-1R-CB0QO
X-Proofpoint-GUID: 8tgqfWyqp2rH7SMeRvQtJK5-1R-CB0QO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Oct 2021 19:55:09 +0530, Varun Prakash wrote:

> Enable Delayed ACK to reduce the number of TCP ACKs.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: target: cxgbit: enable Delayed ACK
      https://git.kernel.org/mkp/scsi/c/d1e51ea6bf5f

-- 
Martin K. Petersen	Oracle Linux Engineering
