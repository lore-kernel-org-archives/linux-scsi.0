From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCHv4 2/5] scsi: Export blacklist flags to sysfs
Date: Wed, 30 Aug 2017 15:39:03 +0000
Message-ID: <1504107541.2526.11.camel@wdc.com>
References: <1503996564-110464-1-git-send-email-hare@suse.de>
         <1503996564-110464-3-git-send-email-hare@suse.de>
         <1504022564.2653.12.camel@wdc.com>
         <9e7eb07d-7796-ace6-ee04-d88e22e730b0@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:46663 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdH3Pjw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 11:39:52 -0400
In-Reply-To: <9e7eb07d-7796-ace6-ee04-d88e22e730b0@suse.de>
Content-Language: en-US
Content-ID: <80199660000EAB46A0782BB1A7A5F1D1@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "Alan@suse.de" <Alan@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>

T24gV2VkLCAyMDE3LTA4LTMwIGF0IDEyOjUwICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IE9uIDA4LzI5LzIwMTcgMDY6MDIgUE0sIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPiBP
biBUdWUsIDIwMTctMDgtMjkgYXQgMTA6NDkgKzAyMDAsIEhhbm5lcyBSZWluZWNrZSB3cm90ZToN
Cj4gPiA+ICt9IHNkZXZfYmZsYWdzW10gPSB7DQo+ID4gPiArI2luY2x1ZGUgInNjc2lfZGV2aW5m
b190YmwuYyINCj4gPiA+ICt9Ow0KPiA+ID4gKw0KPiA+ID4gK3N0YXRpYyBjb25zdCBjaGFyICpz
ZGV2X2JmbGFnc19uYW1lKHVuc2lnbmVkIGludCBiZmxhZ3MpDQo+ID4gPiArew0KPiA+ID4gKwlp
bnQgaTsNCj4gPiA+ICsJY29uc3QgY2hhciAqbmFtZSA9IE5VTEw7DQo+ID4gPiArDQo+ID4gPiAr
CWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHNkZXZfYmZsYWdzKTsgaSsrKSB7DQo+ID4gPiAr
CQlpZiAoc2Rldl9iZmxhZ3NbaV0udmFsdWUgPT0gYmZsYWdzKSB7DQo+ID4gPiArCQkJbmFtZSA9
IHNkZXZfYmZsYWdzW2ldLm5hbWU7DQo+ID4gPiArCQkJYnJlYWs7DQo+ID4gPiArCQl9DQo+ID4g
PiArCX0NCj4gPiA+ICsJcmV0dXJuIG5hbWU7DQo+ID4gPiArfQ0KPiA+IA0KPiA+IEhvdyBhYm91
dCB1c2luZyBpbG9nMigpIG9mIHRoZSBCTElTVF8qIHZhbHVlcyBhcyBpbmRleCBvZiB0aGUgdGFi
bGUgc3VjaCB0aGF0DQo+ID4gYW4gYXJyYXkgbG9va3VwIGNhbiBiZSB1c2VkIGluc3RlYWQgb2Yg
YSBmb3ItbG9vcCBvdmVyIHRoZSBlbnRpcmUgYXJyYXk/DQo+IA0KPiBOb3Qgc3VyZSBpZiB0aGF0
J2xsIHdvcmsuIFRoZSBCTElTVF8qIHZhbHVlcyBpbiBmYWN0IGZvcm0gYSBzcGFyc2UNCj4gYXJy
YXksIHNvIHRoZSBsb29rdXAgYXJyYXkgJ3NkZXZfYmZsYWdzJyBhY3R1YWxseSBhbiBhc3NvY2lh
dGl2ZSBhcnJheS4NCj4gQW5kIEkgZGFyZSBub3QgY29udmVydCBpdCB0byBhIG5vcm1hbCBhcnJh
eSBhcyB0aGVuIEkgY291bGRuJ3QgdG8gdGhlDQo+IGF1dG9tYXRpY2UgdGFibGUgY3JlYXRpb24g
YW55bW9yZS4NCj4gDQo+IFNvIEknbSBub3Qgc3VyZSBpZiBpbG9nMiB3aWxsIHNhdmUgbWUgYW55
dGhpbmcgaGVyZS4NCg0KSGVsbG8gSGFubmVzLA0KDQpBcmUgeW91IGF3YXJlIHRoYXQgdGhlcmUg
aXMgYWxyZWFkeSBjb2RlIHVwc3RyZWFtIGZvciBjb252ZXJ0aW5nIGEgYml0bWFzaw0KaW50byBh
IGxpc3Qgb2YgbmFtZXMgb2YgZmxhZ3MgdGhhdCBzdXBwb3J0cyBzcGFyc2UgYml0IGRlZmluaXRp
b25zPyBGcm9tDQpibG9jay9ibGstbXEtZGVidWdmcy5jOg0KDQojZGVmaW5lIEhDVFhfRkxBR19O
QU1FKG5hbWUpIFtpbG9nMihCTEtfTVFfRl8jI25hbWUpXSA9ICNuYW1lDQpzdGF0aWMgY29uc3Qg
Y2hhciAqY29uc3QgaGN0eF9mbGFnX25hbWVbXSA9IHsNCglIQ1RYX0ZMQUdfTkFNRShTSE9VTERf
TUVSR0UpLA0KCUhDVFhfRkxBR19OQU1FKFRBR19TSEFSRUQpLA0KCUhDVFhfRkxBR19OQU1FKFNH
X01FUkdFKSwNCglIQ1RYX0ZMQUdfTkFNRShCTE9DS0lORyksDQoJSENUWF9GTEFHX05BTUUoTk9f
U0NIRUQpLA0KfTsNCiN1bmRlZiBIQ1RYX0ZMQUdfTkFNRQ0KDQpzdGF0aWMgaW50IGJsa19mbGFn
c19zaG93KHN0cnVjdCBzZXFfZmlsZSAqbSwgY29uc3QgdW5zaWduZWQgbG9uZyBmbGFncywNCgkJ
CSAgY29uc3QgY2hhciAqY29uc3QgKmZsYWdfbmFtZSwgaW50IGZsYWdfbmFtZV9jb3VudCkNCnsN
Cglib29sIHNlcCA9IGZhbHNlOw0KCWludCBpOw0KDQoJZm9yIChpID0gMDsgaSA8IHNpemVvZihm
bGFncykgKiBCSVRTX1BFUl9CWVRFOyBpKyspIHsNCgkJaWYgKCEoZmxhZ3MgJiBCSVQoaSkpKQ0K
CQkJY29udGludWU7DQoJCWlmIChzZXApDQoJCQlzZXFfcHV0cyhtLCAifCIpOw0KCQlzZXAgPSB0
cnVlOw0KCQlpZiAoaSA8IGZsYWdfbmFtZV9jb3VudCAmJiBmbGFnX25hbWVbaV0pDQoJCQlzZXFf
cHV0cyhtLCBmbGFnX25hbWVbaV0pOw0KCQllbHNlDQoJCQlzZXFfcHJpbnRmKG0sICIlZCIsIGkp
Ow0KCX0NCglyZXR1cm4gMDsNCn0NCg0KWyAuLi4gXQ0KCWJsa19mbGFnc19zaG93KG0sIGhjdHgt
PmZsYWdzIF4gQkxLX0FMTE9DX1BPTElDWV9UT19NUV9GTEFHKGFsbG9jX3BvbGljeSksDQoJCSAg
ICAgICBoY3R4X2ZsYWdfbmFtZSwgQVJSQVlfU0laRShoY3R4X2ZsYWdfbmFtZSkpOw0KWyAuLi4g
XQ0KDQpCYXJ0Lg==
