From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V5 06/14] block: Add zoned block device information to
 request queue
Date: Mon, 25 Sep 2017 21:06:11 +0000
Message-ID: <1506373570.2641.16.camel@wdc.com>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
         <20170925061454.5533-7-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:57094 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753950AbdIYVGO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 17:06:14 -0400
In-Reply-To: <20170925061454.5533-7-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <BCA7D5CCA1E27C49AEE2A94EC048C8C4@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>

T24gTW9uLCAyMDE3LTA5LTI1IGF0IDE1OjE0ICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gQ29tcG9uZW50cyByZWx5aW5nIG9ubHkgb24gdGhlIHJlcXVldWVzdF9xdWV1ZSBzdHJ1Y3R1
cmUgZm9yIGFjY2Vzc2luZw0KPiBibG9jayBkZXZpY2VzIChlLmcuIEkvTyBzY2hlZHVsZXJzKSBo
YXZlIGEgbGltaXRlZCBrbm93bGVkZ2VkIG9mIHRoZQ0KPiBkZXZpY2UgY2hhcmFjdGVyaXN0aWNz
LiBJbiBwYXJ0aWN1bGFyLCB0aGUgZGV2aWNlIGNhcGFjaXR5IGNhbm5vdCBiZQ0KPiBlYXNpbHkg
ZGlzY292ZXJlZCwgd2hpY2ggZm9yIGEgem9uZWQgYmxvY2sgZGV2aWNlIGFsc28gcmVzdWx0IGlu
IHRoZQ0KPiBpbmFiaWxpdHkgdG8gZWFzaWx5IGtub3cgdGhlIG51bWJlciBvZiB6b25lcyBvZiB0
aGUgZGV2aWNlICh0aGUgem9uZQ0KPiBzaXplIGlzIGluZGljYXRlZCBieSB0aGUgY2h1bmtfc2Vj
dG9ycyBmaWVsZCBvZiB0aGUgcXVldWUgbGltaXRzKS4NCj4gDQo+IEludHJvZHVjZSB0aGUgbnJf
em9uZXMgZmllbGQgdG8gdGhlIHJlcXVlc3RfcXVldWUgc3R1cmN0dXJlIHRvIHNpbXBsaWZ5DQo+
IGFjY2VzcyB0byB0aGlzIGluZm9ybWF0aW9uLiBBbHNvLCBhZGQgdGhlIGJpdG1hcCBzZXFfem9u
ZV9iaXRtYXAgd2hpY2gNCj4gaW5kaWNhdGVzIHdoaWNoIHpvbmVzIG9mIHRoZSBkZXZpY2UgYXJl
IHNlcXVlbnRpYWwgem9uZXMgKHdyaXRlDQo+IHByZWZlcnJlZCBvciB3cml0ZSByZXF1aXJlZCku
IFRoZXNlIHR3byBmaWVsZHMgYXJlIGluaXRpYWxpemVkIGJ5IHRoZQ0KPiBsb3cgbGV2ZWwgYmxv
Y2sgZGV2aWNlIGRyaXZlciAoc2QuYyBmb3IgWkJDL1pBQyBkaXNrcykuIFRoZXkgYXJlIG5vdA0K
PiBpbml0aWFsaXplZCBieSBzdGFja2luZyBkcml2ZXJzIChkZXZpY2UgbWFwcGVycykgaGFuZGxp
bmcgem9uZWQgYmxvY2sNCj4gZGV2aWNlcyAoZS5nLiBkbS1saW5lYXIpLg0KDQpSZXZpZXdlZC1i
eTogQmFydCBWYW4gQXNzY2hlIDxCYXJ0LlZhbkFzc2NoZUB3ZGMuY29tPg0KDQo=
