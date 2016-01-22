From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Fri, 22 Jan 2016 03:31:59 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB4451737F@G4W3219.americas.hpqcorp.net>
References: <20151218170644.24167419@harpe.intellique.com>
 <alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr>
 <20160104124626.3112e8c0@harpe.intellique.com>
 <CAAzz28iCoG-rjnL7EsjHXA7UtRJSCEXuwL3+27ZBo7fckcBAfg@mail.gmail.com>
 <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com>
 <20160106161049.34f29973@harpe.intellique.com>
 <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com>
 <20160106170720.61db9e86@harpe.intellique.com>
 <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com>
 <DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net>
 <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi>
 <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:6968 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbcAVDcS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2016 22:32:18 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
Cc: Laurence Oberman <loberman@redhat.com>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

TXkgYXBwbG9naWVzOg0KDQo+IEl0IG1heSBiZSB3b3J0aCBub3RpbmcgKGlmIHlvdSdyZSBnb2lu
ZyB0byB1cGRhdGUgYW55IGRvY3VtZW50YXRpb24pIHRoYXQNCj4gaXNuJ3QgMTAwJSBhY2N1cmF0
ZS4gWW91IGFjdHVhbGx5IGdldCBvbmUgd3JhcCBpbiBwYXJ0aXRpb24gMSBhbmQgdGhlIHJlc3QN
Cj4gbWludXMgb25lIHdyYXAgaW50byBwYXJ0aXRpb24gMC4gVGhlcmUgaXMgb25lIHdyYXAgdXNl
ZCBhcyBhIGd1YXJkIGJldHdlZW4NCj4gdGhlIHR3byBwYXJ0aXRpb25zLiBUaGUgc2l6ZSBnaXZl
biB0byBhIHBhcnRpdGlvbiBpcyByb3VuZGVkIHVwIHRvIHRoZSBzaXplIG9mIGENCj4gd3JhcCBh
cyB3ZWxsLg0KPiANCj4gU2VlDQo+IGh0dHBzOi8vZG9jcy5vcmFjbGUuY29tL2NkL0UyMTQxOV8w
NC9lbi9MVE81X1ZvbDNfRTViL0xUTzVfVm9sM19FNWIuDQo+IHBkZg0KPiANCj4gUGFnZSAxMDAg
d2hlcmUgaXQgZ2l2ZXMgZXhhbXBsZXMgb2YgaG93IHBhcnRpdGlvbiBzaXplcyBhcmUgY2FsY3Vs
YXRlZCBvbiBIUA0KPiBMVE81IGRyaXZlcy4NCg0KSSBzaG91bGQgaGF2ZSBhY3R1YWxseSBzYWlk
Og0KDQpZb3UgZG8gZ2V0IHR3byB3cmFwcyBhcyBhIG1pbmltdW0gaW4gcGFydGl0aW9uIDEgYW5k
IHRoZSByZXN0IG1pbnVzIHR3byB3cmFwcw0KaW50byBwYXJ0aXRpb24gMC4gVGhlIGV4dHJhIHR3
byB3cmFwcyBhcmUgdXNlZCBhcyBhIGd1YXJkIGJldHdlZW4gdGhlIHR3byBwYXJ0aXRpb25zDQph
bmQgYWxsIHNpemVzIHdpbGwgYmUgcm91bmRlZCB0byBhIG11bHRpcGxlIG9mIHR3byB3cmFwcy4N
Cg0KVGhhdCB3YXMganVzdCB0byBtYWtlIGl0IGNsZWFyIHRoYXQgcGFydGl0aW9uIHNpemVzIHdp
bGwgYWx3YXlzIGVuZCB1cCBiZWluZyBhIG11bHRpcGxlDQpvZiAyeCB0aGUgd3JhcCBzaXplIGFu
ZCB0aGF0IHRoZXJlIHdhcyBzb21lIGZpeGVkIG92ZXJoZWFkIGluIHBhcnRpdGlvbmluZyBhbg0K
TFRPNSsgZHJpdmUgKDIgd3JhcHMpLg0K
