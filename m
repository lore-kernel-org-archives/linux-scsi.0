From: Joe Perches <joe@perches.com>
Subject: Re: [-next PATCH 2/4] treewide: Use DEVICE_ATTR_RW
Date: Wed, 20 Dec 2017 01:24:44 -0800
Message-ID: <1513761884.1234.83.camel@perches.com>
References: <cover.1513706701.git.joe@perches.com>
 <cd38f14f06e1f447b3159ffe8c69c0df8241bb6e.1513706701.git.joe@perches.com>
 <20171220083403.GA27231@bitmer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20171220083403.GA27231@bitmer.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org, Jaroslav Kysela <perex@perex.cz>, Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-s390@vger.kernel.org, linux-omap@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, James Smart <james.smart@broadcom.com>, Cezary Jackiewicz <cezary.jackiewicz@gmail.com>, linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, Darren Hart <dvhart@infradead.org>, Zhang Rui <rui.zhang@intel.com>, Dick Kennedy <dick.kennedy@broadcom.com>, Mathias Nyman <mathias.nyman@intel.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Peter Oberparleiter <oberp>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE3LTEyLTIwIGF0IDEwOjM0ICswMjAwLCBKYXJra28gTmlrdWxhIHdyb3RlOgo+
IE9uIFR1ZSwgRGVjIDE5LCAyMDE3IGF0IDEwOjE1OjA3QU0gLTA4MDAsIEpvZSBQZXJjaGVzIHdy
b3RlOgo+ID4gQ29udmVydCBERVZJQ0VfQVRUUiB1c2VzIHRvIERFVklDRV9BVFRSX1JXIHdoZXJl
IHBvc3NpYmxlLgpbXSAKPiA+IGRpZmYgLS1naXQgYS9zb3VuZC9zb2Mvb21hcC9tY2JzcC5jIGIv
c291bmQvc29jL29tYXAvbWNic3AuYwpbXQo+ID4gQEAgLTg1NCw3ICs4NTQsNyBAQCBzdGF0aWMg
c3NpemVfdCBkbWFfb3BfbW9kZV9zdG9yZShzdHJ1Y3QgZGV2aWNlICpkZXYsCj4gPiAgCXJldHVy
biBzaXplOwo+ID4gIH0KPiA+ICAKPiA+IC1zdGF0aWMgREVWSUNFX0FUVFIoZG1hX29wX21vZGUs
IDA2NDQsIGRtYV9vcF9tb2RlX3Nob3csIGRtYV9vcF9tb2RlX3N0b3JlKTsKPiA+ICtzdGF0aWMg
REVWSUNFX0FUVFJfUlcoZG1hX29wX21vZGUpOwo+ID4gIAo+IAo+IFdoaWxlIEkgY2FuIGFjayB0
aGlzIHBhcnQgaGVyZSBpZiBpdCBoZWxwcyBnZW5lcmljIGNsZWFudXAgZWZmb3J0IEkKPiBkb24n
dCB1bmRlcnN0YXJ0IHdvdWxkIGl0IGltcHJvdmUgY29kZSByZWFkYWJpbGl0eSBpbiBnZW5lcmFs
PyBNb2RlIDY0NAo+IGlzIGNsZWFyIGFuZCBkb24ndCBuZWVkIGFueSBncmVwcGluZyBidXQgZm9y
IERFVklDRV9BVFRSX1JXKCkgSSBoYWQgdG8gZ28KPiB0aHJvdWdoIGFsbCBvZiB0aGVzZSBmaWxl
cyBpbiBvcmRlciB0byBzZWUgd2hhdCBkb2VzIGl0IG1lYW46CgpBcmUgeW91IHN1Z2dlc3Rpbmcg
dGhhdCBkZXZpY2UuaCAoYXMgdGhhdCBpcyB3aGVyZQpERVZJQ0VfQVRUUiBhbmQgdGhlIG90aGVy
IERFVklDRV9BVFRSXzxGT08+IHZhcmlhbnRzCmFyZSAjZGVmaW5lZCkgc2hvdWxkIGhhdmUgYmV0
dGVyIGNvbW1lbnRzIGZvciB0aGUKXzxGT08+IHZhcmlhbnRzPwoKPiBERVZJQ0VfQVRUUl9SVzog
aW5jbHVkZS9saW51eC9kZXZpY2UuaAo+IF9fQVRUUl9SVzogaW5jbHVkZS9saW51eC9zeXNmcy5o
Cj4gU19JV1VTUjogaW5jbHVkZS91YXBpL2xpbnV4L3N0YXQuaAo+IFNfSVJVR086IGluY2x1ZGUv
bGludXgvc3RhdC5oCgpidHc6IHBhdGNoIDEvNCBvZiB0aGUgc2VyaWVzIGRvZXMgcmVtb3ZlIHRo
ZSB1c2VzIG9mClNfPFBFUk1TPiBmcm9tIHRoZXNlIG1hY3JvcyBpbiBzeXNmcy5oIGFuZCBjb252
ZXJ0cwp0aGVtIHRvIHNpbXBsZSBvY3RhbCBpbnN0ZWFkLgoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2
ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21h
aWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
