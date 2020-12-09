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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C53C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 06:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB73423B84
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 06:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgLIGtu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 01:49:50 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:46624 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728030AbgLIGtu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 01:49:50 -0500
X-UUID: 8fbaf453778946c7b5edae647397d99f-20201209
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=/BNwn7ZnxvpJrjyggPTyczK8/eauiOe9smE73GyHAnA=;
        b=WfcPMQOlt8JpDtufkVRzQFajY4rMNmVCrYyNiyG9foDwfDQdbOT83mo44VstCUcyCRRkEr/g3iHyVR9TbMHLBS/Vw5sV0I6XfYYUS9bUwWRWvQAgHSw+6C1WbmLRnSiHKZqSSsydB31qZvT3D+sZI/JA+3i0e8Xk8ZRbhO6w1yo=;
X-UUID: 8fbaf453778946c7b5edae647397d99f-20201209
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 270000220; Wed, 09 Dec 2020 14:48:59 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 9 Dec 2020 14:48:54 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Dec 2020 14:48:58 +0800
Message-ID: <1607496538.3580.31.camel@mtkswgap22>
Subject: Re: [PATCH 1/1] scsi: ufs-mediatek: use correct path to fix
 compiling error
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-mediatek <linux-mediatek@lists.infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Wed, 9 Dec 2020 14:48:58 +0800
In-Reply-To: <20201209063144.1840-2-thunder.leizhen@huawei.com>
References: <20201209063144.1840-1-thunder.leizhen@huawei.com>
         <20201209063144.1840-2-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgWmhlbiwNCg0KT24gV2VkLCAyMDIwLTEyLTA5IGF0IDE0OjMxICswODAwLCBaaGVuIExlaSB3
cm90ZToNCj4gV2hlbiB0aGUga2VybmVsIGlzIGNvbXBpbGVkIHdpdGggYWxsbW9kY29uZmlnLCB0
aGUgZm9sbG93aW5nIGVycm9yIGlzDQo+IHJlcG9ydGVkOg0KPiBJbiBmaWxlIGluY2x1ZGVkIGZy
b20gZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWstdHJhY2UuaDozNjowLA0KPiAgICAgICAg
ICAgICAgICAgIGZyb20gZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWsuYzoyODoNCj4gLi9p
bmNsdWRlL3RyYWNlL2RlZmluZV90cmFjZS5oOjk1OjQyOiBmYXRhbCBlcnJvcjogLi91ZnMtbWVk
aWF0ZWstdHJhY2UuaDogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQ0KPiAgI2luY2x1ZGUgVFJB
Q0VfSU5DTFVERShUUkFDRV9JTkNMVURFX0ZJTEUpDQo+IA0KPiBUaGUgY29tbWVudCBpbiBpbmNs
dWRlL3RyYWNlL2RlZmluZV90cmFjZS5oIHNwZWNpZmllcyB0aGF0Og0KPiBUUkFDRV9JTkNMVURF
X1BBVEg6IE5vdGUsIHRoZSBwYXRoIGlzIHJlbGF0aXZlIHRvIGRlZmluZV90cmFjZS5oLCBub3Qg
dGhlDQo+IGZpbGUgaW5jbHVkaW5nIGl0LiBGdWxsIHBhdGggbmFtZXMgZm9yIG91dCBvZiB0cmVl
IG1vZHVsZXMgbXVzdCBiZSB1c2VkLg0KPiANCj4gU28gd2l0aG91dCAiQ0ZMQUdTX3Vmcy1tZWRp
YXRlay5vIDo9IC1JJChzcmMpIiwgdGhlIGN1cnJlbnQgZGlyZWN0b3J5ICIuIg0KPiBpcyAiaW5j
bHVkZS90cmFjZS8iLCB0aGUgcmVsYXRpdmUgcGF0aCBvZiB1ZnMtbWVkaWF0ZWstdHJhY2UuaCBp
cw0KPiAiLi4vLi4vZHJpdmVycy9zY3NpL3Vmcy8iLg0KPiANCj4gRml4ZXM6IGNhMWJiMDYxZDY0
NCAoInNjc2k6IHVmcy1tZWRpYXRlazogSW50cm9kdWNlIGV2ZW50X25vdGlmeSBpbXBsZW1lbnRh
dGlvbiIpDQo+IFNpZ25lZC1vZmYtYnk6IFpoZW4gTGVpIDx0aHVuZGVyLmxlaXpoZW5AaHVhd2Vp
LmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1tZWRpYXRlay10cmFjZS5oIHwg
MiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0ZWstdHJhY2UuaCBi
L2RyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLXRyYWNlLmgNCj4gaW5kZXggZmQ2Zjg0YzFi
NGUyMjU2Li44OTVlODJlYTZlY2U1NTEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzLW1lZGlhdGVrLXRyYWNlLmgNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtbWVkaWF0
ZWstdHJhY2UuaA0KPiBAQCAtMzEsNiArMzEsNiBAQCBUUkFDRV9FVkVOVCh1ZnNfbXRrX2V2ZW50
LA0KPiAgDQo+ICAjdW5kZWYgVFJBQ0VfSU5DTFVERV9QQVRIDQo+ICAjdW5kZWYgVFJBQ0VfSU5D
TFVERV9GSUxFDQo+IC0jZGVmaW5lIFRSQUNFX0lOQ0xVREVfUEFUSCAuDQo+ICsjZGVmaW5lIFRS
QUNFX0lOQ0xVREVfUEFUSCAuLi8uLi9kcml2ZXJzL3Njc2kvdWZzLw0KPiAgI2RlZmluZSBUUkFD
RV9JTkNMVURFX0ZJTEUgdWZzLW1lZGlhdGVrLXRyYWNlDQo+ICAjaW5jbHVkZSA8dHJhY2UvZGVm
aW5lX3RyYWNlLmg+DQoNClRoYW5rcyBmb3IgdGhpcyBmaXguDQoNClJldmlld2VkLWJ5OiBTdGFu
bGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KDQoNCg0KDQoNCg==

