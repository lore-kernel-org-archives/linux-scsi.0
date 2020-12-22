Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4584C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 06:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8289B23127
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 06:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgLVGJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 01:09:23 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:55959 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725300AbgLVGJX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 01:09:23 -0500
X-UUID: 1c6826d501c44b03a616272cd97e1036-20201222
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=ISsgMmBDhJwYXHoXtyGmWqaFjFM88UAX0xMCPWSA5sI=;
        b=j1HwzDMrTOAyCgCcI2HKg9MINWdNdJEqJXyVLi5kBE/vN+MGiDA+IenTawSYrFsCFGN/c/9bPzYugRcFI85HBneyEhYVSBSFHNzI4u3x8LL5IJq84dOGDd/OIT3EyBGJ3QDpDZctVXeOvdPmWu9QdC4KKN2x2OMnWfRZGLMQTgE=;
X-UUID: 1c6826d501c44b03a616272cd97e1036-20201222
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 112392751; Tue, 22 Dec 2020 14:08:36 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 22 Dec 2020 14:08:25 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 22 Dec 2020 14:08:25 +0800
Message-ID: <1608617307.14045.3.camel@mtkswgap22>
Subject: Re: [PATCH v5 1/7] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bean Huo <huobean@gmail.com>
CC:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>,
        <cang@codeaurora.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Tue, 22 Dec 2020 14:08:27 +0800
In-Reply-To: <20201215230519.15158-2-huobean@gmail.com>
References: <20201215230519.15158-1-huobean@gmail.com>
         <20201215230519.15158-2-huobean@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: ED24C92C2695BF6C31C609C8DFD1D65D089DA42802291C02003BC14C236BB56A2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmVhbiwNCg0KT24gV2VkLCAyMDIwLTEyLTE2IGF0IDAwOjA1ICswMTAwLCBCZWFuIEh1byB3
