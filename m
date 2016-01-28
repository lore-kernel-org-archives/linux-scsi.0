From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] scsi: storvsc: Fix a build issue reported by kbuild
 test robot
Date: Thu, 28 Jan 2016 19:07:28 +0000
Message-ID: <BY2PR0301MB1654D5EDF0A489A1E212BF6AA0DA0@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1453966147-10568-1-git-send-email-kys@microsoft.com>
 <20160128155613.GA12447@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0119.outbound.protection.outlook.com ([207.46.100.119]:64838
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751692AbcA1THa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 14:07:30 -0500
In-Reply-To: <20160128155613.GA12447@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogT2xhZiBIZXJpbmcgW21h
aWx0bzpvbGFmQGFlcGZsZS5kZV0NCj4gU2VudDogVGh1cnNkYXksIEphbnVhcnkgMjgsIDIwMTYg
Nzo1NiBBTQ0KPiBUbzogS1kgU3Jpbml2YXNhbiA8a3lzQG1pY3Jvc29mdC5jb20+DQo+IENjOiBn
cmVna2hAbGludXhmb3VuZGF0aW9uLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsN
Cj4gZGV2ZWxAbGludXhkcml2ZXJwcm9qZWN0Lm9yZzsgb2hlcmluZ0BzdXNlLmNvbTsNCj4gamJv
dHRvbWxleUBwYXJhbGxlbHMuY29tOyBoY2hAaW5mcmFkZWFkLm9yZzsgbGludXgtc2NzaUB2Z2Vy
Lmtlcm5lbC5vcmc7DQo+IGFwd0BjYW5vbmljYWwuY29tOyB2a3V6bmV0c0ByZWRoYXQuY29tOyBq
YXNvd2FuZ0ByZWRoYXQuY29tOw0KPiBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbTsgaGFyZUBz
dXNlLmRlDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8xXSBzY3NpOiBzdG9ydnNjOiBGaXggYSBi
dWlsZCBpc3N1ZSByZXBvcnRlZCBieSBrYnVpbGQgdGVzdA0KPiByb2JvdA0KPiANCj4gT24gV2Vk
LCBKYW4gMjcsIEsuIFkuIFNyaW5pdmFzYW4gd3JvdGU6DQo+IA0KPiA+ICsJZGVwZW5kcyBvbiBT
Q1NJX0ZDX0FUVFJTDQo+IA0KPiBJIHRoaW5rICdkZXBlbmRzJyBpbnN0ZWFkIG9mICdzZWxlY3Qn
IHdpbGwgY2F1c2UgSFlQRVJWX1NUT1JBR0UgdG8NCj4gZGlzYXBlcGFyIGR1cmluZyBtYWtlIG9s
ZGNvbmZpZyBpZiBTQ1NJX0ZDX0FUVFJTIHdhcyBub3Qgc2V0IGJlZm9yZS4NCj4gTm90IHN1cmUg
d2hhdCB0aGUgcG9saWN5IG9mICdkZXBlbmRzJyB2cy4gICdzZWxlY3QnIGFjdHVhbGx5IGlzLiAg
SWYNCj4gU0NTSV9GQ19BVFRSUyBpcyBzdXBwb3NlZCB0byBiZSBhIGxpYnJhcnkga2luZCBvZiB0
aGluZyB0aGVuICdzZWxlY3QnDQo+IG1pZ2h0IGJlIHRoZSBjb3JyZWN0IHdheS4NCg0KVGhlIGN1
cnJlbnQgYnVpbGQgaXNzdWUgaXMgYmVjYXVzZSB0aGUgSHlwZXItViBzdG9yYWdlIGlzIGNvbmZp
Z3VyZWQgdG8gYmUgYnVpbHQgd2l0aA0KdGhlIGtlcm5lbCB3aGlsZSB0aGUgU0NTSV9GQ19BQVRS
UyBpcyBjb25maWd1cmVkIGFzIGEgbW9kdWxlLiBUaGlzIHBhdGNoIGZpeGVzIHRoYXQgaXNzdWUu
DQpJIHRvbyBhbSBub3Qgc3VyZSB3aGF0IHRoZSBwb2xpY3kgb2YgdXNpbmcgImRlcGVuZHMiIHZz
ICIgc2VsZWN0IiBpcy4NCkphbWVzLCB3aGF0IHdvdWxkIGJlIHlvdXIgcmVjb21tZW5kYXRpb24g
aGVyZS4NCg0KUmVnYXJkcywNCg0KSy4gWQ0KPiANCj4gT2xhZg0K
