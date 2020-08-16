Return-Path: <SRS0=wEW2=B2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC044C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Aug 2020 01:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CAFD2068E
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Aug 2020 01:01:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="TDFP7WDt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgHPBBf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 Aug 2020 21:01:35 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:1349 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726177AbgHPBBf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Aug 2020 21:01:35 -0400
X-UUID: 8a6bad4c50ac426a8ac4670e5d7dabe9-20200816
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=IDErbtAWX1NDJEPZMKsgOloJQKGKV4XyKZTxb6CpxlM=;
        b=TDFP7WDteTvL0le2lQgmdb2FzGg6GYg1NBR+FkRXqD5KlO3KukztMQj7/3erMNJ1KYDiTNX9jNRqaAPRjwMtyprNf1dwJK+23897EYQX1Mx/RGaI/IpN1uwOIdQQoXA/Vw6hgrpVToA29Slx+8jeOWDtxvDpfyD8jRSH5wIO0r0=;
X-UUID: 8a6bad4c50ac426a8ac4670e5d7dabe9-20200816
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 342660871; Sun, 16 Aug 2020 09:01:29 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 16 Aug 2020 09:01:27 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 16 Aug 2020 09:01:27 +0800
Message-ID: <1597539688.7483.2.camel@mtkswgap22>
Subject: Re: [PATCH v3 2/2] scsi: ufs: remove several redundant goto
 statements
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Sun, 16 Aug 2020 09:01:28 +0800
In-Reply-To: <20200814095034.20709-3-huobean@gmail.com>
References: <20200814095034.20709-1-huobean@gmail.com>
         <20200814095034.20709-3-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDIwLTA4LTE0IGF0IDExOjUwICswMjAwLCBCZWFuIEh1byB3cm90ZToNCj4gRnJv
bTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJl
YW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQoNClJldmlld2VkLWJ5OiBTdGFubGV5IENodSA8
c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KDQoNCg0K

