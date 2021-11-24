Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A93C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 02:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhKXCDO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 21:03:14 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:64029 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239983AbhKXCDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 21:03:14 -0500
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211124020003epoutp02e0f575915d1a0aad7439c46c781b34ca~6WPBj6KWL2220322203epoutp024
        for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2021 02:00:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211124020003epoutp02e0f575915d1a0aad7439c46c781b34ca~6WPBj6KWL2220322203epoutp024
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1637719204;
        bh=VcBGBIj6j8bDTg3pEh6bRIeLDHFRtd5W46zRjsi4PGc=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=m0ubO+qVl3nSU7qrxXKeI0vmV8RUCI6Z2flUG7WMlz7vsI2aCmUFtPaUFQNirLgvk
         4GzevveGxDJRhQvUpVyhSKsbkyLDDshz1Rn256LuWQD7fwoPf7IhM+wS5PXMwqvZXT
         I/TgYssL4xsmGt7Z0CD3BNMzQCzLifj3CLYydWs0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20211124020003epcas3p332d8424fcaa0737b36979061bc7c0298~6WPBCts5v2355123551epcas3p3d;
        Wed, 24 Nov 2021 02:00:03 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4HzPN32b4Bz4x9QM; Wed, 24 Nov 2021 02:00:03 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH 13/13] scsi: Remove superfluous #include <linux/async.h>
 directives
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Keoseong Park <keosung.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20211124005217.2300458-14-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21637719203276.JavaMail.epsvc@epcpadp3>
Date:   Wed, 24 Nov 2021 10:54:32 +0900
X-CMS-MailID: 20211124015432epcms2p319359183454d04ce149985368591b9da
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20211124005259epcas2p30b07896d8dcdb3ec71ff1ae87e169a18
References: <20211124005217.2300458-14-bvanassche@acm.org>
        <20211124005217.2300458-1-bvanassche@acm.org>
        <CGME20211124005259epcas2p30b07896d8dcdb3ec71ff1ae87e169a18@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> 
>Remove this include directive from code that does not use any
>functionality from kernel/async.c.
> 
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>---

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
