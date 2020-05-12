Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFA6C54E8F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48CAA2071A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:29:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c42+exij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbgELD3V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 23:29:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41122 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728709AbgELD3U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 23:29:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3NJbE131981;
        Tue, 12 May 2020 03:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4d+mHPV6ZM7+2Q3ZYqxbts6y6lCu79aw3YTsNFdUvvY=;
 b=c42+exij5S+jrVxvLGkWfY96RhDBHWj+hLPfsr5ZfIFzZJDAGz7yAiWaQgc/Z5DVgE5y
 FI7FnO6DhfHDyY9Ai61wxGYEFqr2PhJbjmg0uDZjWNhUk7JSv4podfUgfE0PN+SomCMe
 qqxQAm72hpFgLxSlUooZUsm3bsVXduGNiG08wPFX8IQc3IcSDFJFB8cF8Od9hHd88uLt
 ePv/kvNQEmjsxufcm1krZKfKVYILNgp2xaVc9v1HSwh3cZQM38Q+Pd9N4Gg9V8uCvNXp
 X76V7RFemLtDVn3a3uTT15d/v0eL+a0jKaiEo9ecc9ZprK7iX2auuFCPC89B2PY5En9g ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30x3gsggpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 03:29:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3Ndsv074931;
        Tue, 12 May 2020 03:29:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30x63nxayf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 03:29:12 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04C3TB6x029094;
        Tue, 12 May 2020 03:29:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Mon, 11 May 2020 20:28:49 -0700
MIME-Version: 1.0
Message-ID: <158925392373.17325.1359735648955252575.b4-ty@oracle.com>
Date:   Tue, 12 May 2020 03:28:34 +0000 (UTC)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     QLogic-Storage-Upstream@cavium.com,
        Xie XiuQi <xiexiuqi@huawei.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: qedi: remove unused variable udev & uctrl
References: <20200505121904.25702-1-xiexiuqi@huawei.com>
In-Reply-To: <20200505121904.25702-1-xiexiuqi@huawei.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120029
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 5 May 2020 20:19:04 +0800, Xie XiuQi wrote:

> uctrl and udev are unused after commit 9632a6b4b747
> ("scsi: qedi: Move LL2 producer index processing in BH.")
> 
> Remove them.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: qedi: Remove unused variable udev & uctrl
      https://git.kernel.org/mkp/scsi/c/f9491ed56e3a

-- 
Martin K. Petersen	Oracle Linux Engineering
