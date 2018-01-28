From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Sun, 28 Jan 2018 17:03:49 +0000
Message-ID: <1517159028.3141.17.camel@wdc.com>
References: <20180123161613.14214-1-ming.lei@redhat.com>
         <1516724659.3339.7.camel@sandisk.com> <20180123163717.GE13277@ming.t460p>
         <1516726653.3339.20.camel@wdc.com> <20180124033109.GA15945@ming.t460p>
         <20180127190920.GA24759@redhat.com> <1517091161.3055.7.camel@wdc.com>
         <20180128002356.GA25933@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:8871 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbeA1RDy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jan 2018 12:03:54 -0500
In-Reply-To: <20180128002356.GA25933@redhat.com>
Content-Language: en-US
Content-ID: <497C290867788E40A76514C2E07C6C67@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

T24gU2F0LCAyMDE4LTAxLTI3IGF0IDE5OjIzIC0wNTAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IE9uIFNhdCwgSmFuIDI3IDIwMTggYXQgIDU6MTJwbSAtMDUwMCwNCj4gQmFydCBWYW4gQXNzY2hl
IDxCYXJ0LlZhbkFzc2NoZUB3ZGMuY29tPiB3cm90ZToNCj4gPiAtIFRoZSBwYXRjaCBhdCB0aGUg
c3RhcnQgb2YgdGhpcyB0aHJlYWQgaW50cm9kdWNlcyBhIHJlZ3Jlc3Npb24gaW4gdGhlDQo+ID4g
ICBTQ1NJIGNvcmUsIG5hbWVseSBhIHF1ZXVlIHN0YWxsIGlmIGEgcmVxdWVzdCBjb21wbGV0aW9u
IG9jY3VycyBjb25jdXJyZW50bHkNCj4gPiAgIHdpdGggdGhlIG5ld2x5IGFkZGVkIEJMS19NUV9T
X1NDSEVEX1JFU1RBUlQgdGVzdCBpbiB0aGUgYmxrLW1xIGNvcmUuDQo+IA0KPiBBbmQgd2h5IGlz
IHRoaXMgc3VwcG9zZWQgcmFjZSB1bmlxdWUgdG8gU0NTSSBjb3JlPyAgDQoNClRoYXQgcmFjZSBp
cyBub3QgdW5pcXVlIHRvIHRoZSBTQ1NJIGNvcmUuIEl0IGlzIHBvc3NpYmxlIHRoYXQgdGhlIHBh
dGNoIGF0DQp0aGUgc3RhcnQgb2YgdGhpcyB0aHJlYWQgaW50cm9kdWNlcyB0aGUgc2FtZSByYWNl
IGluIG90aGVyIGJsb2NrIGRyaXZlcnMNCmJ1dCBJIGhhdmUgbm90IHlldCB0cmllZCB0byB2ZXJp
ZnkgdGhhdC4NCg0KPiBGYWN0IGlzIE1pbmcgZHV0aWZ1bGx5IGltcGxlbWVudGVkIHdoYXQgSmVu
cyBzdWdnZXN0ZWQuDQoNClRoYXQncyBhIG1pc2xlYWRpbmcgc3RhdGVtZW50LiBKZW5zIHByb3Bv
c2VkIHRvIGludHJvZHVjZSBhIG5ldyBzdGF0dXMgY29kZQ0KKHdoaWNoIGhlIGNhbGxlZCAiTk9f
REVWX1JFU09VUkNFIikgYnV0IGRpZCBub3Qgc3BlY2lmeSBhbnkgb2YgdGhlIG90aGVyDQphc3Bl
Y3RzIG9mIE1pbmcncyBwYXRjaC4gSmVucyBkZWZpbml0ZWx5IGRpZCBub3QgYXNrIHRvIGludHJv
ZHVjZSBuZXcgcmFjZQ0KY29uZGl0aW9ucy4gU2VlIGFsc28gaHR0cHM6Ly93d3cuc3Bpbmljcy5u
ZXQvbGlzdHMva2VybmVsL21zZzI3MDMxNTQuaHRtbA0KDQpCYXJ0Lg==
