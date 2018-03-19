From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] Change synchronize_rcu() in scsi_device_quiesce() into
 synchronize_sched()
Date: Mon, 19 Mar 2018 20:19:52 +0000
Message-ID: <1521490791.2776.15.camel@wdc.com>
References: <20180316173516.3048-1-bart.vanassche@wdc.com>
         <20180319143147.GF2943022@devbig577.frc2.facebook.com>
         <1521472566.2776.6.camel@wdc.com>
         <20180319152144.GM2943022@devbig577.frc2.facebook.com>
         <1521476333.2776.9.camel@wdc.com>
         <20180319162921.GS2943022@devbig577.frc2.facebook.com>
         <1521478664.2776.12.camel@wdc.com>
         <20180319170225.GC519464@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180319170225.GC519464@devbig577.frc2.facebook.com>
Content-Language: en-US
Content-ID: <4D799C3A4F3B1049A16CB8E20DF4082E@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin@lichtvoll.de" <martin@lichtvoll.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDE4LTAzLTE5IGF0IDEwOjAyIC0wNzAwLCB0akBrZXJuZWwub3JnIHdyb3RlOg0K
PiBPbiBNb24sIE1hciAxOSwgMjAxOCBhdCAwNDo1Nzo0NVBNICswMDAwLCBCYXJ0IFZhbiBBc3Nj
aGUgd3JvdGU6DQo+ID4gRm9yIHN5bmNocm9uaXphdGlvbiBwcmltaXRpdmVzIHRoYXQgd2FpdCBo
YXZpbmcgYSBzdHJvbmdlciBzeW5jaHJvbml6YXRpb24NCj4gPiBwcmltaXRpdmUgbmVzdGVkIGlu
c2lkZSBhIG1vcmUgcmVsYXhlZCBvbmUgY2FuIGxlYWQgdG8gYSBkZWFkbG9jay4gQnV0IHNpbmNl
DQo+ID4gdGhlIHJjdSByZWFkIGxvY2sgcHJpbWl0aXZlcyBkbyBub3Qgd2FpdCBpdCBjb3VsZCBi
ZSBzYWZlIHRvIHVzZSB0aGF0IGtpbmQNCj4gPiBvZiBuZXN0aW5nIHdpdGggUkNVLiBEbyB5b3Ug
cGVyaGFwcyBrbm93IHdoZXRoZXIgYW55IGRvY3VtZW50YXRpb24gaXMNCj4gPiBhdmFpbGFibGUg
YWJvdXQgdGhhdCBraW5kIG9mIG5lc3Rpbmcgb3Igd2hldGhlciBpdCBpcyBhbHJlYWR5IHVzZWQg
ZWxzZXdoZXJlDQo+ID4gaW4gdGhlIGtlcm5lbD8NCj4gDQo+IE9oLCB3ZSBuZXN0IHRoZW0gYWxs
IHRoZSB0aW1lLiAgVGhleSdyZSBsaWtlIChhbmQgc29tZXRpbWVzIGxpdGVyYWxseQ0KPiBhcmUp
IHByZWVtcHRfZGlzYWJsZSgpIGFuZCBkb24ndCBjYXJlIGFib3V0IG5lc3Qgb3JkZXJpbmcuDQoN
CkhlbGxvIE1hcnRpbiwNCg0KVGhpcyB3YXMgcHJvYmFibHkgYWxyZWFkeSBjbGVhciB0byB5b3Us
IGJ1dCBhbnl3YXk6IHBsZWFzZSBkcm9wIHRoZSBwYXRjaCBhdCB0aGUNCnN0YXJ0IG9mIHRoaXMg
dGhyZWFkLg0KDQpUaGFua3MsDQoNCkJhcnQuDQoNCg0K
