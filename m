Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57890C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 22:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345163AbiAJWFD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 17:05:03 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28940 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345157AbiAJWE6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jan 2022 17:04:58 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJlelZ021735;
        Mon, 10 Jan 2022 22:04:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=FC/fHcE+YZOPK3IoUVnYLEpKAYyryx34fbjLUOzUG2E=;
 b=oQZv82MgqlVR6HBatObO/pSmC5l3F8kwaPXzYQpY+jKvvtzulCPMJDjqeZfSJm9vRIfy
 0FP4eYTyuNOFjmEr8IgTY2iKjtnr3WQaIDCCji7uSQUmVgXO1KzOiRrJ+beomhhPlM4A
 3DdWyI0a6yRQOqL7iALoZOjnJ3I4SlW/UfOVwRxuHuqePURMEM4G9LY28RLPB8G0ecBJ
 fPjTGqQKIYrEXFFY8IeO5S+DdRDGD5mxHm8CwXHn/WayzurQaYVY/3cajVUimgYpxi1x
 uURQsLNsevxRyvhwN2cC4QE0HPrT+uj4DiwstquMypDoMQtJW/7LeqiccEpZIMdr14Ji SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgmk99hhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 22:04:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20ALtvSD138985;
        Mon, 10 Jan 2022 22:04:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3df2e3vqx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 22:04:53 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 20AM4iCC174082;
        Mon, 10 Jan 2022 22:04:53 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3df2e3vqp8-8;
        Mon, 10 Jan 2022 22:04:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: Re: [PATCH] scsi: aacraid: fix spelling of "its"
Date:   Mon, 10 Jan 2022 17:04:40 -0500
Message-Id: <164182835584.13635.17053434981605031244.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211223061119.18304-1-rdunlap@infradead.org>
References: <20211223061119.18304-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: z-mznXZxQhdifS1WHMgMAK6DwVpt1DSa
X-Proofpoint-ORIG-GUID: z-mznXZxQhdifS1WHMgMAK6DwVpt1DSa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 22 Dec 2021 22:11:19 -0800, Randy Dunlap wrote:

> Use the possessive "its" instead of the contraction "it's" in
> user messages.
> 
> 

Applied to 5.17/scsi-queue, thanks!

[1/1] scsi: aacraid: fix spelling of "its"
      https://git.kernel.org/mkp/scsi/c/4d516e495235

-- 
Martin K. Petersen	Oracle Linux Engineering
