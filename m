From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 30 Jan 2018 03:37:38 +0000
Message-ID: <1517283456.12842.2.camel@wdc.com>
References: <1516724659.3339.7.camel@sandisk.com>
         <20180123163717.GE13277@ming.t460p> <1516726653.3339.20.camel@wdc.com>
         <20180124033109.GA15945@ming.t460p> <20180127190920.GA24759@redhat.com>
         <1517091161.3055.7.camel@wdc.com> <20180127234151.GA21710@ming.t460p>
         <1517244510.2687.10.camel@wdc.com> <20180130010701.GC17176@ming.t460p>
         <1517274681.2687.68.camel@wdc.com> <20180130033118.GF17176@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:56969 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752076AbeA3Dhm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2018 22:37:42 -0500
In-Reply-To: <20180130033118.GF17176@ming.t460p>
Content-Language: en-US
Content-ID: <EE6312B26A5C5744AAD68C6F2D393891@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

T24gVHVlLCAyMDE4LTAxLTMwIGF0IDExOjMxICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gUGxl
YXNlIHRha2UgYSBsb29rIGF0IGRyaXZlcnMsIHdoZW4gQkxLX1NUU19SRVNPVVJDRSBpcyByZXR1
cm5lZCwgd2hvDQo+IHdpbGwgY2FsbCBibGtfbXFfZGVsYXlfcnVuX2h3X3F1ZXVlKCkgZm9yIGRy
aXZlcnM/DQoNCkFzIHlvdSBrbm93IHRoZSBTQ1NJIGFuZCBkbSBkcml2ZXJzIGluIGtlcm5lbCB2
NC4xNSBhbHJlYWR5IGNhbGwgdGhhdCBmdW5jdGlvbg0Kd2hlbmV2ZXIgbmVjZXNzYXJ5Lg0KDQo+
ID4gDQo+ID4gPiBbIC4uLiBdIExhdGVyLCB5b3UgYWRtaXR0ZWQgeW91IHVuZGVyc3Rvb2QgdGhl
IHBhdGNoIHdyb25nLiBbIC4uLiBdDQo+ID4gDQo+ID4gVGhhdCdzIG5vbnNlbnNlLiBJIG5ldmVy
IHdyb3RlIHRoYXQuDQo+IA0KPiBCZWxpZXZlIGl0IG9yIG5vdCwgZm9sbG93cyB0aGUgbGluayBh
bmQgeW91ciByZXBseToNCj4gDQo+IAlodHRwczovL21hcmMuaW5mby8/bD1kbS1kZXZlbCZtPTE1
MTY3MjY5NDUwODM4OSZ3PTINCj4gDQo+ID4gU28gd2hhdCBpcyB3cm9uZyB3aXRoIHRoaXMgd2F5
Pw0KPiA+IFNvcnJ5LCBJIHN3YXBwZWQgQkxLX1NUU19ERVZfUkVTT1VSQ0UgYW5kIEJMS19TVFNf
UkVTT1VSQ0UgYWNjaWRlbnRhbGx5IGluIG15DQo+ID4gcmVwbHkuIFdoYXQgSSBtZWFudCBpcyB0
aGF0IGNoYW5naW5nIGEgYmxrX21xX2RlbGF5X3J1bl9od19xdWV1ZSgpIGNhbGwgZm9sbG93ZWQN
Cj4gPiBieSByZXR1cm4gQkxLX1NUU19SRVNPVVJDRSBpbnRvIEJMS19TVFNfREVWX1JFU09VUkNF
IGlzIHdyb25nIGFuZCBpbnRyb2R1Y2VzIGENCj4gPiByYWNlIGNvbmRpdGlvbiBpbiBjb2RlIHdo
ZXJlIHRoZXJlIHdhcyBubyByYWNlIGNvbmRpdGlvbi4NCg0KVGhhdCBtZWFudCB0aGF0IEkgbWFk
ZSBhIG1pc3Rha2UgKHR5cG8pIHdoaWxlIHR5cGluZyB0aGUgcmVwbHkgYW5kIG5vdGhpbmcgZWxz
ZS4NCg0KQmFydC4=
