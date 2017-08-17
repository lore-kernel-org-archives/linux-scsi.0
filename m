From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] Revert "scsi-mq: Always unprepare before requeuing a
 request"
Date: Thu, 17 Aug 2017 15:29:26 +0000
Message-ID: <1502983764.2615.3.camel@wdc.com>
References: <20170816174324.29276-1-bart.vanassche@wdc.com>
         <yq1fucrqchu.fsf@oracle.com> <a757a93a-0052-e22f-b035-b8cc27256dc5@wdc.com>
         <3401ef29-7450-eb15-9dd1-2f021354286d@wdc.com> <yq18tijow0o.fsf@oracle.com>
         <1502933351.14158.3.camel@wdc.com> <yq1a82znec9.fsf@oracle.com>
         <1502937699.2763.1.camel@wdc.com> <yq1tw16nbzf.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq1tw16nbzf.fsf@oracle.com>
Content-Language: en-US
Content-ID: <FF139DF78BF9EF49978DFE9C91F948EF@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, "hch@lst.de" <hch@lst.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE3LTA4LTE2IGF0IDIyOjUxIC0wNDAwLCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3Jv
dGU6DQo+ID4gV2hlbiBJIGNoZWNrZWQgZWFybGllciB0b2RheSB0aGUgaXByIHBhdGNoIHdhcyBu
b3QgeWV0IGluIGxpbnV4LW5leHQNCj4gDQo+IFRoYXQncyB3ZWlyZC4gVGhleSB3ZXJlIGJvdGgg
Y29tbWl0dGVkIHR3byB3ZWVrcyBhZ28uDQo+IA0KPiBUaGV5IGFwcGVhciB0byBiZSBpbiB0aGVy
ZSBub3csIHRob3VnaDoNCj4gDQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L25leHQvbGludXgtbmV4dC5naXQvbG9nL2RyaXZlcnMvc2NzaT9vZnM9NTAN
Cg0KSGVsbG8gTWFydGluLA0KDQpBcyBmYXIgYXMgSSBjYW4gc2VlIGNvbW1pdCAyNzAwNjVlOTJj
MzEgKCJzY3NpLW1xOiBBbHdheXMgdW5wcmVwYXJlIGJlZm9yZQ0KcmVxdWV1aW5nIGEgcmVxdWVz
dCIpIHdhcyB5ZXN0ZXJkYXkgaW4gbGludXgtbmV4dCBidXQgbm90IHRoZSBpcHIgZml4DQooY29t
bWl0IGIwZTE3YTliMGRmMiAoInNjc2k6IGlwcjogRml4IHNjc2ktbXEgbG9ja2RlcCBpc3N1ZSIp
KS4gVGhlDQppcHIgZml4IGlzIGluIHRvZGF5J3MgbGludXgtbmV4dCBidXQgd2FzIG5vdCBpbiBs
aW51eC1uZXh0IHllc3RlcmRheSAodGhlDQpBdXN0cmFsaWFuIHRpbWUgem9uZSBhcHBsaWVzIHRv
IHRoZSBsaW51eC1uZXh0IGRhdGUgbGFiZWxzKToNCiQgZ2l0IHRhZyAtLWNvbnRhaW5zIDI3MDA2
NWU5MmMzMQ0KbmV4dC0yMDE3MDgxNg0KJCBnaXQgdGFnIC0tY29udGFpbnMgYjBlMTdhOWIwZGYy
DQpuZXh0LTIwMTcwODE3DQokIGdpdCBzaG93IG5leHQtMjAxNzA4MTYgfCBoZWFkIC0zDQp0YWcg
bmV4dC0yMDE3MDgxNg0KVGFnZ2VyOiBTdGVwaGVuIFJvdGh3ZWxsIDxzZnJAY2FuYi5hdXVnLm9y
Zy5hdT4NCkRhdGU6ICAgV2VkIEF1ZyAxNiAxNToyNjo0MyAyMDE3ICsxMDAwDQokIGdpdCBzaG93
IG5leHQtMjAxNzA4MTcgfCBoZWFkIC0zICANCnRhZyBuZXh0LTIwMTcwODE3DQpUYWdnZXI6IFN0
ZXBoZW4gUm90aHdlbGwgPHNmckBjYW5iLmF1dWcub3JnLmF1Pg0KRGF0ZTogICBUaHUgQXVnIDE3
IDE2OjM0OjMwIDIwMTcgKzEwMDANCg0KSSB0aGluayB0aGlzIG1lYW5zIHRoYXQgdGhlIGlwciBm
aXggd2VudCB1cHN0cmVhbSBiZWZvcmUgaXQgZW5kZWQgdXAgaW4NCmxpbnV4LW5leHQuDQoNCkJh
cnQu