cm90ZToNCj4gRnJvbTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IEN1cnJl
bnRseSBVRlMgV3JpdGVCb29zdGVyIGRyaXZlciB1c2VzIGNsb2NrIHNjYWxpbmcgdXAvZG93biB0
byBzZXQNCj4gV0Igb24vb2ZmLCBmb3IgdGhlIHBsYXRmb3JtIHdoaWNoIGRvZXNuJ3Qgc3VwcG9y
dCBVRlNIQ0RfQ0FQX0NMS19TQ0FMSU5HLA0KPiBXQiB3aWxsIGJlIGFsd2F5cyBvbi4gUHJvdmlk
ZSBhIHN5c2ZzIGF0dHJpYnV0ZSB0byBlbmFibGUvZGlzYWJsZSBXQg0KPiBkdXJpbmcgcnVudGlt
ZS4gV3JpdGUgMS8wIHRvICJ3Yl9vbiIgc3lzZnMgbm9kZSB0byBlbmFibGUvZGlzYWJsZSBVRlMg
V0IuDQo+IA0KPiBSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+
DQo+IFJldmlld2VkLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0K
PiBTaWduZWQtb2ZmLWJ5OiBCZWFuIEh1byA8YmVhbmh1b0BtaWNyb24uY29tPg0KPiAtLS0NCj4g
IGRyaXZlcnMvc2NzaS91ZnMvdWZzLXN5c2ZzLmMgfCA0MSArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysNCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgfCAgMyArLS0N
Cj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggICAgfCAgMiArKw0KPiAgMyBmaWxlcyBjaGFu
Z2VkLCA0NCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS91ZnMvdWZzLXN5c2ZzLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1zeXNm
cy5jDQo+IGluZGV4IDA4ZTcyYjdlZWY2YS4uZjNjYTNkNmI4MmM0IDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL3Njc2kvdWZzL3Vmcy1zeXNmcy5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZz
LXN5c2ZzLmMNCj4gQEAgLTE4OSw2ICsxODksNDUgQEAgc3RhdGljIHNzaXplX3QgYXV0b19oaWJl
cm44X3N0b3JlKHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gIAlyZXR1cm4gY291bnQ7DQo+ICB9DQo+
ICANCj4gK3N0YXRpYyBzc2l6ZV90IHdiX29uX3Nob3coc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1
Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwNCj4gKwkJCSAgY2hhciAqYnVmKQ0KPiArew0KPiAr
CXN0cnVjdCB1ZnNfaGJhICpoYmEgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCj4gKw0KPiArCXJl
dHVybiBzeXNmc19lbWl0KGJ1ZiwgIiVkXG4iLCBoYmEtPndiX2VuYWJsZWQpOw0KPiArfQ0KPiAr
DQo+ICtzdGF0aWMgc3NpemVfdCB3Yl9vbl9zdG9yZShzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0cnVj
dCBkZXZpY2VfYXR0cmlidXRlICphdHRyLA0KPiArCQkJICAgY29uc3QgY2hhciAqYnVmLCBzaXpl
X3QgY291bnQpDQo+ICt7DQo+ICsJc3RydWN0IHVmc19oYmEgKmhiYSA9IGRldl9nZXRfZHJ2ZGF0
YShkZXYpOw0KPiArCXVuc2lnbmVkIGludCB3Yl9lbmFibGU7DQo+ICsJc3NpemVfdCByZXM7DQo+
ICsNCj4gKwlpZiAodWZzaGNkX2lzX2Nsa3NjYWxpbmdfc3VwcG9ydGVkKGhiYSkpIHsNCj4gKwkJ
LyoNCj4gKwkJICogSWYgdGhlIHBsYXRmb3JtIHN1cHBvcnRzIFVGU0hDRF9DQVBfQ0xLX1NDQUxJ
TkcsIHR1cm4gV0INCj4gKwkJICogb24vb2ZmIHdpbGwgYmUgZG9uZSB3aGlsZSBjbG9jayBzY2Fs
aW5nIHVwL2Rvd24uDQo+ICsJCSAqLw0KPiArCQlkZXZfd2FybihkZXYsICJUbyBjb250cm9sIFdC
IHRocm91Z2ggd2Jfb24gaXMgbm90IGFsbG93ZWQhXG4iKTsNCj4gKwkJcmV0dXJuIC1FT1BOT1RT
VVBQOw0KPiArCX0NCj4gKwlpZiAoIXVmc2hjZF9pc193Yl9hbGxvd2VkKGhiYSkpDQo+ICsJCXJl
dHVybiAtRU9QTk9UU1VQUDsNCj4gKw0KPiArCWlmIChrc3RydG91aW50KGJ1ZiwgMCwgJndiX2Vu
YWJsZSkpDQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiArDQo+ICsJaWYgKHdiX2VuYWJsZSAhPSAw
ICYmIHdiX2VuYWJsZSAhPSAxKQ0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gKw0KPiArCXBtX3J1
bnRpbWVfZ2V0X3N5bmMoaGJhLT5kZXYpOw0KPiArCXJlcyA9IHVmc2hjZF93Yl9jdHJsKGhiYSwg
d2JfZW5hYmxlKTsNCg0KTWF5IHRoaXMgb3BlcmF0aW9uIHJhY2Ugd2l0aCBVRlMgc2h1dGRvd24g
Zmxvdz8NCg0KVG8gYmUgbW9yZSBjbGVhciwgdWZzaGNkX3diX2N0cmwoKSBoZXJlIG1heSBiZSBl
eGVjdXRlZCBhZnRlciBob3N0IGNsb2NrDQppcyBkaXNhYmxlZCBieSBzaHV0ZG93biBmbG93Pw0K
DQpJZiB5ZXMsIHdlIG5lZWQgdG8gYXZvaWQgaXQuDQoNClRoYW5rcywNClN0YW5sZXkgQ2h1DQoN
Cj4gKwlwbV9ydW50aW1lX3B1dF9zeW5jKGhiYS0+ZGV2KTsNCj4gKw0KPiArCXJldHVybiByZXMg
PCAwID8gcmVzIDogY291bnQ7DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyBERVZJQ0VfQVRUUl9SVyhy
cG1fbHZsKTsNCj4gIHN0YXRpYyBERVZJQ0VfQVRUUl9STyhycG1fdGFyZ2V0X2Rldl9zdGF0ZSk7
DQo+ICBzdGF0aWMgREVWSUNFX0FUVFJfUk8ocnBtX3RhcmdldF9saW5rX3N0YXRlKTsNCj4gQEAg
LTE5Niw2ICsyMzUsNyBAQCBzdGF0aWMgREVWSUNFX0FUVFJfUlcoc3BtX2x2bCk7DQo+ICBzdGF0
aWMgREVWSUNFX0FUVFJfUk8oc3BtX3RhcmdldF9kZXZfc3RhdGUpOw0KPiAgc3RhdGljIERFVklD
RV9BVFRSX1JPKHNwbV90YXJnZXRfbGlua19zdGF0ZSk7DQo+ICBzdGF0aWMgREVWSUNFX0FUVFJf
UlcoYXV0b19oaWJlcm44KTsNCj4gK3N0YXRpYyBERVZJQ0VfQVRUUl9SVyh3Yl9vbik7DQo+ICAN
Cj4gIHN0YXRpYyBzdHJ1Y3QgYXR0cmlidXRlICp1ZnNfc3lzZnNfdWZzaGNkX2F0dHJzW10gPSB7
DQo+ICAJJmRldl9hdHRyX3JwbV9sdmwuYXR0ciwNCj4gQEAgLTIwNSw2ICsyNDUsNyBAQCBzdGF0
aWMgc3RydWN0IGF0dHJpYnV0ZSAqdWZzX3N5c2ZzX3Vmc2hjZF9hdHRyc1tdID0gew0KPiAgCSZk
ZXZfYXR0cl9zcG1fdGFyZ2V0X2Rldl9zdGF0ZS5hdHRyLA0KPiAgCSZkZXZfYXR0cl9zcG1fdGFy
Z2V0X2xpbmtfc3RhdGUuYXR0ciwNCj4gIAkmZGV2X2F0dHJfYXV0b19oaWJlcm44LmF0dHIsDQo+
ICsJJmRldl9hdHRyX3diX29uLmF0dHIsDQo+ICAJTlVMTA0KPiAgfTsNCj4gIA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNk
LmMNCj4gaW5kZXggZTIyMWFkZDI1YTdlLi41ZTFkY2Y0ZGU2N2UgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
Yw0KPiBAQCAtMjQ2LDcgKzI0Niw2IEBAIHN0YXRpYyBpbmxpbmUgaW50IHVmc2hjZF9jb25maWdf
dnJlZ19ocG0oc3RydWN0IHVmc19oYmEgKmhiYSwNCj4gIHN0YXRpYyBpbnQgdWZzaGNkX3RyeV90
b19hYm9ydF90YXNrKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGludCB0YWcpOw0KPiAgc3RhdGljIGlu
dCB1ZnNoY2Rfd2JfYnVmX2ZsdXNoX2VuYWJsZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKTsNCj4gIHN0
YXRpYyBpbnQgdWZzaGNkX3diX2J1Zl9mbHVzaF9kaXNhYmxlKHN0cnVjdCB1ZnNfaGJhICpoYmEp
Ow0KPiAtc3RhdGljIGludCB1ZnNoY2Rfd2JfY3RybChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29s
IGVuYWJsZSk7DQo+ICBzdGF0aWMgaW50IHVmc2hjZF93Yl90b2dnbGVfZmx1c2hfZHVyaW5nX2g4
KHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgc2V0KTsNCj4gIHN0YXRpYyBpbmxpbmUgdm9pZCB1
ZnNoY2Rfd2JfdG9nZ2xlX2ZsdXNoKHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgZW5hYmxlKTsN
Cj4gIHN0YXRpYyB2b2lkIHVmc2hjZF9oYmFfdnJlZ19zZXRfbHBtKHN0cnVjdCB1ZnNfaGJhICpo
YmEpOw0KPiBAQCAtNTM1MSw3ICs1MzUwLDcgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2Jrb3BzX2V4
Y2VwdGlvbl9ldmVudF9oYW5kbGVyKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICAJCQkJX19mdW5j
X18sIGVycik7DQo+ICB9DQo+ICANCj4gLXN0YXRpYyBpbnQgdWZzaGNkX3diX2N0cmwoc3RydWN0
IHVmc19oYmEgKmhiYSwgYm9vbCBlbmFibGUpDQo+ICtpbnQgdWZzaGNkX3diX2N0cmwoc3RydWN0
IHVmc19oYmEgKmhiYSwgYm9vbCBlbmFibGUpDQo+ICB7DQo+ICAJaW50IHJldDsNCj4gIAl1OCBp
bmRleDsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggYi9kcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5oDQo+IGluZGV4IDliYjVmMGVkNDEyNC4uMmE5NzAwNmEyYzkzIDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQo+ICsrKyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmgNCj4gQEAgLTEwNjgsNiArMTA2OCw4IEBAIGludCB1ZnNoY2RfZXhl
Y19yYXdfdXBpdV9jbWQoc3RydWN0IHVmc19oYmEgKmhiYSwNCj4gIAkJCSAgICAgdTggKmRlc2Nf
YnVmZiwgaW50ICpidWZmX2xlbiwNCj4gIAkJCSAgICAgZW51bSBxdWVyeV9vcGNvZGUgZGVzY19v
cCk7DQo+ICANCj4gK2ludCB1ZnNoY2Rfd2JfY3RybChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29s
IGVuYWJsZSk7DQo+ICsNCj4gIC8qIFdyYXBwZXIgZnVuY3Rpb25zIGZvciBzYWZlbHkgY2FsbGlu
ZyB2YXJpYW50IG9wZXJhdGlvbnMgKi8NCj4gIHN0YXRpYyBpbmxpbmUgY29uc3QgY2hhciAqdWZz
aGNkX2dldF92YXJfbmFtZShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAgew0KDQo=

