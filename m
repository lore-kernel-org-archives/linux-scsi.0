From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] Revert "scsi-mq: Always unprepare before requeuing a
 request"
Date: Thu, 17 Aug 2017 01:29:13 +0000
Message-ID: <1502933351.14158.3.camel@wdc.com>
References: <20170816174324.29276-1-bart.vanassche@wdc.com>
         <yq1fucrqchu.fsf@oracle.com> <a757a93a-0052-e22f-b035-b8cc27256dc5@wdc.com>
         <3401ef29-7450-eb15-9dd1-2f021354286d@wdc.com> <yq18tijow0o.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq18tijow0o.fsf@oracle.com>
Content-Language: en-US
Content-ID: <49C2BFD1A36D67448A646ACB4ED382E4@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE3LTA4LTE2IGF0IDIwOjUyIC0wNDAwLCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3Jv
dGU6DQo+IERhbWllbiwNCj4gDQo+ID4gQWN0dWFsbHksIHdlIGNhbiBrZWVwIHRoYXQgY29tbWl0
IGFzIGl0IG1ha2VzIHRoZSBzcSBjYXNlIGNsZWFuZXINCj4gPiBhbnl3YXkuIEJ1dCB3ZSBuZWVk
IHNvbWV0aGluZyBlbHNlIHRvIHByZXZlbnQgZGVhZGxvY2sgaW4gdGhlIG1xDQo+ID4gY2FzZS4u
Lg0KPiANCj4gT0ssIHB1dCBpdCBiYWNrLg0KPiANCj4gUGxlYXNlIHNlbmQgYSBsb2Nrb3V0IHBh
dGNoLiBXZSBjYW4gYWx3YXlzIHphcCBpdCBpZiB3ZSBmaW5kIG91dCB3aGF0DQo+IHdlbnQgd3Jv
bmcgd2l0aCBCYXJ0J3MgcGF0Y2ggYW5kIHF1ZXVlIGEgInJlYWwiIGZpeC4NCg0KSGVsbG8gTWFy
dGluLA0KDQpJJ20gOTklIHN1cmUgdGhlcmUgaXMgbm90aGluZyB3cm9uZyB3aXRoIG15IHBhdGNo
IGJ1dCB0aGF0IG15IHBhdGNoIHVuY292ZXJlZA0KYSBidWcgaW4gdGhlIGlwciBkcml2ZXIgKGRy
aXZlcnMvc2NzaS9pcHIpLiBTZWUgYWxzbyAiV0FSTklORzogQ1BVOiAxNSBQSUQ6IDANCmF0IGJs
b2NrL2Jsay1tcS5jOjExMTEgX19ibGtfbXFfcnVuX2h3X3F1ZXVlKzB4MWQ4LzB4MWYwRiINCiho
dHRwczovL21hcmMuaW5mby8/bD1saW51eC1ibG9jayZtPTE1MDI5MDY4NjcxOTY0NCkuDQoNCkJh
cnQu
