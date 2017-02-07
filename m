From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH][V2] scsi: aacraid: rcode is unsigned and should be
 signed int
Date: Tue, 7 Feb 2017 19:35:54 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8B7200@avsrvexchmbx2.microsemi.net>
References: <20170207115129.18948-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170207115129.18948-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ29saW4gS2luZyBbbWFp
bHRvOmNvbGluLmtpbmdAY2Fub25pY2FsLmNvbV0NCj4gU2VudDogVHVlc2RheSwgRmVicnVhcnkg
NywgMjAxNyAzOjUxIEFNDQo+IFRvOiBkbC1lc2MtQWFjcmFpZCBMaW51eCBEcml2ZXIgPGFhY3Jh
aWRAbWljcm9zZW1pLmNvbT47IEphbWVzIEUgLiBKIC4NCj4gQm90dG9tbGV5IDxqZWpiQGxpbnV4
LnZuZXQuaWJtLmNvbT47IE1hcnRpbiBLIC4gUGV0ZXJzZW4NCj4gPG1hcnRpbi5wZXRlcnNlbkBv
cmFjbGUuY29tPjsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGtlcm5lbC1qYW5p
dG9yc0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3Vi
amVjdDogW1BBVENIXVtWMl0gc2NzaTogYWFjcmFpZDogcmNvZGUgaXMgdW5zaWduZWQgYW5kIHNo
b3VsZCBiZSBzaWduZWQgaW50DQo+IA0KPiBFWFRFUk5BTCBFTUFJTA0KPiANCj4gDQo+IEZyb206
IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IA0KPiBhYWNfZmli
X3NlbmQgY2FuIHJldHVybiAtdmUgZXJyb3IgcmV0dXJucyBhbmQgaGVuY2UgcmNvZGUgc2hvdWxk
DQo+IGJlIHNpZ25lZC4gQ3VycmVudGx5IHRoZSByY29kZSA+PSAwIGNoZWNrIGlzIGFsd2F5cyB0
cnVlIGFuZCAtdmUNCj4gZXJyb3JzIGFyZSBub3QgYmVpbmcgY2hlY2tlZC4NCj4gDQo+IFRoYW5r
cyB0byBEYW4gQ2FycGVudGVyIGZvciBzcG90dGluZyBteSBvcmlnaW5hbCBicm9rZW4gZml4IHRv
IHRoaXMNCj4gaXNzdWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29s
aW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IFJhZ2hhdmEgQWRp
dHlhIFJlbnVrdW50YSA8UmFnaGF2YUFkaXR5YS5SZW51a3VudGFAbWljcm9zZW1pLmNvbT4NCg0K
