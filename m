From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Sat, 27 Jan 2018 22:12:43 +0000
Message-ID: <1517091161.3055.7.camel@wdc.com>
References: <20180123161613.14214-1-ming.lei@redhat.com>
         <1516724659.3339.7.camel@sandisk.com> <20180123163717.GE13277@ming.t460p>
         <1516726653.3339.20.camel@wdc.com> <20180124033109.GA15945@ming.t460p>
         <20180127190920.GA24759@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:57555 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbeA0WMr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jan 2018 17:12:47 -0500
In-Reply-To: <20180127190920.GA24759@redhat.com>
Content-Language: en-US
Content-ID: <D8C1497F310CDE4EA2B1B10D99FB3AFC@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>

T24gU2F0LCAyMDE4LTAxLTI3IGF0IDE0OjA5IC0wNTAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IE1pbmcgbGV0IG1lIGtub3cgdGhhdCBoZSBzdWNjZXNzZnVsbHkgdGVzdGVkIHRoaXMgVjMgcGF0
Y2ggdXNpbmcgYm90aA0KPiB5b3VyIHRlc3QgKGZpbyB0byBib3RoIG1wYXRoIGFuZCB1bmRlcmx5
aW5nIHBhdGgpIGFuZCBCYXJ0J3MgKDAyLW1xIHdpdGgNCj4gY2FuX3F1ZXVlIGluIGd1ZXN0KS4N
Cj4gDQo+IFdvdWxkIGJlIGdyZWF0IGlmIHlvdSdkIHJldmlldyBhbmQgdmVyaWZ5IHRoaXMgZml4
IHdvcmtzIGZvciB5b3UgdG9vLg0KPiANCj4gSWRlYWxseSB3ZSdkIGdldCBhIGZpeCBmb3IgdGhp
cyByZWdyZXNzaW9uIHN0YWdlZCBmb3IgNC4xNiBpbmNsdXNpb24uDQo+IFRoaXMgVjMgcGF0Y2gg
c2VlbXMgbGlrZSB0aGUgYmVzdCBvcHRpb24gd2UgaGF2ZSBhdCB0aGlzIHBvaW50Lg0KDQpIZWxs
byBNaWtlLA0KDQpUaGVyZSBhcmUgc2V2ZXJhbCBpc3N1ZXMgd2l0aCB0aGUgcGF0Y2ggYXQgdGhl
IHN0YXJ0IG9mIHRoaXMgdGhyZWFkOg0KLSBJdCBpcyBhbiB1bm5lY2Vzc2FyeSBjaGFuZ2Ugb2Yg
dGhlIGJsb2NrIGxheWVyIEFQSS4gUXVldWUgc3RhbGxzIGNhbg0KICBhbHJlYWR5IGJlIGFkZHJl
c3NlZCB3aXRoIHRoZSBjdXJyZW50IGJsb2NrIGxheWVyIEFQSSwgbmFtZWx5IGJ5IGluc2VydGlu
Zw0KICBhIGJsa19tcV9kZWxheV9ydW5faHdfcXVldWUoKSBjYWxsIGJlZm9yZSByZXR1cm5pbmcg
QkxLX1NUU19SRVNPVVJDRS4NCi0gVGhlIHBhdGNoIGF0IHRoZSBzdGFydCBvZiB0aGlzIHRocmVh
ZCBjb21wbGljYXRlcyBjb2RlIGZ1cnRoZXIgdGhhdCBpcw0KICBhbHJlYWR5IHRvbyBjb21wbGlj
YXRlZCwgbmFtZWx5IHRoZSBibGstbXEgY29yZS4NCi0gVGhlIHBhdGNoIGF0IHRoZSBzdGFydCBv
ZiB0aGlzIHRocmVhZCBpbnRyb2R1Y2VzIGEgcmVncmVzc2lvbiBpbiB0aGUNCiAgU0NTSSBjb3Jl
LCBuYW1lbHkgYSBxdWV1ZSBzdGFsbCBpZiBhIHJlcXVlc3QgY29tcGxldGlvbiBvY2N1cnMgY29u
Y3VycmVudGx5DQogIHdpdGggdGhlIG5ld2x5IGFkZGVkIEJMS19NUV9TX1NDSEVEX1JFU1RBUlQg
dGVzdCBpbiB0aGUgYmxrLW1xIGNvcmUuDQoNCkFzIGEga2VybmVsIG1haW50YWluZXIgb25lIG9m
IHlvdXIgcmVzcG9uc2liaWxpdGllcyBpcyB0byBoZWxwIGtlZXBpbmcgdGhlDQpxdWFsaXR5IG9m
IHRoZSBrZXJuZWwgY29kZSBoaWdoLiBTbyBJIHRoaW5rIHRoYXQgeW91LCBhcyBhIGtlcm5lbCBt
YWludGFpbmVyLA0Kc2hvdWxkIHRlbGwgTWluZyB0byBkaXNjYXJkIHRoaXMgcGF0Y2ggaW5zdGVh
ZCBvZg0KYXNraW5nIHRvIG1lcmdlIGl0IHVwc3RyZWFtDQpnaXZlbiBhbGwgdGhlIGRpc2FkdmFu
dGFnZXMgb2YgdGhpcyBwYXRjaC4NCg0KQmFydC4=
