Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2124C64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 08:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5546722203
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 08:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgLBIXV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 03:23:21 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:51597 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727065AbgLBIXV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 03:23:21 -0500
X-UUID: 2216c9978d3943efabfe2ea7d5b5d476-20201202
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=eW3bJobgy0k/p95VGblYVIXoRiGa/RVCmghE8dcbJ9Y=;
        b=WFNd0ndneFa6baOFFO3+I7ZodIBKDaikfN8gIL3/7urddhKUPaNWcVxfR7GC33X0uHgkJ698E8f7zTDan1LF8TEJkbdTj8rGgX4xXcccCyQlPTCYObf1/JX9Kajqr3cwxgvaqbr2PTflv8xgJyEfx+skHSYR7Fbdr1tFnQohXg8=;
X-UUID: 2216c9978d3943efabfe2ea7d5b5d476-20201202
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 407798482; Wed, 02 Dec 2020 16:22:36 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 2 Dec 2020 16:22:33 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Dec 2020 16:22:34 +0800
Message-ID: <1606897354.23925.33.camel@mtkswgap22>
Subject: Re: [PATCH v2] scsi: ufs: Remove pre-defined initial voltage values
 of device powers
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <nguyenb@codeaurora.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bjorn.andersson@linaro.org>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>,
        <chaotian.jing@mediatek.com>, <cc.chou@mediatek.com>,
        <jiajie.hao@mediatek.com>, <alice.chao@mediatek.com>
Date:   Wed, 2 Dec 2020 16:22:34 +0800
In-Reply-To: <c855aaeb419bc7c124889c5afb0cae71@codeaurora.org>
References: <20201201065114.1001-1-stanley.chu@mediatek.com>
         <c855aaeb419bc7c124889c5afb0cae71@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 59F7DD2B71DFE41EF021D9395D5202A7A9640B3088C7A4077DEE432C3854098A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIwLTEyLTAyIGF0IDAwOjE5IC0wODAwLCBuZ3V5ZW5iQGNvZGVhdXJvcmEub3Jn
