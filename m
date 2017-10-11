From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v8 03/10] md: Neither resync nor reshape while the system
 is frozen
Date: Wed, 11 Oct 2017 17:17:56 +0000
Message-ID: <1507742275.2477.20.camel@wdc.com>
References: <20171010210346.14574-1-bart.vanassche@wdc.com>
         <20171010210346.14574-4-bart.vanassche@wdc.com>
         <20171010223025.tda3lx64rdmugm54@kernel.org>
         <1507678384.2815.80.camel@wdc.com>
         <20171011014830.ps3v3yxny27wv7mc@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171011014830.ps3v3yxny27wv7mc@kernel.org>
Content-Language: en-US
Content-ID: <347DA52F3C7B1C4792D780206E349584@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "shli@kernel.org" <shli@kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE3LTEwLTEwIGF0IDE4OjQ4IC0wNzAwLCBTaGFvaHVhIExpIHdyb3RlOg0KPiBU
aGUgcHJvYmxlbSBpcyBfX21kX3N0b3Bfd3JpdGVzIHNldCBzb21lIGJpdCBsaWtlIE1EX1JFQ09W
RVJZX0ZST1pFTiwgd2hpY2gNCj4gd2lsbCBwcmV2ZW50IG1kX2NoZWNrX3JlY292ZXJ5IHJlc3Rh
cnRpbmcgcmVzeW5jL3Jlc2hhcGUuIEkgdGhpbmsgd2UgbmVlZA0KPiBwcmVzZXJ2ZSBtZGRldi0+
cmVjb3ZlcnkgaW4gc3VzcGVuZCBwcmVwYXJlIGFuZCByZXN0b3JlIGFmdGVyIHJlc3VtZQ0KDQpI
ZWxsbyBTaGFvaHVhLA0KDQpBcyBmYXIgYXMgSSBjYW4gc2VlIF9fbWRfc3RvcF93cml0ZXMoKSBz
ZXRzIE1EX1JFQ09WRVJZX0ZST1pFTiBhbmQgY2FuIHNldA0KTURfUkVDT1ZFUllfSU5UUi4gU2lu
Y2UgbWRfY2hlY2tfcmVjb3ZlcnkoKSBjbGVhcnMgTURfUkVDT1ZFUllfSU5UUiBJIHRoaW5rDQpp
dCBzaG91bGQgYmUgc3VmZmljaWVudCB0byBzYXZlIGFuZCByZXN0b3JlIHRoZSBzdGF0ZSBvZiB0
aGUNCk1EX1JFQ09WRVJZX0ZST1pFTiBmbGFnLiBIb3dldmVyLCB3aGVuIEkgcmFuIHRoZSBmb2xs
b3dpbmcgdGVzdDoNCiogZWNobyBmcm96ZW4gPiAvc3lzL2Jsb2NrL21kMC9tZC9zeW5jX2FjdGlv
bg0KKiBjYXQgL3N5cy9ibG9jay9tZDAvbWQvc3luY19hY3Rpb24NCiogc3lzdGVtY3RsIGhpYmVy
bmF0ZQ0KKiAocG93ZXIgb24gc3lzdGVtIGFnYWluKQ0KKiBjYXQgL3N5cy9ibG9jay9tZDAvbWQv
c3luY19hY3Rpb24NCg0KdGhlIG91dHB1dCB0aGF0IGFwcGVhcmVkIHdhcyBhcyBmb2xsb3dzOg0K
DQpmcm96ZW4NCmlkbGUNCg0KRG9lcyB0aGF0IG1lYW4gdGhhdCBhIGhpYmVybmF0ZSBvciBzdXNw
ZW5kIGZvbGxvd2VkIGJ5IGEgcmVzdW1lIGlzIHN1ZmZpY2llbnQNCnRvIGNsZWFyIHRoZSBNRF9S
RUNPVkVSWV9GUk9aRU4gZmxhZyBmb3IgdGhlIG1kIGRyaXZlcnMgYW5kIGhlbmNlIHRoYXQgdGhl
DQpwYXRjaCBhdCB0aGUgc3RhcnQgb2YgdGhpcyBlLW1haWwgdGhyZWFkIGRvZXMgbm90IG5lZWQg
YW55IGZ1cnRoZXINCm1vZGlmaWNhdGlvbnM/DQoNClRoYW5rcywNCg0KQmFydC4=
