From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] Revert "scsi-mq: Always unprepare before requeuing a
 request"
Date: Thu, 17 Aug 2017 02:41:41 +0000
Message-ID: <1502937699.2763.1.camel@wdc.com>
References: <20170816174324.29276-1-bart.vanassche@wdc.com>
         <yq1fucrqchu.fsf@oracle.com> <a757a93a-0052-e22f-b035-b8cc27256dc5@wdc.com>
         <3401ef29-7450-eb15-9dd1-2f021354286d@wdc.com> <yq18tijow0o.fsf@oracle.com>
         <1502933351.14158.3.camel@wdc.com> <yq1a82znec9.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq1a82znec9.fsf@oracle.com>
Content-Language: en-US
Content-ID: <FDA35891C621474596E21DCFA1F53A31@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, "hch@lst.de" <hch@lst.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE3LTA4LTE2IGF0IDIyOjAwIC0wNDAwLCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3Jv
dGU6DQo+IEJhcnQsDQo+IA0KPiA+IEknbSA5OSUgc3VyZSB0aGVyZSBpcyBub3RoaW5nIHdyb25n
IHdpdGggbXkgcGF0Y2ggYnV0IHRoYXQgbXkgcGF0Y2gNCj4gPiB1bmNvdmVyZWQgYSBidWcgaW4g
dGhlIGlwciBkcml2ZXIgKGRyaXZlcnMvc2NzaS9pcHIpLiBTZWUgYWxzbw0KPiA+ICJXQVJOSU5H
OiBDUFU6IDE1IFBJRDogMCBhdCBibG9jay9ibGstbXEuYzoxMTExDQo+ID4gX19ibGtfbXFfcnVu
X2h3X3F1ZXVlKzB4MWQ4LzB4MWYwRiINCj4gPiAoaHR0cHM6Ly9tYXJjLmluZm8vP2w9bGludXgt
YmxvY2smbT0xNTAyOTA2ODY3MTk2NDQpLg0KPiANCj4gQnV0IEkgYWxyZWFkeSBoYXZlIHRoZSBp
cHIgcGF0Y2ggcXVldWVkLiBXaGF0IGFtIEkgbWlzc2luZz8NCg0KSGVsbG8gTWFydGluLA0KDQpX
aGVuIEkgY2hlY2tlZCBlYXJsaWVyIHRvZGF5IHRoZSBpcHIgcGF0Y2ggd2FzIG5vdCB5ZXQgaW4g
bGludXgtbmV4dCAuLi4NCg0KQmFydC4=
