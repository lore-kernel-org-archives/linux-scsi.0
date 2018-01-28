From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Sun, 28 Jan 2018 03:00:18 +0000
Message-ID: <1517108417.3055.33.camel@wdc.com>
References: <20180123161613.14214-1-ming.lei@redhat.com>
         <1516724659.3339.7.camel@sandisk.com> <20180123163717.GE13277@ming.t460p>
         <1516726653.3339.20.camel@wdc.com> <20180124033109.GA15945@ming.t460p>
         <20180127190920.GA24759@redhat.com> <1517091161.3055.7.camel@wdc.com>
         <20180128002356.GA25933@redhat.com> <1517100877.3055.23.camel@wdc.com>
         <20180128020312.GA26437@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:46780 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbeA1DAW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jan 2018 22:00:22 -0500
In-Reply-To: <20180128020312.GA26437@redhat.com>
Content-Language: en-US
Content-ID: <F9C28C642A2D4D44BC311C56B13CC86C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

T24gU2F0LCAyMDE4LTAxLTI3IGF0IDIxOjAzIC0wNTAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQo+
IFlvdSBjYW5ub3QgZXZlbiBiZSBmb3J0aGNvbWluZyBhYm91dCB0aGUgdGVjaG5pY2FsIG1lcml0
IG9mIGEgY2hhbmdlIHlvdQ0KPiBhdXRob3JlZCAoY29tbWl0IDYwNzdjMmQ3MCkgdGhhdCBJJ20g
bGVmdCB0byBjbGVhbiB1cCBpbiB0aGUgZmFjZSBvZg0KPiBwZXJmb3JtYW5jZSBib3R0bGVuZWNr
cyBpdCB1bndpdHRpbmdseSBpbnRyb2R1Y2VkPyAgSWYgeW91IHdlcmUgYmVpbmcNCj4gaG9uZXN0
OiB5b3UnZCBncmFudCB0aGF0IHRoZSByYW5kb20gZGVsYXkgb2YgMTAwbXMgaXMgdXR0ZXJseSBi
YXNlbGVzcw0KPiAobm90IHRvIG1lbnRpb24gdGhhdCBraWNraW5nIHRoZSBxdWV1ZSBsaWtlIHlv
dSBkaWQgaXMgYSBjb21wbGV0ZQ0KPiBoYWNrKS4gIFNvIHRoYXQgMTAwbXMgZGVsYXkgaXMgd2hh
dCBteSBkbS00LjE2IGNvbW1pdCBpcyB0YWxraW5nIGFib3V0Lg0KDQpUaGVyZSBhcmUgbXVsdGlw
bGUgZXJyb3JzIGluIHRoZSBhYm92ZToNCjEuIEkgaGF2ZSBhbHJlYWR5IGV4cGxhaW5lZCBpbiBk
ZXRhaWwgd2h5IGNvbW1pdCA2MDc3YzJkNzAgaXMgKGEpIGNvcnJlY3QNCiAgIGFuZCAoYikgZXNz
ZW50aWFsLiBTZWUgZS5nLiBodHRwczovL3d3dy5yZWRoYXQuY29tL2FyY2hpdmVzL2RtLWRldmVs
LzIwMTgtSmFudWFyeS9tc2cwMDE2OC5odG1sLg0KMi4gV2l0aCBwYXRjaCAiYmxrLW1xOiBBdm9p
ZCB0aGF0IGJsa19tcV9kZWxheV9ydW5faHdfcXVldWUoKSBpbnRyb2R1Y2VzDQogICB1bmludGVu
ZGVkIGRlbGF5cyIgYXBwbGllZCwgdGhlcmUgaXMgbm90aGluZyB0byBjbGVhbiB1cCBhbnltb3Jl
IHNpbmNlDQogICB0aGF0IHBhdGNoIGVsaW1pbmF0ZXMgdGhlIHF1ZXVlIGRlbGF5cyB0aGF0IHdl
cmUgdHJpZ2dlcmVkIGJ5DQogICBibGtfbXFfZGVsYXlfcnVuX2h3X3F1ZXVlKCkuDQozLiBZb3Ug
a25vdyB0aGF0IEknbSBob25lc3QuIFN1Z2dlc3RpbmcgdGhhdCBJJ20gbm90IGlzIHdyb25nLg0K
NC4gSSBuZXZlciBjbGFpbWVkIHRoYXQgMTAwbXMgaXMgdGhlIG9wdGltYWwgdmFsdWUgZm9yIHRo
ZSBxdWV1ZQ0KICAgcmVydW5uaW5nIGRlbGF5LiBJIGhhdmUgYWxyZWFkeSBleHBsYWluZWQgdG8g
eW91IHRoYXQgSSBjb3BpZWQgdGhhdA0KICAgdmFsdWUgZnJvbSBvbGRlciBkbS1ycSBjb2RlLg0K
DQo+IERvbid0IHByb2plY3Qgb250byBtZSBCYXJ0LiAgVGhpcyBpc24ndCB0aGUgZmlyc3QgdGlt
ZSB5b3UndmUgYmVlbg0KPiBjb21wbGV0ZWx5IHVucHJvZmVzc2lvbmFsIGFuZCBzYWRseSBpdCBs
aWtlbHkgd29uJ3QgYmUgdGhlIGxhc3QuDQoNClRoZSBvbmx5IHBlcnNvbiB3aG8gaXMgYmVoYXZp
bmcgdW5wcm9mZXNzaW9uYWxseSBpbiB0aGlzIGUtbWFpbCB0aHJlYWQNCmlzIHlvdS4NCg0KQmFy
dC4NCiAgIA0K
