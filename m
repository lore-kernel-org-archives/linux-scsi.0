From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [-next PATCH 2/4] treewide: Use DEVICE_ATTR_RW
Date: Wed, 10 Jan 2018 16:43:02 +0200
Message-ID: <41847882-9ad9-aeb1-009b-2f9b2fdb656e@ti.com>
References: <cover.1513706701.git.joe@perches.com>
 <cd38f14f06e1f447b3159ffe8c69c0df8241bb6e.1513706701.git.joe@perches.com>
 <20171220083403.GA27231@bitmer.com> <1513761884.1234.83.camel@perches.com>
 <20171220093211.GA16177@kroah.com> <20171220105404.GA29856@bitmer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20171220105404.GA29856@bitmer.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jarkko Nikula <jarkko.nikula@bitmer.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org, Jaroslav Kysela <perex@perex.cz>, linux-s390@vger.kernel.org, linux-omap@vger.kernel.org, "James E.J.
 Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, James Smart <james.smart@broadcom.com>, Cezary Jackiewicz <cezary.jackiewicz@gmail.com>, linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, Darren Hart <dvhart@infradead.org>, Zhang Rui <rui.zhang@intel.com>, Dick Kennedy <dick.kennedy@broadcom.com>, Mathias Nyman <mathias.nyman@intel.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, intel-gfx@lists.
List-Id: linux-scsi@vger.kernel.org

CgpPbiAyMDE3LTEyLTIwIDEyOjU0LCBKYXJra28gTmlrdWxhIHdyb3RlOgo+IE9uIFdlZCwgRGVj
IDIwLCAyMDE3IGF0IDEwOjMyOjExQU0gKzAxMDAsIEdyZWcgS3JvYWgtSGFydG1hbiB3cm90ZToK
Pj4gT24gV2VkLCBEZWMgMjAsIDIwMTcgYXQgMDE6MjQ6NDRBTSAtMDgwMCwgSm9lIFBlcmNoZXMg
d3JvdGU6Cj4+PiBPbiBXZWQsIDIwMTctMTItMjAgYXQgMTA6MzQgKzAyMDAsIEphcmtrbyBOaWt1
bGEgd3JvdGU6Cj4+Pj4gT24gVHVlLCBEZWMgMTksIDIwMTcgYXQgMTA6MTU6MDdBTSAtMDgwMCwg
Sm9lIFBlcmNoZXMgd3JvdGU6Cj4+Pj4+IENvbnZlcnQgREVWSUNFX0FUVFIgdXNlcyB0byBERVZJ
Q0VfQVRUUl9SVyB3aGVyZSBwb3NzaWJsZS4KPj4+IFtdIAo+Pj4+PiBkaWZmIC0tZ2l0IGEvc291
bmQvc29jL29tYXAvbWNic3AuYyBiL3NvdW5kL3NvYy9vbWFwL21jYnNwLmMKPj4+IFtdCj4+Pj4+
IEBAIC04NTQsNyArODU0LDcgQEAgc3RhdGljIHNzaXplX3QgZG1hX29wX21vZGVfc3RvcmUoc3Ry
dWN0IGRldmljZSAqZGV2LAo+Pj4+PiAgCXJldHVybiBzaXplOwo+Pj4+PiAgfQo+Pj4+PiAgCj4+
Pj4+IC1zdGF0aWMgREVWSUNFX0FUVFIoZG1hX29wX21vZGUsIDA2NDQsIGRtYV9vcF9tb2RlX3No
b3csIGRtYV9vcF9tb2RlX3N0b3JlKTsKPj4+Pj4gK3N0YXRpYyBERVZJQ0VfQVRUUl9SVyhkbWFf
b3BfbW9kZSk7Cj4+Pj4+ICAKPj4+Pgo+Pj4+IFdoaWxlIEkgY2FuIGFjayB0aGlzIHBhcnQgaGVy
ZSBpZiBpdCBoZWxwcyBnZW5lcmljIGNsZWFudXAgZWZmb3J0IEkKPj4+PiBkb24ndCB1bmRlcnN0
YXJ0IHdvdWxkIGl0IGltcHJvdmUgY29kZSByZWFkYWJpbGl0eSBpbiBnZW5lcmFsPyBNb2RlIDY0
NAo+Pj4+IGlzIGNsZWFyIGFuZCBkb24ndCBuZWVkIGFueSBncmVwcGluZyBidXQgZm9yIERFVklD
RV9BVFRSX1JXKCkgSSBoYWQgdG8gZ28KPj4+PiB0aHJvdWdoIGFsbCBvZiB0aGVzZSBmaWxlcyBp
biBvcmRlciB0byBzZWUgd2hhdCBkb2VzIGl0IG1lYW46Cj4+Cj4+IFllYWgsIDY0NCBpcyAiY2xl
YXIiLCBidXQgX1JXKCkgaXMgZXZlbiBtb3JlIGNsZWFyLiAgSWRlYWxseSBJIHdhbnQgdG8KPj4g
Z2V0IHJpZCBvZiBhbGwgb2YgdGhlICJub24tc3RhbmRhcmQiIHVzZXJzIHRoYXQgc2V0IHJhbmRv
bSBtb2RlcyBvZgo+PiBzeXNmcyBmaWxlcywgYXMgd2UgZ2V0IGl0IHdyb25nIHRvbyBtYW55IHRp
bWVzLiAgVXNpbmcgdGhlICJkZWZhdWx0cyIgaXMKPj4gbXVjaCBiZXR0ZXIuCj4+Cj4gRmFpciBl
bm91Z2guIEZvciB0aGUgc291bmQvc29jL29tYXAvIChBY2tlZC1ieSB3YXMgbWlzc2luZyBmcm9t
IG15Cj4gcHJldmlvdXMgcmVwbHkpOgo+IAo+IEFja2VkLWJ5OiBKYXJra28gTmlrdWxhIDxqYXJr
a28ubmlrdWxhQGJpdG1lci5jb20+CgpBbmQgZnJvbSBtZSB0byB0aGUgc2FtZSBmaWxlIChzb3Vu
ZC9zb2Mvb21hcC9tY2JzcC5jKToKCkFja2VkLWJ5OiBQZXRlciBVamZhbHVzaSA8cGV0ZXIudWpm
YWx1c2lAdGkuY29tPgoKCi0gUMOpdGVyCgpUZXhhcyBJbnN0cnVtZW50cyBGaW5sYW5kIE95LCBQ
b3Jra2FsYW5rYXR1IDIyLCAwMDE4MCBIZWxzaW5raS4KWS10dW5udXMvQnVzaW5lc3MgSUQ6IDA2
MTU1MjEtNC4gS290aXBhaWtrYS9Eb21pY2lsZTogSGVsc2lua2kKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmkt
ZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3Jn
L21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
