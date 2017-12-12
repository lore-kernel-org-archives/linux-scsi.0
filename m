From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] sd: Increase SCSI disk probing concurrency
Date: Tue, 12 Dec 2017 00:16:53 +0000
Message-ID: <1513037811.2747.42.camel@wdc.com>
References: <20171208172124.32685-1-bart.vanassche@wdc.com>
         <c3116e4b-bd48-d72c-52ff-972b9e03fc9a@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:54993 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdLLAQz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Dec 2017 19:16:55 -0500
In-Reply-To: <c3116e4b-bd48-d72c-52ff-972b9e03fc9a@suse.com>
Content-Language: en-US
Content-ID: <094177580C79ED43A9E4F40C62D4574C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>

T24gU3VuLCAyMDE3LTEyLTEwIGF0IDE1OjQ0ICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IFlvdSBrbm93IHdoYXQsIEkgaGF2ZSBiZWVuIHdvcmtpbmcgb24gYSBzaW1pbGFyIHBhdGNo
IGZvciBxdWl0ZSBzb21lDQo+IHRpbWUgbm93OyBbIC4uLiBdDQoNClRoYXQncyB2ZXJ5IGludGVy
ZXN0aW5nIDotKQ0KDQo+IEhvd2V2ZXIsIGluIGRvaW5nIHNvIEkgaGF2ZSBlbmNvdW50ZXJlZCBz
ZXZlcmFsIGlzc3VlcyB3aGljaCBoYXZlIGJlZW4NCj4gZXhwb3NlZCBieSB0aGF0OyB0aGUgbW9z
dCB0cml2aWFsIG9uZSBiZWluZyB0aGF0IGRlbF9nZW5kaXNrKCkgZG9lc24ndA0KPiBjaGVjayBp
ZiBHRU5IRF9GTF9VUCBpcyBzZXQsIHNvIGl0J2xsIGNyYXNoIGlmIHNkX3JlbW92ZSBpcyBjYWxs
ZWQNCj4gYmVmb3JlIHNkX2FzeW5jX3Byb2JlKCkgaXMgcnVuLg0KDQpIYXZlIHlvdSBub3RpY2Vk
IHRoYXQgbXkgcGF0Y2ggYWRkcyBhIGNhbGwgdG8gc2Rfd2FpdF9mb3JfcHJvYmluZygpIGJlZm9y
ZQ0KdGhlIGNhbGwgdG8gZGVsX2dlbmRpc2soKT8gVGhhdCBzaG91bGQgYmUgc3VmZmljaWVudCB0
byBwcmV2ZW50IHRoZSBjcmFzaCB5b3UNCmRlc2NyaWJlZC4NCg0KPiBUaGUgb3RoZXIgb25lIGlz
IGFuIGltYmFsYW5jZSBiZXR3ZWVuIHNkX3Byb2JlIGFuZCBzZF9yZW1vdmU7DQo+IHdoZW4gc2Rf
cHJvYmVfYXN5bmMoKSBpcyBjYWxsZWQgX2FmdGVyXyBzY3NpX2RldmljZV9yZW1vdmVfZGV2aWNl
KCkNCj4gKHdoaWNoIGl0IHdpbGwgYXMgdGhlIHN5bmNocm9uaXphdGlvbiBpcyBvbmx5IGFmdGVy
IGRldmljZV9kZWwoKSBoYXMNCj4gYmVlbiBjYWxsZWQpIGl0IHdpbGwgdHJpcCBvdmVyIG5vbi1l
eGlzdGVudCBzeXNmcyBkaXJlY3RvcmllcyBpbiBhZGRfZGlzaygpLg0KPiBTbyBvbmUgbmVlZCB0
byBzaG9ydC1jaXJjdWl0IHNkX3Byb2JlX2FzeW5jKCkgZm9yIGRldmljZXMgaW4gU0RFVl9DQU5D
RUwNCj4gb3IgU0RFVl9ERUwuDQoNClNhbWUgY29tbWVudCBoZXJlIC0gSSB0aGluayB0aGUgc2Rf
d2FpdF9mb3JfcHJvYmluZygpIGNhbGwgSSBpbnNlcnRlZCBpbg0Kc2RfcmVtb3ZlKCkgc2hvdWxk
IHByZXZlbnQgdGhpcyBzY2VuYXJpby4NCg0KPiBIb3dldmVyLCBJJ20gc3RpbGwgd2FpdGluZyBm
b3IgYSBmaW5hbCBjb25maXJtYXRpb24gb24gdGhlIGxhdHRlciBpc3N1ZSwNCj4gaGVuY2UgSSBo
YXZlbid0IHBvc3RlZCB0aGUgcGF0Y2hzZXQuDQo+IElmIHRoZXJlJ3MgaW50ZXJlc3QgSSBjYW4g
cG9zdCB0aGVtLCB0aG91Z2guDQoNClRoZSBiaWcgcXVlc3Rpb24gaGVyZSBpcyBob3cgeW91IHdv
dWxkIGxpa2UgdG8gcHJvY2VlZCAtIHNob3VsZCB3ZSBzdGFydCBmcm9tDQp5b3VyIHBhdGNoIHNl
cmllcyBvciBzdGFydCBmcm9tIG15IHBhdGNoPyBTaW5jZSBJIGhhdmUgbm90IGVuY291bnRlcmVk
IGFueSBvZg0KdGhlIGlzc3VlcyB5b3UgZGVzY3JpYmVkIHdpdGggbXkgcGF0Y2gsIGRvZXMgdGhh
dCBtZWFuIHRoYXQgdGhlIGFwcHJvYWNoIEkNCmZvbGxvd2VkIHJlc3VsdHMgaW4gbW9yZSByZWxp
YWJsZSBvcGVyYXRpb24/DQoNClRoYW5rcywNCg0KQmFydC4=
