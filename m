From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] block: fix CDROM dependency on BLK_DEV
Date: Thu, 2 Nov 2017 15:01:20 +0000
Message-ID: <1509634878.2484.5.camel@wdc.com>
References: <20171102111952.4021454-1-arnd@arndb.de>
         <212c24f4-7329-f1f5-93c8-090727ed7226@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <212c24f4-7329-f1f5-93c8-090727ed7226@kernel.dk>
Content-Language: en-US
Content-ID: <4468D533762A8E4A8E18E259DFBE8F28@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "arnd@arndb.de" <arnd@arndb.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE3LTExLTAyIGF0IDA4OjI3IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biAxMS8wMi8yMDE3IDA1OjE5IEFNLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0KPiA+IEFmdGVyIHRo
ZSBjZHJvbSBjbGVhbnVwLCBJIGdldCByYW5kY29uZmlnIHdhcm5pbmdzIGZvciBzb21lIGNvbmZp
Z3VyYXRpb25zOg0KPiA+IA0KPiA+IHdhcm5pbmc6IChCTEtfREVWX0lERUNEICYmIEJMS19ERVZf
U1IpIHNlbGVjdHMgQ0RST00gd2hpY2ggaGFzIHVubWV0IGRpcmVjdCBkZXBlbmRlbmNpZXMgKEJM
S19ERVYpDQo+ID4gDQo+ID4gVGhpcyBhZGRzIGFuIGV4cGxpY2l0IEJMS19ERVYgZGVwZW5kZW5j
eSBmb3IgYm90aCBkcml2ZXJzLiBUaGUgb3RoZXINCj4gPiBkcml2ZXJzIHRoYXQgc2VsZWN0ICdD
RFJPTScgYWxyZWFkeSBoYXZlIHRoaXMgYW5kIGRvbid0IG5lZWQgYSBjaGFuZ2UuDQo+IA0KPiBU
aGFua3MgQXJuZCwgYXBwbGllZC4NCg0KSGVsbG8gSmVucywNCg0KQ2FuIHlvdSB3YWl0IGF0IGxl
YXN0IDI0IGhvdXJzIGFmdGVyIGEgcGF0Y2ggaGFzIGJlZW4gcG9zdGVkIGJlZm9yZSBhcHBseWlu
ZyBpdA0Kc3VjaCB0aG9zZSB3aG8gd2FudCB0byBwb3N0IHJldmlldyBjb21tZW50cyBoYXZlIGEg
Y2hhbmNlIHRvIGRvIHRoYXQ/DQoNClRoYW5rcywNCg0KQmFydC4=
