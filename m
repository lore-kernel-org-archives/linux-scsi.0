From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v2 2/5] qla2xxx: Fix mailbox command timeout due to
 starvation
Date: Thu, 1 Dec 2016 16:47:57 +0000
Message-ID: <0B0C0879-3FF0-4ED9-9D0A-C1D2E47E384A@cavium.com>
References: <1480537497-16429-1-git-send-email-himanshu.madhani@cavium.com>
 <1480537497-16429-3-git-send-email-himanshu.madhani@cavium.com>
 <edb6a523-beb0-04df-8dfc-18d7b1a77ff6@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0065.outbound.protection.outlook.com ([104.47.38.65]:38801
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932760AbcLARC3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Dec 2016 12:02:29 -0500
In-Reply-To: <edb6a523-beb0-04df-8dfc-18d7b1a77ff6@suse.de>
Content-Language: en-US
Content-ID: <4DCD9552ED1B7E4986EA3CE6EF912B44@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

DQpPbiAxMS8zMC8xNiwgMTE6NTggUE0sICJIYW5uZXMgUmVpbmVja2UiIDxoYXJlQHN1c2UuZGU+
IHdyb3RlOg0KDQo+T24gMTEvMzAvMjAxNiAwOToyNCBQTSwgSGltYW5zaHUgTWFkaGFuaSB3cm90
ZToNCj4+IEZyb206IFNhbXkgPHNhbXlAcHVyZXN0b3JhZ2UuY29tPg0KPj4gDQo+PiBTaWduZWQt
b2ZmLWJ5OiBTYW15IDxzYW15QHB1cmVzdG9yYWdlLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IEhp
bWFuc2h1IE1hZGhhbmkgPGhpbWFuc2h1Lm1hZGhhbmlAY2F2aXVtLmNvbT4NCj4+IC0tLQ0KPj4g
IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kZWYuaCB8ICAzICsrDQo+PiAgZHJpdmVycy9zY3Np
L3FsYTJ4eHgvcWxhX21ieC5jIHwgODggKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0tLS0tDQo+PiAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMgIHwgMjQgKysrKysr
KysrKysrDQo+PiAgMyBmaWxlcyBjaGFuZ2VkLCA5MSBpbnNlcnRpb25zKCspLCAyNCBkZWxldGlv
bnMoLSkNCj4+IA0KPlRoaXMgY291bGQgZG8gd2l0aCBhIHNvbWUgZGVzY3JpcHRpb24uDQoNClRo
YW5rcyBmb3IgdGhlIHJldmlldy4gV2lsbCBhZGQgbW9yZSBkZXNjcmlwdGlvbiB3aGVuIHN1Ym1p
dHRpbmcgcmV2aXNlZCBzZXJpZXMuIA0KDQo+DQo+T3RoZXJ3aXNlOg0KPg0KPlJldmlld2VkLWJ5
OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5jb20+DQo+DQo+Q2hlZXJzDQo+DQo+SGFubmVz
DQo+LS0gDQo+RHIuIEhhbm5lcyBSZWluZWNrZQkJICAgVGVhbWxlYWQgU3RvcmFnZSAmIE5ldHdv
cmtpbmcNCj5oYXJlQHN1c2UuZGUJCQkgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OA0K
PlNVU0UgTElOVVggR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnDQo+R0Y6IEYu
IEltZW5kw7ZyZmZlciwgSi4gU21pdGhhcmQsIEouIEd1aWxkLCBELiBVcG1hbnl1LCBHLiBOb3J0
b24NCj5IUkIgMjEyODQgKEFHIE7DvHJuYmVyZykNCg==
