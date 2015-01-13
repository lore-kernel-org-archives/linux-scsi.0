From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/9] scsi: Implement per-cpu logging buffer
Date: Tue, 13 Jan 2015 18:41:28 +0000
Message-ID: <1421174520.2076.15.camel@parallels.com>
References: <1420699430-9492-1-git-send-email-hare@suse.de>
	 <1420699430-9492-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:58643 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbAMSmG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jan 2015 13:42:06 -0500
In-Reply-To: <1420699430-9492-2-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <167537669C94064C91F0FDCB69BC873B@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

T24gVGh1LCAyMDE1LTAxLTA4IGF0IDA3OjQzICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IC0Jc2Rldl9wcmludGsocHJlZml4LCAoc2NtZCktPmRldmljZSwgZm10LCAjI2EpDQo+ICtl
eHRlcm4gaW50IHNkZXZfcHJlZml4X3ByaW50ayhjb25zdCBjaGFyICosIGNvbnN0IHN0cnVjdCBz
Y3NpX2RldmljZSAqLA0KPiArCQkJICAgICAgY29uc3QgY2hhciAqLCBjb25zdCBjaGFyICosIC4u
Lik7DQo+ICsNCj4gKyNkZWZpbmUgc2Rldl9wcmludGsobCwgc2RldiwgZm10LCBhLi4uKQkJCQlc
DQo+ICsJc2Rldl9wcmVmaXhfcHJpbnRrKGwsIHNkZXYsIE5VTEwsIGZtdCwgIyNhKQ0KPiArDQo+
ICtleHRlcm4gaW50IHNjbWRfcHJpbnRrKGNvbnN0IGNoYXIgKiwgY29uc3Qgc3RydWN0IHNjc2lf
Y21uZCAqLA0KPiArCQkgICAgICAgY29uc3QgY2hhciAqLCAuLi4pOw0KPiAgDQo+ICAjZGVmaW5l
IHNjbWRfZGJnKHNjbWQsIGZtdCwgYS4uLikJCQkJCSAgIFwNCj4gIAlkbyB7CQkJCQkJCQkgICBc
DQoNClRoZXNlIG5ldyBwcm90b3R5cGVzIG5lZWQgdG8gYmUgcHJpbnRmIGZvcm1hdCBjaGVja2Vk
LCBvdGhlcndpc2UgeW91DQpsb3NlIHVzIHNvbWUgdHlwZSBjaGVja2luZyB0aGF0IGdjYyB3YXMg
ZG9pbmc6DQoNCmV4dGVybiBfX3ByaW50Zig0LCA1KQ0KaW50IHNkZXZfcHJlZml4X3ByaW50ayhj
b25zdCBjaGFyICosIGNvbnN0IHN0cnVjdCBzY3NpX2RldmljZSAqLA0KCQkgICAgICBjb25zdCBj
aGFyICosIGNvbnN0IGNoYXIgKiwgLi4uKTsNCg0KSmFtZXMNCg0K
