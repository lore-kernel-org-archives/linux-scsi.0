From: majianpeng <majianpeng@gmail.com>
Subject: Re: RE: [PATCH] scsi/mvsas: Fix oops when ata command timeout.
Date: Thu, 2 Aug 2012 13:13:03 +0800
Message-ID: <201208021312245004210@gmail.com>
References: <201208011514367031060@gmail.com>,
	<F766E4F80769BD478052FB6533FA745D1A58530359@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48746 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2HBFLt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2012 01:11:49 -0400
Received: by obbuo13 with SMTP id uo13so13301046obb.19
        for <linux-scsi@vger.kernel.org>; Wed, 01 Aug 2012 22:11:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?gb2312?B?09rP8sHB?= <yuxiangl@marvell.com>, scsi maintainers <JBottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

T24gMjAxMi0wOC0wMSAxOToyMSBYaWFuZ2xpYW5nIFl1IDx5dXhpYW5nbEBtYXJ2ZWxsLmNvbT4g
V3JvdGU6DQo+SGksIEppYW5wZW5nDQo+DQo+SSB0aGluayBNVlNBUyBzaG91bGRuJ3QgY2FyZSB0
aGUgY29tcGxldGlvbiBzaWduIGhlcmUsIGp1c3QgbW9kaWZ5IHRhc2sgc3RhdGUgaXMgb2suDQo+
DQo+DQo+DQpbc25pcF0NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogSmlhbnBlbmcgTWEgPG1hamlh
bnBlbmdAZ21haWwuY29tPg0KPj4gLS0tDQo+PiAgZHJpdmVycy9zY3NpL212c2FzL212X3Nhcy5j
IHwgICAgNSArKysrLQ0KPj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9tdnNhcy9tdl9zYXMu
YyBiL2RyaXZlcnMvc2NzaS9tdnNhcy9tdl9zYXMuYw0KPj4gaW5kZXggNDUzOWQ1OS4uYWY2YTFj
NSAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvc2NzaS9tdnNhcy9tdl9zYXMuYw0KPj4gKysrIGIv
ZHJpdmVycy9zY3NpL212c2FzL212X3Nhcy5jDQo+PiBAQCAtMTYyOSw3ICsxNjI5LDEwIEBAIGlu
dCBtdnNfYWJvcnRfdGFzayhzdHJ1Y3Qgc2FzX3Rhc2sgKnRhc2spDQo+PiAgCQkJbXZfZHByaW50
aygibXZzX2Fib3J0X3Rhc2soKSBtdmk9JXAgdGFzaz0lcCAiDQo+PiAgCQkJCSAgICJzbG90PSVw
IHNsb3RfaWR4PXgleFxuIiwNCj4+ICAJCQkJICAgbXZpLCB0YXNrLCBzbG90LCBzbG90X2lkeCk7
DQo+PiAtCQkJbXZzX3RtZl90aW1lZG91dCgodW5zaWduZWQgbG9uZyl0YXNrKTsNCj4+ICsJCQlp
ZiAodGFzay0+c2xvd190YXNrICE9IE5VTEwpDQo+PiArCQkJCW12c190bWZfdGltZWRvdXQoKHVu
c2lnbmVkIGxvbmcpdGFzayk7DQo+PiArCQkJZWxzZQ0KPj4gKwkJCQl0YXNrLT50YXNrX3N0YXRl
X2ZsYWdzIHw9IFNBU19UQVNLX1NUQVRFX0FCT1JURUQ7DQo+PiAgCQkJbXZzX3Nsb3RfdGFza19m
cmVlKG12aSwgdGFzaywgc2xvdCwgc2xvdF9pZHgpOw0KPj4gIAkJCXJjID0gVE1GX1JFU1BfRlVO
Q19DT01QTEVURTsNCj4+ICAJCQlnb3RvIG91dDsNCj4+IC0tDQo+PiAxLjcuOS41DQpUaGFua3Ms
IEknbGwgbW9kaWZ5IHRoZSBjb2RlIGFuZCByZXNlbmQu

