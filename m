From: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Subject: RE: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Date: Mon, 15 Apr 2019 11:03:57 +0000
Message-ID: <42fb90eb9c8f4ede8a56a09be90218e3@AcuMS.aculab.com>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-4-alastair@au1.ibm.com>
 <20190412141211.lvnz6wb7mwkykmxf@pathway.suse.cz>
 <093301d4f187$da0756a0$8e1603e0$@d-silva.org>
 <20190415092424.qos7d54nbyr5hphu@pathway.suse.cz>
 <0da301d4f373$01d5bb80$05813280$@d-silva.org>
 <10c791893f034c26b4fee1a4659133e5@AcuMS.aculab.com>
 <0db501d4f378$3bd50bb0$b37f2310$@d-silva.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0db501d4f378$3bd50bb0$b37f2310$@d-silva.org>
Content-Language: en-US
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Alastair D'Silva' <alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org>, 'Petr Mladek' <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: 'Alastair D'Silva' <alastair-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>, 'Jani Nikula' <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, 'Joonas Lahtinen' <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, 'Rodrigo Vivi' <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'David Airlie' <airlied-cv59FeDIM0c@public.gmane.org>, 'Daniel Vetter' <daniel-/w4YWyX8dFk@public.gmane.org>, 'Karsten Keil' <isdn-iHCpqvpFUx0uJkBD2foKsQ@public.gmane.org>, 'Jassi Brar' <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Tom Lendacky' <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, "'David S. Miller'" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, 'Jose Abreu' <Jose.Abreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, 'Kalle Valo' <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, 'Stanislaw Gruszka' <sgruszka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Benson Leung' <bleung-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, 'Enric Balletbo i Serra' <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, "'James E.J. Bottomley'" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "'Martin K. Petersen'" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Greg Kroah-Hartman' <gregk>
List-Id: linux-scsi@vger.kernel.org

RnJvbTogQWxhc3RhaXIgRCdTaWx2YQ0KPiBTZW50OiAxNSBBcHJpbCAyMDE5IDExOjQ1DQouLi4N
Cj4gPiBBbHRob3VnaCBJIHRoaW5rIHlvdSdkIHdhbnQgYSAnbm8gaGV4JyBmbGFnIHRvIHN1cHBy
ZXNzIHRoZSBoZXguDQo+ID4NCj4gPiBQcm9iYWJseSBtb3JlIHVzZWZ1bCBmbGFncyBhcmUgb25l
cyB0byBzdXBwcmVzcyB0aGUgYWRkcmVzcyBjb2x1bW4uDQo+IA0KPiBUaGlzIGlzIGFscmVhZHkg
c3VwcG9ydGVkIGJ5IHRoZSBwcmVmaXhfdHlwZSBwYXJhbWV0ZXIgLSBhcmUgeW91IHByb3Bvc2lu
ZyB0aGF0IHdlIGVsaW1pbmF0ZSB0aGUNCj4gcGFyYW1ldGVyICYgY29tYmluZSBpdCB3aXRoIGZs
YWdzPw0KDQpJIHdhcyBsb29raW5nIGF0IHRoZSBmbGFncyBvbiBvbmUgb2YgbXkgaGV4ZHVtcCgp
IGZ1bmN0aW9ucy4uLg0KDQo+ID4gSSd2ZSBhbHNvIHVzZWQgZmxhZ3MgdG8gZW5hYmxlIChvciBk
aXNhYmxlKSBzdXBwcmVzc2lvbiBvZiBtdWx0aXBsZSBsaW5lcyBvZg0KPiA+IHplcm9zIG9mIGNv
bnN0YW50IGJ5dGVzLg0KPiA+IEluIHRoYXQgY2FzZSB5b3UgbWF5IHdhbnQgaGV4ZHVtcCB0byBy
ZXR1cm4gdGhlIGZsYWdzIGZvciB0aGUgbmV4dCBjYWxsIHdoZW4NCj4gPiBhIGxhcmdlIGJ1ZmZl
ciBpcyBiZWluZyBkdW1wZWQgaW4gZnJhZ21lbnRzLg0KPiANCj4gSSdtIGFmcmFpZCBJIGRvbid0
IHF1aXRlIGZvbGxvdyBoZXJlLCBoZXhfZHVtcF90b19idWZmZXIgZG9lc24ndCBhbHRlciB0aGUg
ZmxhZ3MsDQo+IHNvIHRoZSBjYWxsZXIgYWxyZWFkeSBrbm93cyBpdC4NCg0KSWYgeW91IGFyZSBz
dXBwcmVzc2luZyBsaW5lcyBvZiB6ZXJvcyBhbmQgZHVtcGluZyBhIGJ1ZmZlciBpbiBzZXZlcmFs
IGJsb2Nrcw0KdGhlbiBzdWJzZXF1ZW50IGNhbGxzIG5lZWQgdG8ga25vdyB0aGF0IHRoZSBsYXN0
IGxpbmUgb2YgdGhlIHByZXZpb3VzIGNhbGwNCndhcyBzdXBwcmVzc2VkIHplcm9zIC0gYW5kIGNh
cnJ5IG9uIHdpdGggdGhlIHNhbWUgc3VwcHJlc3NlZCBibG9jay4NCg0KSSd2ZSBub3QgbG9va2Vk
IHRvIHNlZSBpZiBpdCBkb2VzIHN1cHBvcnQgc3VwcHJlc3NpbmcgbGluZXMgb2YgemVyb3MvMHhm
Zi4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBS
b2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9u
IE5vOiAxMzk3Mzg2IChXYWxlcykNCg==
