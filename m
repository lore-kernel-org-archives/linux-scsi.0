Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9982DC4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 06:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7054F61364
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 06:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhEaG3i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 02:29:38 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:57598 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230091AbhEaG3i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 02:29:38 -0400
X-UUID: f207106babfc4daaaec69420f3ee7efa-20210531
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=AvEeHQ3Kp5ReO6nmswhx6N+HaayID15eSF3cdoae+Z4=;
        b=N5LO7mtYPoUI2uFQj94gHd5ZJcS2sjnp1xHO4cDfnpfbPvjHdMbhi+5Z12tvNjfQDDIhWccUmdOt+vYqalWz0oTD5VHzWvKdew/aL+39+VXhCMRJodDS15e5yRtIGPc998HG8Q3+QG5JL1o4bzq0U12Aq67JHNgWRu2YDVFDnSI=;
X-UUID: f207106babfc4daaaec69420f3ee7efa-20210531
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1649493313; Mon, 31 May 2021 14:27:55 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 31 May 2021 14:27:51 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 31 May 2021 14:27:51 +0800
Message-ID: <1622442471.7096.2.camel@mtkswgap22>
Subject: RE: [PATCH v1] scsi: ufs-mediatek: Fix HCI version in some platforms
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <powen.kao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>
Date:   Mon, 31 May 2021 14:27:51 +0800
In-Reply-To: <03b601d755de$46968810$d3c39830$@samsung.com>
References: <CGME20210531051803epcas5p4c0a997f3346da0a0a1190630ac64ba94@epcas5p4.samsung.com>
         <20210531051757.11538-1-stanley.chu@mediatek.com>
         <03b601d755de$46968810$d3c39830$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQWxpbSwNCg0KT24gTW9uLCAyMDIxLTA1LTMxIGF0IDExOjAxICswNTMwLCBBbGltIEFraHRh
