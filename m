Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD41C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95EB7611C7
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhJUDp6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:45:58 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61224 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231166AbhJUDpd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:33 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L2ffsn029728;
        Thu, 21 Oct 2021 03:43:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=TcRDwcZ5d4Py+nVR60KxR+lI6/3WT6kO6W2Siq2Lwis=;
 b=MtEhZ9f3rekh2NfMlnNIpEdQ6lV54gPC0BxvwjkKKzFQ71FjwNeSVfVEED4ir0QC1E5b
 LdxTjFj86O1EHD84PiHGUQvDU0LekIcpoCCwQPV+OT7OhnmvKU5ZmnDBhqfxzgevkjgZ
 P0RxeJ7U9F8GuWbxvObs+TxAurZ2JexA9E4/v1HrDMQqj0py8y2x0b2C7moldj1FMhFv
 YWK7CiQYSORCRSLDZyb36veyJ2H6oMqLUTjlBBjfyhsARvHSScP1bV39jC5W3Up9kOu9
 TBF3s1xnjzVVDyzuk1cz052xQUTo6wuv9INvlcikiDROKyMN1PhIwOQH1l40UYbq+1Du Ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj3ww9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3esKG078043;
        Thu, 21 Oct 2021 03:43:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshembg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:16 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu8S082116;
        Thu, 21 Oct 2021 03:43:15 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-22;
        Thu, 21 Oct 2021 03:43:15 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Varun Prakash <varun@chelsio.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: target: cxgbit: increase max DataSegmentLength
Date:   Wed, 20 Oct 2021 23:42:53 -0400
Message-Id: <163478764104.7011.956624840587774167.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1634135087-4996-1-git-send-email-varun@chelsio.com>
References: <1634135087-4996-1-git-send-email-varun@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: cNgI6W6uJpT5v8NMgip5gx7Ov4Xz4l7-
X-Proofpoint-GUID: cNgI6W6uJpT5v8NMgip5gx7Ov4Xz4l7-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Oct 2021 19:54:47 +0530, Varun Prakash wrote:

> Current value of max DataSegmentLength is 8K, T5/T6 adapters supports
> max DataSegmentLength upto 16K, so increase max DataSegmentLength.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: target: cxgbit: increase max DataSegmentLength
      https://git.kernel.org/mkp/scsi/c/7f96c7a67e40

-- 
Martin K. Petersen	Oracle Linux Engineering
