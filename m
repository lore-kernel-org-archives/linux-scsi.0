From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2] Avoid that ATA error handling can trigger a kernel
 hang or oops
Date: Tue, 27 Feb 2018 21:11:12 +0000
Message-ID: <4f51da84-6fc6-131b-3330-497ce6a425a8@wdc.com>
References: <20180222193020.30276-1-bart.vanassche@wdc.com>
 <1519757627.23791.12.camel@wdc.com>
Reply-To: Damien Le Moal <Damien.LeMoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1519757627.23791.12.camel@wdc.com>
Content-Language: en-US
Content-ID: <62B6D4676746554E95DAF8D177E7DA7C@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "oliva@gnu.org" <oliva@gnu.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>, "ncopa@alpinelinux.org" <ncopa@alpinelinux.org>
List-Id: linux-scsi@vger.kernel.org

T24gMjAxOC8wMi8yNyAxMDo1MywgQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiBPbiBUaHUsIDIw
MTgtMDItMjIgYXQgMTE6MzAgLTA4MDAsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4+IEF2b2lk
IHRoYXQgdGhlIHJlY2VudGx5IGludHJvZHVjZWQgY2FsbF9yY3UoKSBjYWxsIGluIHRoZSBTQ1NJ
IGNvcmUNCj4+IHRyaWdnZXJzIGEgZG91YmxlIGNhbGxfcmN1KCkgY2FsbC4NCj4+IFsgLi4uIF0N
Cj4gDQo+IENhbiBhbnlvbmUgcmV2aWV3IHRoaXMgcGF0Y2g/IE11bHRpcGxlIHVzZXJzIGhhdmUg
Y29uZmlybWVkIGluZGVwZW5kZW50bHkNCj4gdGhhdCB0aGlzIHBhdGNoIGZpeGVzIHRoZSBkb3Vi
bGUgY2FsbF9yY3UoKSBpc3N1ZSBmb3IgdGhlbS4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQu
DQoNClBsZWFzZSBmZWVsIGZyZWUgdG8gYWRkOg0KDQpSZXZpZXdlZC1ieTogRGFtaWVuIExlIE1v
YWwgPGRhbWllbi5sZW1vYWxAd2RjLmNvbT4NClRlc3RlZC1ieTogRGFtaWVuIExlIE1vYWwgPGRh
bWllbi5sZW1vYWxAd2RjLmNvbT4NCg0KDQotLSANCkRhbWllbiBMZSBNb2FsDQpXZXN0ZXJuIERp
Z2l0YWwgUmVzZWFyY2g=
