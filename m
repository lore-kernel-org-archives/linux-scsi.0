Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CD3C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F17260FED
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhJUDpx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:45:53 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50518 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231232AbhJUDpW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:22 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L1Juvo020887;
        Thu, 21 Oct 2021 03:43:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=Scib/U9YAgotlyQXTJ3il5tg3rMhbXYQKSHnHDUOx+c=;
 b=tmRR1+97DZXdBN/IaivOF/YlOJHc85iv3qjOvmsNjMnytd/WYTQ+dEFxMqARkYAloSwd
 u7agslZ6d4Xjp7sG+bPLtrLuewTDfoRmeyBesormEErr8dMAHDRSg+qLxrX2LMd1RE2Z
 kyG6vHj3Y+FAYgGZHxmn4ubD1b1W2FrXZ4xra9n8HwAtopbeqJik7YBj5dlR3pc5RdbN
 yxuJZPZjPf64zZhdEFgQtKwpTzvh/hB+Ld0q44dUyIYCH73YBM/vybeSnf2dqCYKR/kh
 uiQoTl1hcpc9no/W2KW8Z8vYfwy4Ypncpeuq8DOFbk46LmiIQ5CuO6pn/astIM/iUv1P eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9v8vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3esoO078100;
        Thu, 21 Oct 2021 03:43:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:03 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu84082116;
        Thu, 21 Oct 2021 03:43:02 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-10;
        Thu, 21 Oct 2021 03:43:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] target: stop using bdevname
Date:   Wed, 20 Oct 2021 23:42:41 -0400
Message-Id: <163478764105.7011.8862377483891250727.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211018065052.1822500-1-hch@lst.de>
References: <20211018065052.1822500-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: EvxazgZqCYjo7lyvO3G4cl46HY_wX9YE
X-Proofpoint-GUID: EvxazgZqCYjo7lyvO3G4cl46HY_wX9YE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Oct 2021 08:50:52 +0200, Christoph Hellwig wrote:

> Just use the %pg format specifier instead.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] target: stop using bdevname
      https://git.kernel.org/mkp/scsi/c/1b74ab77d62f

-- 
Martin K. Petersen	Oracle Linux Engineering
