From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] sd: Fix a disk probing hang
Date: Wed, 8 Nov 2017 16:31:34 +0000
Message-ID: <1510158692.24237.11.camel@wdc.com>
References: <20171107173807.14396-1-bart.vanassche@wdc.com>
         <1510078140.3118.18.camel@linux.vnet.ibm.com>
         <1510094539.2656.44.camel@wdc.com>
         <1510095425.3118.62.camel@linux.vnet.ibm.com>
         <cf1f170e-3cf4-bed2-e6a9-2354748e0078@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:35228 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752256AbdKHQbg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 11:31:36 -0500
In-Reply-To: <cf1f170e-3cf4-bed2-e6a9-2354748e0078@suse.com>
Content-Language: en-US
Content-ID: <B15EB5D22AE9BF4BAEBC15DADFF3E73E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>

T24gV2VkLCAyMDE3LTExLTA4IGF0IDA5OjEyICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IFlvdSBrbm93LCB0aGlzIGFjdHVhbGx5IGxvb2tzIGxpa2UgdGhlIHNhbWUgaXNzdWUgSSdt
IGNoYXNpbmcgd2l0aCBpc2VyOw0KPiB3ZSBoYXZlIGEgY3VzdG9tZXIgd2hvIHJlZ3VsYXJseSBz
ZWVzIGxvY2t1cHMgZHVyaW5nIHNjYW5uaW5nLg0KPiBBcyBpdCB0dXJucyBvdXQsIGlzZXIgaXMg
Y2FsbGluZyBzY3NpX2RldmljZV9kZWwoKSBmcm9tIHRoZSBSWCB0aHJlYWQuDQo+IFdoaWNoIGlu
IHR1cm4gbmVlZHMgdG8gY2FsbCBhc3luY19zeW5jaHJvbml6ZSgpLg0KPiBJZiBhIGRpc2sgc2Nh
biBpcyBydW5uaW5nIGF0IHRoZSBzYW1lIHRpbWUgd2UgaGF2ZSBhIG5pY2UgZGVhZGxvY2ssIGFz
DQo+IHRoZSBSWCB0aHJlYWQgY2FuJ3QgbW92ZSBmb3J3YXJkIGJlZm9yZSBheW5jaF9zeW5jaHJv
bml6ZSgpIHJldHVybnMsDQo+IHdoaWNoIGl0J2xsIG5ldmVyIGRvIGFzIHRoZSBzY2FuIGNhbm5v
dCBjb21wbGV0ZS4NCj4gSSd2ZSB0cmllZCB0byBmaXggdGhhdCBieSBoYXZpbmcgdGhlIGFzeW5j
IHByb2Jpbmcgb25seSB3YWl0aW5nIGZvciB0aGF0DQo+IHBhcnRpY3VsYXIgaW5zdGFuY2UgKGxv
b2sgZm9yIHBhdGNoICdzZDogdXNlIGFzeW5jX3Byb2JlIGNvb2tpZSB0byBhdm9pZA0KPiBkZWFk
bG9ja3MnKSwgYnV0IHRoaXMgd2Fzbid0IGdyZWV0ZWQgd2l0aCBtdWNoIGVudGh1c2lhc20uDQoN
CkhlbGxvIEhhbm5lcywNCg0KU2luY2UgSSBhcHBsaWVkIFJvbWFuIFBlbnlhZXYncyBwYXRjaCAi
W1BBVENIIDEvMV0gW1JGQ10gYmxrLW1xOiBmaXggcXVldWUNCnN0YWxsaW5nIG9uIHNoYXJlZCBo
Y3R4IHJlc3RhcnQiIEkgaGF2ZSBub3QgYmVlbiBhYmxlIHRvIHJlcHJvZHVjZSB0aGlzIGhhbmcu
DQpJIHdpbGwgbGV0IHlvdSBrbm93IGlmIEkgd291bGQgcnVuIGludG8gdGhpcyBoYW5nIGFnYWlu
Lg0KDQpCYXJ0Lg==