ciB3cm90ZToNCj4gSGkgU3RhbmxleSwNCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCj4gPiBGcm9tOiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiA+
IFNlbnQ6IDMxIE1heSAyMDIxIDEwOjQ4DQo+ID4gVG86IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwu
b3JnOyBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbTsNCj4gPiBhdnJpLmFsdG1hbkB3ZGMuY29t
OyBhbGltLmFraHRhckBzYW1zdW5nLmNvbTsgamVqYkBsaW51eC5pYm0uY29tDQo+ID4gQ2M6IHBl
dGVyLndhbmdAbWVkaWF0ZWsuY29tOyBjaHVuLWh1bmcud3VAbWVkaWF0ZWsuY29tOw0KPiA+IGFs
aWNlLmNoYW9AbWVkaWF0ZWsuY29tOyBqb25hdGhhbi5oc3VAbWVkaWF0ZWsuY29tOw0KPiA+IHBv
d2VuLmthb0BtZWRpYXRlay5jb207IGNjLmNob3VAbWVkaWF0ZWsuY29tOw0KPiA+IGNoYW90aWFu
LmppbmdAbWVkaWF0ZWsuY29tOyBqaWFqaWUuaGFvQG1lZGlhdGVrLmNvbTsgU3RhbmxleSBDaHUN
Cj4gPiA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiA+IFN1YmplY3Q6IFtQQVRDSCB2MV0g
c2NzaTogdWZzLW1lZGlhdGVrOiBGaXggSENJIHZlcnNpb24gaW4gc29tZSBwbGF0Zm9ybXMNCj4g
PiANCj4gPiBTb21lIE1lZGlhVGVrIHBsYXRmb3JtcyBoYXZlIGluY29ycmVjdCBVRlNIQ0kgdmVy
c2lvbnMgc2hvd2VkIGluIHJlZ2lzdGVyDQo+ID4gbWFwLiBGaXggdGhlIHZlcnNpb24gYnkgcmVm
ZXJyaW5nIHRvIFVuaVBybyB2ZXJzaW9uIHdoaWNoIGlzIGFsd2F5cw0KPiBjb3JyZWN0Lg0KPiA+
IA0KPiBBIGJpdCBvZiBleHRyYSBkZXRhaWxzIHdpbGwgaGVscCBoZXJlLCBsaWtlIHNheSBIQ0kg
dmVyc2lvbiBiZWxvdyAzLjAgaXMNCj4gYnJva2VuIG9uIHNvbWUgTWVkaWFUZWsgU29DIGV0Yy4N
Cj4gVGhhdCB3aWxsIGFsc28gaGVscCB0byB1bmRlcnN0YW5kIGlmIHRoaXMgd2FzIGEgZGV2aWF0
aW9uIGZyb20gSENJIHNwZWMuIA0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQpJIHdvdWxkIGZp
eCBpdCBpbiBuZXh0IHZlcnNpb24uDQoNCj4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU3RhbmxleSBD
aHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCj4gPiAtLS0NCj4gDQo+IFdpdGggdGhlIHVw
ZGF0ZWQgY29tbWl0IG1lc3NhZ2UsIGZlZWwgZnJlZSB0byBhZGQNCj4gUmV2aWV3ZWQtYnk6IEFs
aW0gQWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5nLmNvbT4NCj4gDQo+ID4gIGRyaXZlcnMvc2Nz
aS91ZnMvdWZzLW1lZGlhdGVrLmMgfCAxMSArKysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdl
ZCwgMTEgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
dWZzL3Vmcy1tZWRpYXRlay5jDQo+IGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYw0K
PiA+IGluZGV4IDk5MTJlMjA4YzJhMS4uM2QzNjA1ZmQwNWIyIDEwMDY0NA0KPiA+IC0tLSBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5jDQo+ID4gQEAgLTYwNiw2ICs2MDYsMTYgQEAgc3RhdGljIHZvaWQgdWZz
X210a19nZXRfY29udHJvbGxlcl92ZXJzaW9uKHN0cnVjdA0KPiA+IHVmc19oYmEgKmhiYSkNCj4g
PiAgCQlpZiAodmVyID49IFVGU19VTklQUk9fVkVSXzFfOCkNCj4gPiAgCQkJaG9zdC0+aHdfdmVy
Lm1ham9yID0gMzsNCj4gPiAgCX0NCj4gPiArDQo+ID4gKwkvKiBGaXggSENJIHZlcnNpb24gZm9y
IHNvbWUgcGxhdGZvcm1zIHdpdGggaW5jb3JyZWN0IHZlcnNpb24gKi8NCj4gPiArCWlmIChoYmEt
PnVmc192ZXJzaW9uIDwgdWZzaGNpX3ZlcnNpb24oMywgMCkgJiYNCj4gPiArCSAgICBob3N0LT5o
d192ZXIubWFqb3IgPT0gMykNCj4gPiArCQloYmEtPnVmc192ZXJzaW9uID0gdWZzaGNpX3ZlcnNp
b24oMywgMCk7IH0NCj4gPiArDQo+ID4gK3N0YXRpYyB1MzIgdWZzX210a19nZXRfdWZzX2hjaV92
ZXJzaW9uKHN0cnVjdCB1ZnNfaGJhICpoYmEpIHsNCj4gPiArCXJldHVybiBoYmEtPnVmc192ZXJz
aW9uOw0KPiA+ICB9DQo+ID4gDQo+ID4gIC8qKg0KPiA+IEBAIC0xMDQyLDYgKzEwNTIsNyBAQCBz
dGF0aWMgdm9pZCB1ZnNfbXRrX2V2ZW50X25vdGlmeShzdHJ1Y3QgdWZzX2hiYQ0KPiA+ICpoYmEs
ICBzdGF0aWMgY29uc3Qgc3RydWN0IHVmc19oYmFfdmFyaWFudF9vcHMgdWZzX2hiYV9tdGtfdm9w
cyA9IHsNCj4gPiAgCS5uYW1lICAgICAgICAgICAgICAgID0gIm1lZGlhdGVrLnVmc2hjaSIsDQo+
ID4gIAkuaW5pdCAgICAgICAgICAgICAgICA9IHVmc19tdGtfaW5pdCwNCj4gPiArCS5nZXRfdWZz
X2hjaV92ZXJzaW9uID0gdWZzX210a19nZXRfdWZzX2hjaV92ZXJzaW9uLA0KPiA+ICAJLnNldHVw
X2Nsb2NrcyAgICAgICAgPSB1ZnNfbXRrX3NldHVwX2Nsb2NrcywNCj4gPiAgCS5oY2VfZW5hYmxl
X25vdGlmeSAgID0gdWZzX210a19oY2VfZW5hYmxlX25vdGlmeSwNCj4gPiAgCS5saW5rX3N0YXJ0
dXBfbm90aWZ5ID0gdWZzX210a19saW5rX3N0YXJ0dXBfbm90aWZ5LA0KPiA+IC0tDQo+ID4gMi4x
OC4wDQo+IA0KPiANCg0K