IHdyb3RlOg0KPiBPbiAyMDIwLTExLTMwIDIyOjUxLCBTdGFubGV5IENodSB3cm90ZToNCj4gPiBV
RlMgc3BlY2ZpY2ljYXRpb24gYWxsb3dzIGRpZmZlcmVudCBWQ0MgY29uZmlndXJhdGlvbnMgZm9y
IFVGUyBkZXZpY2VzLA0KPiA+IGZvciBleGFtcGxlLA0KPiA+IAkoMSkuIDIuNzBWIC0gMy42MFYg
KEFjdGl2YXRlZCBieSBkZWZhdWx0IGluIFVGUyBjb3JlIGRyaXZlcikNCj4gPiAJKDIpLiAxLjcw
ViAtIDEuOTVWIChBY3RpdmF0ZWQgaWYgInZjYy1zdXBwbHktMXA4IiBpcyBkZWNsYXJlZCBpbg0K
PiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgZGV2aWNlIHRyZWUpDQo+ID4gCSgzKS4gMi40
MFYgLSAyLjcwViAoU3VwcG9ydGVkIHNpbmNlIFVGUyAzLngpDQo+ID4gDQo+ID4gV2l0aCB0aGUg
aW50cm9kdWN0aW9uIG9mIFVGUyAzLnggcHJvZHVjdHMsIGFuIGlzc3VlIGlzIGhhcHBlbmluZyB0
aGF0DQo+ID4gVUZTIGRyaXZlciB3aWxsIHVzZSB3cm9uZyAibWluX3VWLW1heF91ViIgdmFsdWVz
IHRvIGNvbmZpZ3VyZSB0aGUNCj4gPiB2b2x0YWdlIG9mIFZDQyByZWd1bGF0b3Igb24gVUZVIDMu
eCBwcm9kdWN0cyB3aXRoIHRoZSBjb25maWd1cmF0aW9uICgzKQ0KPiA+IHVzZWQuDQo+ID4gDQo+
ID4gVG8gc29sdmUgdGhpcyBpc3N1ZSwgd2Ugc2ltcGx5IHJlbW92ZSBwcmUtZGVmaW5lZCBpbml0
aWFsIFZDQyB2b2x0YWdlDQo+ID4gdmFsdWVzIGluIFVGUyBjb3JlIGRyaXZlciB3aXRoIGJlbG93
IHJlYXNvbnMsDQo+ID4gDQo+ID4gMS4gVUZTIHNwZWNpZmljYXRpb25zIGRvIG5vdCBkZWZpbmUg
aG93IHRvIGRldGVjdCB0aGUgVkNDIGNvbmZpZ3VyYXRpb24NCj4gPiAgICBzdXBwb3J0ZWQgYnkg
YXR0YWNoZWQgZGV2aWNlLg0KPiA+IA0KPiA+IDIuIERldmljZSB0cmVlIGFscmVhZHkgc3VwcG9y
dHMgc3RhbmRhcmQgcmVndWxhdG9yIHByb3BlcnRpZXMuDQo+ID4gDQo+ID4gVGhlcmVmb3JlIFZD
QyB2b2x0YWdlIHNoYWxsIGJlIGRlZmluZWQgY29ycmVjdGx5IGluIGRldmljZSB0cmVlLCBhbmQN
Cj4gPiBzaGFsbCBub3QgY2hhbmdlZCBieSBVRlMgZHJpdmVyLiBXaGF0IFVGUyBkcml2ZXIgbmVl
ZHMgdG8gZG8gaXMgc2ltcGx5DQo+ID4gZW5hYmxlIG9yIGRpc2FibGUgdGhlIFZDQyByZWd1bGF0
b3Igb25seS4NCj4gPiANCj4gPiBTaW1pbGFyIGNoYW5nZSBpcyBhcHBsaWVkIHRvIFZDQ1EgYW5k
IFZDQ1EyIGFzIHdlbGwuDQo+ID4gDQo+ID4gTm90ZSB0aGF0IHdlIGtlZXAgc3RydWN0IHVmc192
cmVnIHVuY2hhbmdlZC4gVGhpcyBpcyBhbGxvdyB2ZW5kb3JzIHRvDQo+ID4gY29uZmlndXJlIHBy
b3BlciBtaW5fdVYgYW5kIG1heF91ViBvZiBhbnkgcmVndWxhdG9ycyB0byBtYWtlDQo+ID4gcmVn
dWxhdG9yX3NldF92b2x0YWdlKCkgd29ya3MgZHVyaW5nIHJlZ3VsYXRvciB0b2dnbGluZyBmbG93
Lg0KPiA+IFdpdGhvdXQgc3BlY2lmaWMgdmVuZG9yIGNvbmZpZ3VyYXRpb25zLCBtaW5fdVYgYW5k
IG1heF91ViB3aWxsIGJlIE5VTEwNCj4gPiBieSBkZWZhdWx0IGFuZCBVRlMgY29yZSBkcml2ZXIg
d2lsbCBlbmFibGUgb3IgZGlzYWJsZSB0aGUgcmVndWxhdG9yDQo+ID4gb25seSB3aXRob3V0IGFk
anVzdGluZyBpdHMgdm9sdGFnZS4NCj4gPiANCj4gPiBSZXZpZXdlZC1ieTogQmpvcm4gQW5kZXJz
c29uIDxiam9ybi5hbmRlcnNzb25AbGluYXJvLm9yZz4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTdGFu
bGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC1wbHRmcm0uYyB8IDE2IC0tLS0tLS0tLS0tLS0tLS0NCj4gPiAgMSBm
aWxlIGNoYW5nZWQsIDE2IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL3Njc2kvdWZzL3Vmc2hjZC1wbHRmcm0uYyANCj4gPiBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
aGNkLXBsdGZybS5jDQo+ID4gaW5kZXggYTZmNzYzOTliM2FlLi4wOWUyZjA0YmY0ZjYgMTAwNjQ0
DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QtcGx0ZnJtLmMNCj4gPiArKysgYi9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC1wbHRmcm0uYw0KPiA+IEBAIC0xMzMsMjIgKzEzMyw2IEBA
IHN0YXRpYyBpbnQgdWZzaGNkX3BvcHVsYXRlX3ZyZWcoc3RydWN0IGRldmljZQ0KPiA+ICpkZXYs
IGNvbnN0IGNoYXIgKm5hbWUsDQo+ID4gIAkJdnJlZy0+bWF4X3VBID0gMDsNCj4gPiAgCX0NCj4g
PiANCj4gPiAtCWlmICghc3RyY21wKG5hbWUsICJ2Y2MiKSkgew0KPiA+IC0JCWlmIChvZl9wcm9w
ZXJ0eV9yZWFkX2Jvb2wobnAsICJ2Y2Mtc3VwcGx5LTFwOCIpKSB7DQo+ID4gLQkJCXZyZWctPm1p
bl91ViA9IFVGU19WUkVHX1ZDQ18xUDhfTUlOX1VWOw0KPiA+IC0JCQl2cmVnLT5tYXhfdVYgPSBV
RlNfVlJFR19WQ0NfMVA4X01BWF9VVjsNCj4gPiAtCQl9IGVsc2Ugew0KPiA+IC0JCQl2cmVnLT5t
aW5fdVYgPSBVRlNfVlJFR19WQ0NfTUlOX1VWOw0KPiA+IC0JCQl2cmVnLT5tYXhfdVYgPSBVRlNf
VlJFR19WQ0NfTUFYX1VWOw0KPiA+IC0JCX0NCj4gPiAtCX0gZWxzZSBpZiAoIXN0cmNtcChuYW1l
LCAidmNjcSIpKSB7DQo+ID4gLQkJdnJlZy0+bWluX3VWID0gVUZTX1ZSRUdfVkNDUV9NSU5fVVY7
DQo+ID4gLQkJdnJlZy0+bWF4X3VWID0gVUZTX1ZSRUdfVkNDUV9NQVhfVVY7DQo+ID4gLQl9IGVs
c2UgaWYgKCFzdHJjbXAobmFtZSwgInZjY3EyIikpIHsNCj4gPiAtCQl2cmVnLT5taW5fdVYgPSBV
RlNfVlJFR19WQ0NRMl9NSU5fVVY7DQo+ID4gLQkJdnJlZy0+bWF4X3VWID0gVUZTX1ZSRUdfVkND
UTJfTUFYX1VWOw0KPiA+IC0JfQ0KPiA+IC0NCj4gPiAgCWdvdG8gb3V0Ow0KPiBEbyB3ZSBuZWVk
IHRoaXMgImdvdG8gb3V0OyI/DQoNCldpbGwgcmVtb3ZlIGl0IGluIG5leHQgdmVyc2lvbi4NCg0K
VGhhbmtzIGZvciByZW1pbmQuDQoNClN0YW5sZXkgQ2h1DQoNCj4gDQo+ID4gDQo+ID4gIG91dDoN
Cg0K

