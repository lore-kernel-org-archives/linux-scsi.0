From: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Subject: RE: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Tue, 23 Jun 2015 14:15:14 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CB55366@AcuExch.aculab.com>
References: <Pine.LNX.4.44L0.1506221324110.1799-100000@iolanthe.rowland.org>
 <1434994588.2237.90.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434994588.2237.90.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Content-Language: en-US
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'James Bottomley' <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, James Bottomley <JBottomley-MU7nAjRaF3makBO8gow8eQ@public.gmane.org>, Jun Itou <itou_jun-6LX5ZuzTTw53+QwDJ9on6Q@public.gmane.org>, Markus Rathgeb <maggu2810-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt <vickm78-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

RnJvbTogT2YgSmFtZXMgQm90dG9tbGV5DQo+IFNlbnQ6IDIyIEp1bmUgMjAxNSAxODozNg0KPiBU
bzogQWxhbiBTdGVybg0KLi4uDQo+ID4gPiBPYnZpb3VzbHksIGZvciBhIGRpc2sgd2l0aCBhIHdy
aXRlYmFjayBjYWNoZSB0aGF0IGNhbid0IGRvIGZsdXNoLCB0aGF0DQo+ID4gPiB3aW5kb3cgaXMg
bXVjaCB3aWRlciBhbmQgdGhlIHJlYWwgc29sdXRpb24gc2hvdWxkIGJlIHRvIHRyeSB0byBzd2l0
Y2gNCj4gPiA+IHRoZSBjYWNoZSB0byB3cml0ZSB0aHJvdWdoLg0KPiA+DQo+ID4gSSBhZ3JlZS4g
IERvaW5nIHRoZSBzd2l0Y2ggbWFudWFsbHkgKGJ5IHdyaXRpbmcgdG8gdGhlICJjYWNoZV90eXBl
Ig0KPiA+IGF0dHJpYnV0ZSBmaWxlKSB3b3JrcywgYnV0IGl0J3MgYSBudWlzYW5jZSB0byBkbyB0
aGlzIHdoZW4geW91IGhhdmUgYQ0KPiA+IHBvcnRhYmxlIFVTQiBkcml2ZSB0aGF0IGdldHMgbW92
ZWQgYW1vbmcgYSBidW5jaCBvZiBtYWNoaW5lcy4NCj4gDQo+IFBlcmhhcHMgaXQgbWlnaHQgYmUg
d2lzZSB0byBkbyB0aGlzIHRvIGV2ZXJ5IFVTQiBkZXZpY2UgLi4uIGZvciBleHRlcm5hbA0KPiBk
ZXZpY2VzLCB0aGUgc21hbGwgcGVyZm9ybWFuY2UgZ2FpbiBkb2Vzbid0IHJlYWxseSBtYWtlIHVw
IGZvciB0aGUNCj4gcG90ZW50aWFsIGRhdGEgbG9zcy4NCg0KV2hhdCBhYm91dCBzeXN0ZW1zIHJ1
bm5pbmcgZnJvbSBVU0IgbWVtb3J5L2Rpc2sgZGlyZWN0bHkgcGx1Z2dlZCBpbnRvIHRoZQ0KbW90
aGVyYm9hcmQgYW5kIHNodXQgaW5zaWRlIHRoZSBjYXNlPw0KDQpTaW5jZSB0aGV5IHNob3VsZG4n
dCBiZSByZW1vdmVkIHlvdSBkb24ndCB3YW50IHRvIGJ5cGFzcyBhbnkgd3JpdGUgY2FjaGUuDQoo
QW55IG1vcmUgdGhhbiB5b3UnZCB3YW50IHRvIG9uIGEgcmVhbCBkaXNrLikNCg0KVGhlcmUgaXMg
YW4gYWRkaXRpb25hbCBwcm9ibGVtIGNhdXNlZCBieSB2ZXJ5IHRlbXBvcmFyeSBVU0IgZGlzY29u
bmVjdHMNCihlYXNpbHkgY2F1c2VkIGJ5IGVsZWN0cmljYWwgbm9pc2UgY2F1c2luZyAocHJvYmFi
bHkpIFZidXMgdG8gYm91bmNlKS4NCkluIHRoZXNlIGNvbmRpdGlvbnMgeW91IGRvbid0IHdhbnQg
dG8gc2lnbmFsIGEgVVNCIHJlbW92ZSBhdCBhbGwgLSBhdA0KbGVhc3Qgbm90IHRvIHRoZSBmaWxl
c3lzdGVtIC0gdW50aWwgdGhlIGRldmljZSBoYXMgcmVtYWluZWQgZGlzY29ubmVjdGVkDQpmb3Ig
YSBzaG9ydCB0aW1lLg0KDQoJRGF2aWQNCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
