From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [scsi:for-next 92/128] drivers/scsi/qla2xxx/qla_isr.c:1684:56:
 warning: 'rval' may be used uninitialized in this function
Date: Mon, 17 Sep 2012 12:35:08 +0000
Message-ID: <1347885307.2397.21.camel@dabdike.int.hansenpartnership.com>
References: <20120914235728.GA32759@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([64.131.90.16]:39990 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162Ab2IQMfQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Sep 2012 08:35:16 -0400
In-Reply-To: <20120914235728.GA32759@localhost>
Content-Language: en-US
Content-ID: <ED1407B88A3868488B55F20547FDC39A@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>, Yuanhan Liu <yuanhan.liu@intel.com>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

T24gU2F0LCAyMDEyLTA5LTE1IGF0IDA3OjU3ICswODAwLCBGZW5nZ3VhbmcgV3Ugd3JvdGU6DQo+
IEhpIFNhdXJhdiwNCj4gDQo+IEZZSSwgdGhlcmUgYXJlIG5ldyBjb21waWxlIHdhcm5pbmdzIHNo
b3cgdXAgaW4NCj4gDQo+IHRyZWU6ICAgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L2plamIvc2NzaS5naXQgZm9yLW5leHQNCj4gaGVhZDogICA3MWNmZmY0YWYw
NTI1ODkxOTQxMTk5YjE0MmI3NTlkMDBiMjkzOTU5DQo+IGNvbW1pdDogMzg3ZmRkYWEzNTY0NTAz
YzlmODJkMDkxZDJlYmUzOTBmM2FmNjJhMSBbOTIvMTI4XSBbU0NTSV0gcWxhMnh4eDogSW1wbGVt
ZW50YXRpb24gb2YgYmlkaXJlY3Rpb25hbC4NCj4gY29uZmlnOiB4ODZfNjQtYWxsbW9kY29uZmln
DQo+IA0KPiBBbGwgZXJyb3Ivd2FybmluZ3M6DQo+IA0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9x
bGFfaXNyLmM6IEluIGZ1bmN0aW9uICdxbGEyeDAwX3N0YXR1c19lbnRyeSc6DQo+IGRyaXZlcnMv
c2NzaS9xbGEyeHh4L3FsYV9pc3IuYzoxNjg0OjU2OiB3YXJuaW5nOiAncnZhbCcgbWF5IGJlIHVz
ZWQgdW5pbml0aWFsaXplZCBpbiB0aGlzIGZ1bmN0aW9uIFstV21heWJlLXVuaW5pdGlhbGl6ZWRd
DQo+IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYzoxNTU4OjExOiBub3RlOiAncnZhbCcg
d2FzIGRlY2xhcmVkIGhlcmUNCg0KSG1tLCB0aGF0J3MgYWN0dWFsbHkgZml4ZWQgYnkgYSBsYXRl
ciBwYXRjaCBpbiB0aGUgc2VyaWVzOg0KDQpjb21taXQgMmQ3YTdkYzliZjQ3NzJiNmVkNzExY2Fk
ZWVlMGJjZTliYWNlMmE5NA0KQXV0aG9yOiBTYXVyYXYgS2FzaHlhcCA8c2F1cmF2Lmthc2h5YXBA
cWxvZ2ljLmNvbT4NCkRhdGU6ICAgV2VkIEF1ZyAyMiAxNDoyMToxMiAyMDEyIC0wNDAwDQoNCiAg
ICBbU0NTSV0gcWxhMnh4eDogRml4IHJ2YWwgbWF5IGJlIHVzZWQgdW5pbml0aWFsaXplZCBpbiB0
aGlzIGZ1bmN0aW9uDQp3YXJuaW5nLg0KDQpOb3RlIHRvIHFsb2dpYzogcGxlYXNlIGRvbid0IGRv
IHRoaXMgaW4gZnV0dXJlLiAgSSdsbCBjb21iaW5lIHRoZXNlIHR3bw0KcGF0Y2hlcyBzbyB3ZSBn
ZXQgYSBzaW5nbGUgc2VyaWVzIHdpdGggbm8gaW50cm9kdWNlZCBhbmQgbGF0ZXIgZml4ZWQNCndh
cm5pbmdzLg0KDQpKYW1lcw0KDQo=
