From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: hosts: remove redundant assingment of
 shost->use_blk_mq
Date: Mon, 2 Apr 2018 13:53:08 +0000
Message-ID: <4c62b8f8da1175ddcdcdf0a234dacbf620d73060.camel@wdc.com>
References: <20180402093749.6862-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180402093749.6862-1-jthumshirn@suse.de>
Content-Language: en-US
Content-ID: <7D2C8ED04C72AA439465242D7ADE66DD@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDE4LTA0LTAyIGF0IDExOjM3ICswMjAwLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3Jv
dGU6DQo+IENvdmVyaXR5IHJlcG9ydHMgdGhhdCB3ZSdyZSBhc3NpZ25pbmcgc2hvc3QtPnVzZV9i
bGtfbXEgdHdpY2UuIFRoaXMNCj4gbG9va3MgbGlrZSB0aGUgcmVzdWx0IG9mIGEgYmFkIG1lcmdl
IG9mIGNvbW1pdCAyZjMxMTE1ZTk0MGMgKCJzY3NpOg0KPiBjb3JlOiBpbnRyb2R1Y2UgZm9yY2Vf
YmxrX21xIikNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8anRodW1z
aGlybkBzdXNlLmRlPg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS9ob3N0cy5jIHwgMSAtDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS9ob3N0cy5jIGIvZHJpdmVycy9zY3NpL2hvc3RzLmMNCj4gaW5kZXggZWYyMmIyNzVkMDUw
Li5jMzZmMmE0NGU1ZWQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9ob3N0cy5jDQo+ICsr
KyBiL2RyaXZlcnMvc2NzaS9ob3N0cy5jDQo+IEBAIC00NzMsNyArNDczLDYgQEAgc3RydWN0IFNj
c2lfSG9zdCAqc2NzaV9ob3N0X2FsbG9jKHN0cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUgKnNodCwg
aW50IHByaXZzaXplKQ0KPiAgCWVsc2UNCj4gIAkJc2hvc3QtPmRtYV9ib3VuZGFyeSA9IDB4ZmZm
ZmZmZmY7DQo+ICANCj4gLQlzaG9zdC0+dXNlX2Jsa19tcSA9IHNjc2lfdXNlX2Jsa19tcTsNCj4g
IAlzaG9zdC0+dXNlX2Jsa19tcSA9IHNjc2lfdXNlX2Jsa19tcSB8fCBzaG9zdC0+aG9zdHQtPmZv
cmNlX2Jsa19tcTsNCj4gIA0KPiAgCWRldmljZV9pbml0aWFsaXplKCZzaG9zdC0+c2hvc3RfZ2Vu
ZGV2KTsNCg0KQSBzaW1pbGFyIHBhdGNoIGhhcyBhbHJlYWR5IGJlZW4gcXVldWVkIGJ5IE1hcnRp
bi4gU2VlIGFsc28NCmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcGF0Y2gvMTAzMTM1Njkv
Lg0KDQpCYXJ0Lg0KDQoNCg==
