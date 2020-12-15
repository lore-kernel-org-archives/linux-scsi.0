Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A6EDC4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1147822225
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 09:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbgLOI6Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 03:58:16 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:56765 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727134AbgLOI6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 03:58:08 -0500
X-UUID: 632aff21dcee45538c8a8f7a8b798dbc-20201215
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=jYm47xmaT1D4jDw4e/jJo8U9Z8nJxan2eS2DDh4rxwY=;
        b=YVpoi/mnN6FMZnMQUIVNFvt5H/nikMzO4YX7i/RM9Bsv967BOSLISN3e7c2HN9ClmXMo5TN3Y52oy/iGJBujjRB81/UqbDtGQuqxhMjiN+9wAto8Dyjph+HPaJev9ZU4uT6Jrvb6zjX0JrHfry7x/WYNljfReddHprWSiAxG2Jc=;
X-UUID: 632aff21dcee45538c8a8f7a8b798dbc-20201215
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 124555772; Tue, 15 Dec 2020 16:57:19 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 15 Dec 2020 16:57:18 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Dec 2020 16:57:19 +0800
Message-ID: <1608022638.10163.14.camel@mtkswgap22>
Subject: Re: [PATCH v4 4/6] scsi: ufs: Remove d_wb_alloc_units from struct
 ufs_dev_info
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Tue, 15 Dec 2020 16:57:18 +0800
In-Reply-To: <20201211140035.20016-5-huobean@gmail.com>
References: <20201211140035.20016-1-huobean@gmail.com>
         <20201211140035.20016-5-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmVhbiwNCg0KT24gRnJpLCAyMDIwLTEyLTExIGF0IDE1OjAwICswMTAwLCBCZWFuIEh1byB3
cm90ZToNCj4gRnJvbTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IGRfd2Jf
YWxsb2NfdW5pdHMgb25seSBiZSB1c2VkIHdoaWxlIFdCIHByb2JlLCBqdXN0IHVzZWQgdG8gY29u
ZmlybSB0aGUNCj4gY29uZGl0aW9uIHRoYXQgImlmIGJXcml0ZUJvb3N0ZXJCdWZmZXJUeXBlIGlz
IHNldCB0byAwMWggYnV0DQo+IGROdW1TaGFyZWRXcml0ZUJvb3N0ZXJCdWZmZXJBbGxvY1VuaXRz
IGlzIHNldCB0byB6ZXJvLCB0aGUgV3JpdGVCb29zdGVyDQo+IGZlYXR1cmUgaXMgZGlzYWJsZWQi
LiBTbywgZG9uJ3QgbmVlZCB0byBrZWVwIGl0IGluIHJ1bnRpbWUuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2Nz
aS91ZnMvdWZzLmggICAgfCAxIC0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCA2ICsr
LS0tLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMuaCBiL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzLmgNCj4gaW5kZXggNDViZWJjYTI5ZmRkLi44ZWQzNDJlNDM4ODMgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLmgNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91
ZnMuaA0KPiBAQCAtNTQ0LDcgKzU0NCw2IEBAIHN0cnVjdCB1ZnNfZGV2X2luZm8gew0KPiAgCWJv
b2wJd2JfYnVmX2ZsdXNoX2VuYWJsZWQ7DQo+ICAJdTgJd2JfZGVkaWNhdGVkX2x1Ow0KPiAgCXU4
CWJfd2JfYnVmZmVyX3R5cGU7DQo+IC0JdTMyCWRfd2JfYWxsb2NfdW5pdHM7DQoNClBlcmhhcHMg
YmVsb3cgdHdvIGZpZWxkcyBjb3VsZCBiZSBhbHNvIHJlbW92ZWQgZnJvbSBzdHJ1Y3QgdWZzX2Rl
dl9pbmZvDQpmb3IgdGhlIHNhbWUgcmVhc29uPw0KDQp1MzIgZF9leHRfdWZzX2ZlYXR1cmVfc3Vw
Ow0KdTMyIGRfd2JfYWxsb2NfdW5pdHM7DQoNClRoYW5rcywNClN0YW5sZXkgQ2h1DQoNCj4gIA0K
PiAgCWJvb2wJYl9ycG1fZGV2X2ZsdXNoX2NhcGFibGU7DQo+ICAJdTgJYl9wcmVzcnZfdXNwY19l
bjsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5jDQo+IGluZGV4IDUyOGMyNTdkZjQ4Yy4uMDk5OGU2MTAzY2Q3IDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvc2Nz
aS91ZnMvdWZzaGNkLmMNCj4gQEAgLTcyNDMsMTAgKzcyNDMsOCBAQCBzdGF0aWMgdm9pZCB1ZnNo
Y2Rfd2JfcHJvYmUoc3RydWN0IHVmc19oYmEgKmhiYSwgdTggKmRlc2NfYnVmKQ0KPiAgCQlkZXNj
X2J1ZltERVZJQ0VfREVTQ19QQVJBTV9XQl9QUkVTUlZfVVNSU1BDX0VOXTsNCj4gIA0KPiAgCWlm
IChkZXZfaW5mby0+Yl93Yl9idWZmZXJfdHlwZSA9PSBXQl9CVUZfTU9ERV9TSEFSRUQpIHsNCj4g
LQkJZGV2X2luZm8tPmRfd2JfYWxsb2NfdW5pdHMgPQ0KPiAtCQlnZXRfdW5hbGlnbmVkX2JlMzIo
ZGVzY19idWYgKw0KPiAtCQkJCSAgIERFVklDRV9ERVNDX1BBUkFNX1dCX1NIQVJFRF9BTExPQ19V
TklUUyk7DQo+IC0JCWlmICghZGV2X2luZm8tPmRfd2JfYWxsb2NfdW5pdHMpDQo+ICsJCWlmICgh
Z2V0X3VuYWxpZ25lZF9iZTMyKGRlc2NfYnVmICsNCj4gKwkJCQkgICBERVZJQ0VfREVTQ19QQVJB
TV9XQl9TSEFSRURfQUxMT0NfVU5JVFMpKQ0KPiAgCQkJZ290byB3Yl9kaXNhYmxlZDsNCj4gIAl9
IGVsc2Ugew0KPiAgCQlmb3IgKGx1biA9IDA7IGx1biA8IFVGU19VUElVX01BWF9XQl9MVU5fSUQ7
IGx1bisrKSB7DQoNCg==

