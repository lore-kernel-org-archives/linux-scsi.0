From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RFC PATCH] mpt3sas: mpt3sas_scsih_enclosure_find_by_handle can
 be static
Date: Tue, 27 Mar 2018 18:55:19 +0000
Message-ID: <289588bbff4dc0d35e519d0c4d4282da78cc6121.camel@wdc.com>
References: <1521540956-42347-1-git-send-email-chaitra.basappa@broadcom.com>
         <20180320210652.GA40906@xian>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180320210652.GA40906@xian>
Content-Language: en-US
Content-ID: <836F3B3443BA944FA914B3AC7CFDE4F5@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "lkp@intel.com" <lkp@intel.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "jaco@uls.co.za" <jaco@uls.co.za>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE4LTAzLTIxIGF0IDA1OjA2ICswODAwLCBrYnVpbGQgdGVzdCByb2JvdCB3cm90
ZToNCj4gRml4ZXM6IDc5M2E2MjIzYmVlZiAoIm1wdDNzYXM6IENhY2hlIGVuY2xvc3VyZSBwYWdl
cyBkdXJpbmcgZW5jbG9zdXJlIGFkZC4iKQ0KPiBTaWduZWQtb2ZmLWJ5OiBGZW5nZ3VhbmcgV3Ug
PGZlbmdndWFuZy53dUBpbnRlbC5jb20+DQo+IC0tLQ0KPiAgbXB0M3Nhc19zY3NpaC5jIHwgICAg
MiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL21wdDNzYXMvbXB0M3Nhc19zY3NpaC5jIGIv
ZHJpdmVycy9zY3NpL21wdDNzYXMvbXB0M3Nhc19zY3NpaC5jDQo+IGluZGV4IGM5M2M1YzUuLjY3
YTQzOTU3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvbXB0M3Nhcy9tcHQzc2FzX3Njc2lo
LmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL21wdDNzYXMvbXB0M3Nhc19zY3NpaC5jDQo+IEBAIC0x
MzcwLDcgKzEzNzAsNyBAQCBtcHQzc2FzX3Njc2loX2V4cGFuZGVyX2ZpbmRfYnlfaGFuZGxlKHN0
cnVjdCBNUFQzU0FTX0FEQVBURVIgKmlvYywgdTE2IGhhbmRsZSkNCj4gICAqIFRoaXMgc2VhcmNo
ZXMgZm9yIGVuY2xvc3VyZSBkZXZpY2UgYmFzZWQgb24gaGFuZGxlLCB0aGVuIHJldHVybnMgdGhl
DQo+ICAgKiBlbmNsb3N1cmUgb2JqZWN0Lg0KPiAgICovDQo+IC1zdHJ1Y3QgX2VuY2xvc3VyZV9u
b2RlICoNCj4gK3N0YXRpYyBzdHJ1Y3QgX2VuY2xvc3VyZV9ub2RlICoNCj4gIG1wdDNzYXNfc2Nz
aWhfZW5jbG9zdXJlX2ZpbmRfYnlfaGFuZGxlKHN0cnVjdCBNUFQzU0FTX0FEQVBURVIgKmlvYywg
dTE2IGhhbmRsZSkNCj4gIHsNCj4gIAlzdHJ1Y3QgX2VuY2xvc3VyZV9ub2RlICplbmNsb3N1cmVf
ZGV2LCAqcjsNCg0KSGVsbG8gQ2hhaXRyYSwNCg0KQXJlIHlvdSBhd2FyZSB0aGF0IGlmIHRoZSAw
LWRheSB0ZXN0IGluZnJhc3RydWN0dXJlIHN1Z2dlc3RzIGFuIGltcHJvdmVtZW50DQpmb3IgYSBw
YXRjaCB0aGF0IHRoZSBwYXRjaCB0aGF0IHRoYXQgaW1wcm92ZW1lbnQgYXBwbGllcyB0byBnZXRz
IGlnbm9yZWQNCnVubGVzcyBlaXRoZXIgdGhlIHBhdGNoIGlzIHJlcG9zdGVkIHdpdGggdGhlIGlt
cHJvdmVtZW50IGFwcGxpZWQgb3IgdGhhdCBpdA0KaXMgZXhwbGFpbmVkIHdoeSB0aGUgc3VnZ2Vz
dGVkIGltcHJvdmVtZW50IGlzIGluYXBwcm9wcmlhdGU/DQoNClRoYW5rcywNCg0KQmFydC4NCg0K
DQo=
