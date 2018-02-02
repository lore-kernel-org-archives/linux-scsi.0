From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v4 08/10] ufs: sysfs: unit descriptor
Date: Fri, 2 Feb 2018 00:38:25 +0000
Message-ID: <1517531903.2746.33.camel@wdc.com>
References: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
         <1517501746-19075-9-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:18957 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751660AbeBBAi1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2018 19:38:27 -0500
In-Reply-To: <1517501746-19075-9-git-send-email-stanislav.nijnikov@wdc.com>
Content-Language: en-US
Content-ID: <D35FB941F90F194780601E34F8982D41@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Cc: Alex Lemberg <Alex.Lemberg@wdc.com>

T24gVGh1LCAyMDE4LTAyLTAxIGF0IDE4OjE1ICswMjAwLCBTdGFuaXNsYXYgTmlqbmlrb3Ygd3Jv
dGU6DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2NzaV9zeXNmcy5jIGIvZHJpdmVycy9z
Y3NpL3Njc2lfc3lzZnMuYw0KPiBpbmRleCBjYmMwZmUyLi42OWE2YTFmIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL3Njc2kvc2NzaV9zeXNmcy5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9zY3NpX3N5
c2ZzLmMNCj4gQEAgLTEzMDksNiArMTMwOSwxNCBAQCBpbnQgc2NzaV9zeXNmc19hZGRfc2Rldihz
dHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYpDQo+ICAJCX0NCj4gIAl9DQo+ICANCj4gKwlpZiAoc2Rl
di0+aG9zdC0+aG9zdHQtPnNkZXZfZ3JvdXBzKSB7DQo+ICsJCWVycm9yID0gc3lzZnNfY3JlYXRl
X2dyb3Vwcygmc2Rldi0+c2Rldl9nZW5kZXYua29iaiwNCj4gKwkJCShjb25zdCBzdHJ1Y3QgYXR0
cmlidXRlX2dyb3VwICoqKQ0KPiArCQkJc2Rldi0+aG9zdC0+aG9zdHQtPnNkZXZfZ3JvdXBzKTsN
Cj4gKwkJCWlmIChlcnJvcikNCj4gKwkJCQlyZXR1cm4gZXJyb3I7DQo+ICsJfQ0KPiArDQo+ICAJ
c2NzaV9hdXRvcG1fcHV0X2RldmljZShzZGV2KTsNCj4gIAlyZXR1cm4gZXJyb3I7DQo+ICB9DQo+
IEBAIC0xMzI2LDYgKzEzMzQsMTIgQEAgdm9pZCBfX3Njc2lfcmVtb3ZlX2RldmljZShzdHJ1Y3Qg
c2NzaV9kZXZpY2UgKnNkZXYpDQo+ICAJaWYgKHNkZXYtPnNkZXZfc3RhdGUgPT0gU0RFVl9ERUwp
DQo+ICAJCXJldHVybjsNCj4gIA0KPiArCWlmIChzZGV2LT5ob3N0LT5ob3N0dC0+c2Rldl9ncm91
cHMpIHsNCj4gKwkJc3lzZnNfcmVtb3ZlX2dyb3Vwcygmc2Rldi0+c2Rldl9nZW5kZXYua29iaiwN
Cj4gKwkJCShjb25zdCBzdHJ1Y3QgYXR0cmlidXRlX2dyb3VwICoqKQ0KPiArCQkJc2Rldi0+aG9z
dC0+aG9zdHQtPnNkZXZfZ3JvdXBzKTsNCj4gKwl9DQo+ICsNCj4gIAlpZiAoc2Rldi0+aXNfdmlz
aWJsZSkgew0KPiAgCQkvKg0KPiAgCQkgKiBJZiBzY3NpX2ludGVybmFsX3RhcmdldF9ibG9jaygp
IGlzIHJ1bm5pbmcgY29uY3VycmVudGx5LA0KDQpQbGVhc2Ugc3BsaXQgdGhpcyBwYXRjaCBpbnRv
IHR3byBwYXRjaGVzLCBuYW1lbHkgb25lIHBhdGNoIHRoYXQgaW50cm9kdWNlcw0KdGhlIHNkZXZf
Z3JvdXBzIGF0dHJpYnV0ZSBpbiB0aGUgU0NTSSBjb3JlIGFuZCBhIHNlY29uZCBwYXRjaCB0aGF0
IGRvZXMgbm90DQptb2RpZnkgdGhlIFNDU0kgY29yZSBidXQgb25seSB0aGUgVUZTIGRyaXZlci4g
VGhhdCB3aWxsIG1ha2UgdGhlc2UgY2hhbmdlcw0KZWFzaWVyIHRvIHJldmlldy4NCg0KQWRkaXRp
b25hbGx5LCBpdCBzZWVtcyB3cm9uZyB0byBtZSB0byBjYXN0IHRoZSB0aGlyZCBhcmd1bWVudCBv
Zg0Kc3lzZnNfY3JlYXRlX2dyb3VwcygpIGFuZCBzeXNmc19yZW1vdmVfZ3JvdXBzKCkgZnJvbSBh
IG5vbi1jb25zdCB0byBhIGNvbnN0DQpwb2ludGVyLiBQbGVhc2UgY29uc2lkZXIgdG8gZGVjbGFy
ZSB0aGUgc2Rldl9ncm91cHMgbWVtYmVyIGNvbnN0IGFuZCBhbHNvDQp0aGUgY29ycmVzcG9uZGlu
ZyBkYXRhIHN0cnVjdHVyZXMgaW4gdGhlIFVGUyBkcml2ZXIuDQoNClRoYW5rcywNCg0KQmFydC4=
