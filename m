From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v4 02/10] ufs: sysfs: device descriptor
Date: Fri, 2 Feb 2018 00:29:39 +0000
Message-ID: <1517531378.2746.29.camel@wdc.com>
References: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
         <1517501746-19075-3-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:63665 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751472AbeBBA3n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2018 19:29:43 -0500
In-Reply-To: <1517501746-19075-3-git-send-email-stanislav.nijnikov@wdc.com>
Content-Language: en-US
Content-ID: <90F8E70C8986BD41A1B856938504C18E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Cc: Alex Lemberg <Alex.Lemberg@wdc.com>

T24gVGh1LCAyMDE4LTAyLTAxIGF0IDE4OjE1ICswMjAwLCBTdGFuaXNsYXYgTmlqbmlrb3Ygd3Jv
dGU6DQo+ICtzc2l6ZV90IHVmc19zeXNmc19yZWFkX2Rlc2NfcGFyYW0oc3RydWN0IHVmc19oYmEg
KmhiYSwNCj4gKwkJCQkgIGVudW0gZGVzY19pZG4gZGVzY19pZCwNCj4gKwkJCQkgIHU4IGRlc2Nf
aW5kZXgsDQo+ICsJCQkJICB1OCBwYXJhbV9vZmZzZXQsDQo+ICsJCQkJICB1OCAqc3lzZnNfYnVm
LA0KPiArCQkJCSAgdTggcGFyYW1fc2l6ZSkNCj4gK3sNCj4gKwl1OCBkZXNjX2J1ZltVRlNfUEFS
QU1fUVdPUkRfU0laRV0gPSB7MH07DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCWlmIChwYXJhbV9z
aXplID4gVUZTX1BBUkFNX1FXT1JEX1NJWkUpDQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiArDQo+
ICsJcmV0ID0gdWZzaGNkX3JlYWRfZGVzY19wYXJhbShoYmEsIGRlc2NfaWQsIGRlc2NfaW5kZXgs
DQo+ICsJCQkJcGFyYW1fb2Zmc2V0LCBkZXNjX2J1ZiwgcGFyYW1fc2l6ZSk7DQo+ICsJaWYgKHJl
dCkNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ICsJc3dpdGNoIChwYXJhbV9zaXplKSB7DQo+ICsJ
Y2FzZSBVRlNfUEFSQU1fQllURV9TSVpFOg0KPiArCQlyZXQgPSBzcHJpbnRmKHN5c2ZzX2J1Ziwg
IjB4JTAyWFxuIiwgKmRlc2NfYnVmKTsNCj4gKwkJYnJlYWs7DQo+ICsJY2FzZSBVRlNfUEFSQU1f
V09SRF9TSVpFOg0KPiArCQlyZXQgPSBzcHJpbnRmKHN5c2ZzX2J1ZiwgIjB4JTA0WFxuIiwNCj4g
KwkJCWJlMTZfdG9fY3B1KCooKHUxNiAqKWRlc2NfYnVmKSkpOw0KPiArCQlicmVhazsNCj4gKwlj
YXNlIFVGU19QQVJBTV9EV09SRF9TSVpFOg0KPiArCQlyZXQgPSBzcHJpbnRmKHN5c2ZzX2J1Ziwg
IjB4JTA4WFxuIiwNCj4gKwkJCWJlMzJfdG9fY3B1KCooKHUzMiAqKWRlc2NfYnVmKSkpOw0KPiAr
CQlicmVhazsNCj4gKwljYXNlIFVGU19QQVJBTV9RV09SRF9TSVpFOg0KPiArCQlyZXQgPSBzcHJp
bnRmKHN5c2ZzX2J1ZiwgIjB4JTAxNmxsWFxuIiwNCj4gKwkJCWJlNjRfdG9fY3B1KCooKHU2NCAq
KWRlc2NfYnVmKSkpOw0KPiArCQlicmVhazsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gcmV0Ow0K
PiArfQ0KDQpTZWVpbmcgY29kZSBsaWtlIHRoaXMgbWFrZXMgbWUgd29uZGVyIHdoZXRoZXIgdGhp
cyBwYXRjaCBzZXJpZXMgaGFzIGJlZW4gdmVyaWZpZWQNCndpdGggc3BhcnNlPyBJIHRoaW5rIHNw
YXJzZSB3aWxsIGNvbXBsYWluIGFib3V0IGFsbCB0aHJlZSBiZSpfdG9fY3B1KCkgY2FzdHMgYWJv
dmUuDQpQbGVhc2UgdXNlIGdldF91bmFsaWduZWRfYmUqKCkgaW5zdGVhZCBvZiBvcGVuLWNvZGlu
ZyB0aGVzZSBmdW5jdGlvbnMuDQoNClRoYW5rcywNCg0KQmFydC4=
