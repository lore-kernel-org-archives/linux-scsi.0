Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B4DC47092
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 13:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E58AC61168
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 13:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhFBNgZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 09:36:25 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:54095 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229607AbhFBNgZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 09:36:25 -0400
X-UUID: 619fd117eb55465d8695c070e1e45972-20210602
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=9hbb8O6BI5gt7CFoq95S1grGDY1B6J6/8izewqh8RFM=;
        b=onQmnGUO9CoceiO9EHA9t88NxUyoZNWq50lqqotgw31Iqt35gPxcJ4w4yf5i/KaIl36BmpjhMOJr4UJe0gCdUxuDwNd64ihiFV1ZVWYkA09pYGnQmGES1a0mntqqGexxazg8qYZjzTDZ2rqbLpCL+d80TsjFvP4ozUvdlJfd9oI=;
X-UUID: 619fd117eb55465d8695c070e1e45972-20210602
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2012241096; Wed, 02 Jun 2021 21:34:35 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 2 Jun 2021 21:34:34 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 21:34:34 +0800
Message-ID: <1622640874.7096.3.camel@mtkswgap22>
Subject: Re: [PATCH v2] scsi: ufs-mediatek: create device link of reset
 control
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <peter.wang@mediatek.com>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <wsd_upstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>
Date:   Wed, 2 Jun 2021 21:34:34 +0800
In-Reply-To: <1622601720-22466-1-git-send-email-peter.wang@mediatek.com>
References: <1622601720-22466-1-git-send-email-peter.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgUGV0ZXIsDQoNCk9uIFdlZCwgMjAyMS0wNi0wMiBhdCAxMDo0MiArMDgwMCwgcGV0ZXIud2Fu
Z0BtZWRpYXRlay5jb20gd3JvdGU6DQo+IEZyb206IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVk
aWF0ZWsuY29tPg0KPiANCj4gTWVkaWF0ZWsgVUZTIHJlc2V0IGZ1bmN0aW9uIGlzIHJlbGllZCBv
biBSZXNldCBDb250cm9sIHByb3ZpZGVkDQo+IGJ5IHJlc2V0LXRpLXN5c2Nvbi4gVG8gbWFrZSBS
ZXNldCBDb250cm9sIHdvcmsgcHJvcGVybHksIHNlbGVjdA0KPiByZXNldC10aS1zeXNjb24gdG8g
ZW5zdXJlIGl0IGJlaW5nIGJ1aWx0IHdpdGggdWZzLW1lZGlhdGVrIHRvZ2V0aGVyLg0KPiBJbiBh
ZGRpdGlvbiwgZXN0YWJsaXNoIGRldmljZSBsaW5rIHRvIHdhaXQgdW50aWwgcmVzZXQtdGktc3lz
Y29uDQo+IGluaXRpYWxpemF0aW9uIGlzIGRvbmUgZHVyaW5nIFVGUyBwcm9iaW5nIGZsb3cuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4N
Cg0KUmV2aWV3ZWQtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQoN
Cg==

