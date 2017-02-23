From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: RE: [PATCH] qla2xxx: fix spelling mistake: "seperator" -> "separator"
Date: Thu, 23 Feb 2017 19:51:47 +0000
Message-ID: <SN1PR0701MB1837726130948221958B51F0F5530@SN1PR0701MB1837.namprd07.prod.outlook.com>
References: <20170223105723.12401-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0078.outbound.protection.outlook.com ([104.47.41.78]:59664
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751457AbdBWTvu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Feb 2017 14:51:50 -0500
In-Reply-To: <20170223105723.12401-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ29saW4gS2luZyBbbWFp
bHRvOmNvbGluLmtpbmdAY2Fub25pY2FsLmNvbV0NCj4gU2VudDogVGh1cnNkYXksIEZlYnJ1YXJ5
IDIzLCAyMDE3IDI6NTcgQU0NCj4gVG86IHFsYTJ4eHgtdXBzdHJlYW1AcWxvZ2ljLmNvbTsgSmFt
ZXMgRSAuIEogLiBCb3R0b21sZXkNCj4gPGplamJAbGludXgudm5ldC5pYm0uY29tPjsgTWFydGlu
IEsgLiBQZXRlcnNlbg0KPiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+OyBsaW51eC1zY3Np
QHZnZXIua2VybmVsLm9yZw0KPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBT
dWJqZWN0OiBbUEFUQ0hdIHFsYTJ4eHg6IGZpeCBzcGVsbGluZyBtaXN0YWtlOiAic2VwZXJhdG9y
IiAtPiAic2VwYXJhdG9yIg0KPiANCj4gRnJvbTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdA
Y2Fub25pY2FsLmNvbT4NCj4gDQo+IHRyaXZpYWwgZml4IHRvIHNwZWxsaW5nIG1pc3Rha2UgaW4g
cHJfZXJyIG1lc3NhZ2UNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxjb2xp
bi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvdGNt
X3FsYTJ4eHguYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBk
ZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3RjbV9x
bGEyeHh4LmMNCj4gYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC90Y21fcWxhMnh4eC5jDQo+IGluZGV4
IGMyZjhjMzUuLjhlOGFiMGYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3Rj
bV9xbGEyeHh4LmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvdGNtX3FsYTJ4eHguYw0K
PiBAQCAtMTc5Miw3ICsxNzkyLDcgQEAgc3RhdGljIHN0cnVjdCBzZV93d24NCj4gKnRjbV9xbGEy
eHh4X25waXZfbWFrZV9scG9ydCgNCj4gDQo+ICAJcCA9IHN0cmNocih0bXAsICdAJyk7DQo+ICAJ
aWYgKCFwKSB7DQo+IC0JCXByX2VycigiVW5hYmxlIHRvIGxvY2F0ZSBOUElWICdAJyBzZXBlcmF0
b3JcbiIpOw0KPiArCQlwcl9lcnIoIlVuYWJsZSB0byBsb2NhdGUgTlBJViAnQCcgc2VwYXJhdG9y
XG4iKTsNCj4gIAkJcmV0dXJuIEVSUl9QVFIoLUVJTlZBTCk7DQo+ICAJfQ0KPiAgCSpwKysgPSAn
XDAnOw0KPiAtLQ0KPiAyLjEwLjINCg0KTG9va3MgR29vZA0KDQpBY2tlZC1ieTogSGltYW5zaHUg
TWFkaGFuaSA8aGltYW5zaHUubWFkaGFuaUBjYXZpdW0uY29tPg0K
