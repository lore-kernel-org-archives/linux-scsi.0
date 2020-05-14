Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4243FC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 01:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37EB2206DA
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 01:37:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="E8eQCC3g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgENBhd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 21:37:33 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:37435 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725925AbgENBhd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 21:37:33 -0400
X-UUID: 00a92f2294714e43b9febebdfaefd178-20200514
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Drge9OXYgbT+fFEdFivffpxHUog0+A3cvV/oIWxCy0o=;
        b=E8eQCC3ggnQS0UGiA7OXfIXtk9/yM9/YzL5CssbiVK1y76v+bCyWf+UmyThF4nPkYhvWQI/M7NAhVbl9J/zpH8EXOjzB651RBGC/ZPEk1UMwx07M50pAqcHcyPxcGPk09AUmDiP5jGEJFdJhOxTWi696gSni5l+Xt/9espY9SuE=;
X-UUID: 00a92f2294714e43b9febebdfaefd178-20200514
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 335581158; Thu, 14 May 2020 09:37:30 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 14 May 2020 09:37:27 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 09:37:25 +0800
Message-ID: <1589420249.3197.69.camel@mtkswgap22>
Subject: Re: [PATCH -next] scsi: ufs-mediatek: Make ufs_mtk_fixup_dev_quirks
 static
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     ChenTao <chentao107@huawei.com>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <matthias.bgg@gmail.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <avri.altman@wdc.com>,
        <linux-mediatek@lists.infradead.org>, <alim.akhtar@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Thu, 14 May 2020 09:37:29 +0800
In-Reply-To: <20200514012655.127202-1-chentao107@huawei.com>
References: <20200514012655.127202-1-chentao107@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgVGFvLA0KDQpPbiBUaHUsIDIwMjAtMDUtMTQgYXQgMDk6MjYgKzA4MDAsIENoZW5UYW8gd3Jv
dGU6DQo+IEZpeCB0aGUgZm9sbG93aW5nIHdhcm5pbmc6DQo+IA0KPiBkcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jOjU4NTo2OiB3YXJuaW5nOg0KPiBzeW1ib2wgJ3Vmc19tdGtfZml4dXBf
ZGV2X3F1aXJrcycgd2FzIG5vdCBkZWNsYXJlZC4gU2hvdWxkIGl0IGJlIHN0YXRpYz8NCj4gDQo+
IFJlcG9ydGVkLWJ5OiBIdWxrIFJvYm90IDxodWxrY2lAaHVhd2VpLmNvbT4NCj4gU2lnbmVkLW9m
Zi1ieTogQ2hlblRhbyA8Y2hlbnRhbzEwN0BodWF3ZWkuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMv
c2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
dWZzL3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KPiBp
bmRleCBjNTQzMTQyNTU0ZDMuLjczZTRhNGY5YTNhMiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9z
Y3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRp
YXRlay5jDQo+IEBAIC01ODIsNyArNTgyLDcgQEAgc3RhdGljIGludCB1ZnNfbXRrX2FwcGx5X2Rl
dl9xdWlya3Moc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4gIA0K
PiAtdm9pZCB1ZnNfbXRrX2ZpeHVwX2Rldl9xdWlya3Moc3RydWN0IHVmc19oYmEgKmhiYSkNCj4g
K3N0YXRpYyB2b2lkIHVmc19tdGtfZml4dXBfZGV2X3F1aXJrcyhzdHJ1Y3QgdWZzX2hiYSAqaGJh
KQ0KPiAgew0KPiAgCXN0cnVjdCB1ZnNfZGV2X2luZm8gKmRldl9pbmZvID0gJmhiYS0+ZGV2X2lu
Zm87DQo+ICAJdTE2IG1pZCA9IGRldl9pbmZvLT53bWFudWZhY3R1cmVyaWQ7DQoNClRoYW5rcyBm
b3IgZml4aW5nIHRoaXMuDQoNClJldmlld2VkLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVA
bWVkaWF0ZWsuY29tPg0KDQo=

