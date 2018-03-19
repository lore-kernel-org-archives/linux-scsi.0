From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] Change synchronize_rcu() in scsi_device_quiesce() into
 synchronize_sched()
Date: Mon, 19 Mar 2018 16:18:54 +0000
Message-ID: <1521476333.2776.9.camel@wdc.com>
References: <20180316173516.3048-1-bart.vanassche@wdc.com>
         <20180319143147.GF2943022@devbig577.frc2.facebook.com>
         <1521472566.2776.6.camel@wdc.com>
         <20180319152144.GM2943022@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180319152144.GM2943022@devbig577.frc2.facebook.com>
Content-Language: en-US
Content-ID: <290D7040B738C5448CF294AD71CDB193@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "tj@kernel.org" <tj@kernel.org>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin@lichtvoll.de" <martin@lichtvoll.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDE4LTAzLTE5IGF0IDA4OjIxIC0wNzAwLCB0akBrZXJuZWwub3JnIHdyb3RlOg0K
PiBPbiBNb24sIE1hciAxOSwgMjAxOCBhdCAwMzoxNjowN1BNICswMDAwLCBCYXJ0IFZhbiBBc3Nj
aGUgd3JvdGU6DQo+ID4gQXMgZXhwbGFpbmVkIGluIHRoZSBjb21tZW50IGluIHNjc2lfZGV2aWNl
X3F1aWVzY2UoKSwgdGhlIGVmZmVjdCBvZg0KPiA+IGJsa19zZXRfcHJlZW1wdF9vbmx5KCkgbXVz
dCBiZSB2aXNpYmxlIGZvciBwZXJjcHVfcmVmX3RyeWdldCgpIGNhbGxzIHRoYXQNCj4gPiBvY2N1
ciBhZnRlciB0aGUgcXVldWUgdW5mcmVlemUgdHJpZ2dlcmVkIGJ5IHNjc2lfZGV2aWNlX3F1aWVz
Y2UoKS4gSGVuY2UgdGhlDQo+ID4gUkNVIHJlYWQgbG9jayBjYWxscyBpbiBibGtfcXVldWVfZW50
ZXIoKS4gU2luY2UgdGhlc2UgUkNVIHJlYWQgbG9jayBjYWxscw0KPiA+IHN1cnJvdW5kIGEgZnVu
Y3Rpb24gY2FsbCB0aGF0IHVzZXMgcmN1X3JlYWRfbG9ja19zY2hlZCgpLCBuYW1lbHkNCj4gPiBw
ZXJjcHVfcmVmX3RyeWdldF9saXZlKCksIHdlIGhhdmUgdG8gdXNlIHNjaGVkLVJDVSBpbiBib3Ro
IGJsa19xdWV1ZV9lbnRlcigpDQo+ID4gYW5kIHNjc2lfZGV2aWNlX3F1aWVzY2UoKS4NCj4gDQo+
IExldCdzIHBsZWFzZSBub3QgZGVwZW5kIG9uIHJjdV9yZWFkX2xvY2tfc2NoZWQoKSBpbg0KPiBw
ZXJjcHVfcmVmX3RyeWdldF9saXZlKCkuICBUaGF0J3MgYW4gaW1wbGVtZW50YXRpb24gZGV0YWls
LiAgSWYgdGhlDQo+IGNvZGUgbmVlZHMgUkNVIGJhc2VkIHN5bmNocm9uaXphdGlvbiwgaXQgc2hv
dWxkIHBlcmZvcm0gdGhlbQ0KPiBleHBsaWNpdGx5Lg0KDQpIZWxsbyBUZWp1biwNCg0KVGhlIGFs
Z29yaXRobSBleHBsYWluZWQgYWJvdmUgZG9lcyBub3QgZGVwZW5kIG9uIHNjaGVkLXJjdS4gQnV0
IGJlY2F1c2UNCnBlcmNwdV9yZWZfdHJ5Z2V0X2xpdmUoKSB1c2VzIHNjaGVkLXJjdSBhbmQgYmVj
YXVzZSB3ZSBuZWVkIHRvIGFkZCBhbiBSQ1UgbG9jaw0KYXJvdW5kIHRoYXQgY2FsbCB3ZSBhcmUg
Zm9yY2VkIHRvIHVzZSBzY2hlZC1yY3UuIEkgaG9wZSB0aGlzIG1ha2VzIGl0IGNsZWFyLg0KDQpC
YXJ0Lg0KDQoNCg==
