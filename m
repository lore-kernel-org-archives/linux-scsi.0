From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 1/3] Call scsi_initialize_rq() also for filesystem
 requests
Date: Wed, 30 Aug 2017 23:03:11 +0000
Message-ID: <1504134190.2526.63.camel@wdc.com>
References: <20170830000742.29653-1-bart.vanassche@wdc.com>
         <20170830000742.29653-2-bart.vanassche@wdc.com>
         <0df3b3b3-94f7-22bf-deb1-9c8b53d65ec5@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:59198 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750973AbdH3XD7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 19:03:59 -0400
In-Reply-To: <0df3b3b3-94f7-22bf-deb1-9c8b53d65ec5@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <418310CA8E63C04396A21288BEAFDBAD@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>

T24gV2VkLCAyMDE3LTA4LTMwIGF0IDE3OjE0IC0wNTAwLCBCcmlhbiBLaW5nIHdyb3RlOg0KPiBP
biAwOC8yOS8yMDE3IDA3OjA3IFBNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4gSWYgYSBw
YXNzLXRocm91Z2ggcmVxdWVzdCBpcyBzdWJtaXR0ZWQgdGhlbiBibGtfZ2V0X3JlcXVlc3QoKQ0K
PiA+IGluaXRpYWxpemVzIHRoYXQgcmVxdWVzdCBieSBjYWxsaW5nIHNjc2lfaW5pdGlhbGl6ZV9y
cSgpLiBBbHNvDQo+ID4gY2FsbCB0aGlzIGZ1bmN0aW9uIGZvciBmaWxlc3lzdGVtIHJlcXVlc3Rz
LiBJbnRyb2R1Y2UNCj4gPiBDTURfSU5JVElBTElaRUQgdG8ga2VlcCB0cmFjayBvZiB3aGV0aGVy
IG9yIG5vdCBhIHJlcXVlc3QgaGFzDQo+ID4gYWxyZWFkeSBiZWVuIGluaXRpYWxpemVkLg0KPiAN
Cj4gSSBhcHBsaWVkIHRoZXNlIHBhdGNoZXMgYW5kIHdhcyBhYmxlIHRvIHRoZW4gcmUtYXBwbHkg
eW91ciBub3cgcmV2ZXJ0ZWQgcGF0Y2g6DQo+IA0KPiAyNzAwNjVlOTIgLSBzY3NpLW1xOiBBbHdh
eXMgdW5wcmVwYXJlIGJlZm9yZSByZXF1ZXVpbmcgYSByZXF1ZXN0DQo+IA0KPiBXaXRoIHRoaXMg
Y29tYmluYXRpb24sIEkgd2FzIHN0aWxsIGFibGUgdG8gYm9vdCBzdWNjZXNzZnVsbHkgb24NCj4g
YSBQb3dlciBzeXN0ZW0gd2l0aCBpcHIuDQoNCkhlbGxvIEJyaWFuLA0KDQpUaGFua3MgZm9yIHRl
c3RpbmchIFNvcnJ5IGJ1dCBhIGZldyBtaW51dGVzIGFnbyBJIGZvdW5kIGEgYnVnIGluIHRoaXMN
CnBhdGNoLiBJIHdpbGwgcmVwb3N0IHRoaXMgcGF0Y2ggc2VyaWVzLg0KDQpCYXJ0Lg==
