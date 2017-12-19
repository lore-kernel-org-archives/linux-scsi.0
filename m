From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [-next PATCH 2/4] treewide: Use DEVICE_ATTR_RW
Date: Tue, 19 Dec 2017 20:41:57 +0200
Message-ID: <CAHp75VfyvA3kAtGiwJ63BOx43RuVSz-XgdK79WApytoaehOOgQ@mail.gmail.com>
References: <cover.1513706701.git.joe@perches.com>
 <cd38f14f06e1f447b3159ffe8c69c0df8241bb6e.1513706701.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <cd38f14f06e1f447b3159ffe8c69c0df8241bb6e.1513706701.git.joe@perches.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Joe Perches <joe@perches.com>
Cc: linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>, Heiko Carstens <heiko.carstens@de.ibm.com>, ALSA Development Mailing List <alsa-devel@alsa-project.org>, dri-devel@lists.freedesktop.org, Jaroslav Kysela <perex@perex.cz>, Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-s390@vger.kernel.org, Linux OMAP Mailing List <linux-omap@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Takashi Iwai <tiwai@suse.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, James Smart <james.smart@broadcom.com>, Cezary Jackiewicz <cezary.jackiewicz@gmail.com>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, Jiri Slaby <jslaby@suse.com>, Darren Hart <dvhart@infradead.org>, Zhang Rui <rui.zhang@intel.com>, Dick Kennedy <dick.kennedy@broadcom.com>, Mathias Nyman <mathias.nyman@intel.com>, Bartlomiej
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCBEZWMgMTksIDIwMTcgYXQgODoxNSBQTSwgSm9lIFBlcmNoZXMgPGpvZUBwZXJjaGVz
LmNvbT4gd3JvdGU6Cj4gQ29udmVydCBERVZJQ0VfQVRUUiB1c2VzIHRvIERFVklDRV9BVFRSX1JX
IHdoZXJlIHBvc3NpYmxlLgo+Cj4gRG9uZSB3aXRoIHBlcmwgc2NyaXB0Ogo+Cj4gJCBnaXQgZ3Jl
cCAtdyAtLW5hbWUtb25seSBERVZJQ0VfQVRUUiB8IFwKPiAgIHhhcmdzIHBlcmwgLWkgLWUgJ2xv
Y2FsICQvOyB3aGlsZSAoPD4pIHsgcy9cYkRFVklDRV9BVFRSXHMqXChccyooXHcrKVxzKixccypc
KD8oXHMqU19JUlVHT1xzKlx8XHMqU19JV1VTUnxccypTX0lXVVNSXHMqXHxccypTX0lSVUdPXHMq
fFxzKjA2NDRccyopXCk/XHMqLFxzKlwxX3Nob3dccyosXHMqXDFfc3RvcmVccypcKS9ERVZJQ0Vf
QVRUUl9SVyhcMSkvZzsgcHJpbnQ7fScKCj4gIGRyaXZlcnMvcGxhdGZvcm0veDg2L2NvbXBhbC1s
YXB0b3AuYyB8IDE4ICsrKysrLS0tLS0tLS0tLQoKPiAtLS0gYS9kcml2ZXJzL3BsYXRmb3JtL3g4
Ni9jb21wYWwtbGFwdG9wLmMKPiArKysgYi9kcml2ZXJzL3BsYXRmb3JtL3g4Ni9jb21wYWwtbGFw
dG9wLmMKPiBAQCAtNjc5LDE4ICs2NzksMTIgQEAgc3RhdGljIGludCBiYXRfd3JpdGVhYmxlX3By
b3BlcnR5KHN0cnVjdCBwb3dlcl9zdXBwbHkgKnBzeSwKPiAgLyogPT09PT09PT09PT09PT0gKi8K
PiAgLyogRHJpdmVyIEdsb2JhbHMgKi8KPiAgLyogPT09PT09PT09PT09PT0gKi8KPiAtc3RhdGlj
IERFVklDRV9BVFRSKHdha2VfdXBfcG1lLAo+IC0gICAgICAgICAgICAgICAwNjQ0LCB3YWtlX3Vw
X3BtZV9zaG93LCAgICAgICAgIHdha2VfdXBfcG1lX3N0b3JlKTsKPiAtc3RhdGljIERFVklDRV9B
VFRSKHdha2VfdXBfbW9kZW0sCj4gLSAgICAgICAgICAgICAgIDA2NDQsIHdha2VfdXBfbW9kZW1f
c2hvdywgICAgICAgd2FrZV91cF9tb2RlbV9zdG9yZSk7Cj4gLXN0YXRpYyBERVZJQ0VfQVRUUih3
YWtlX3VwX2xhbiwKPiAtICAgICAgICAgICAgICAgMDY0NCwgd2FrZV91cF9sYW5fc2hvdywgd2Fr
ZV91cF9sYW5fc3RvcmUpOwo+IC1zdGF0aWMgREVWSUNFX0FUVFIod2FrZV91cF93bGFuLAo+IC0g
ICAgICAgICAgICAgICAwNjQ0LCB3YWtlX3VwX3dsYW5fc2hvdywgICAgICAgIHdha2VfdXBfd2xh
bl9zdG9yZSk7Cj4gLXN0YXRpYyBERVZJQ0VfQVRUUih3YWtlX3VwX2tleSwKPiAtICAgICAgICAg
ICAgICAgMDY0NCwgd2FrZV91cF9rZXlfc2hvdywgd2FrZV91cF9rZXlfc3RvcmUpOwo+IC1zdGF0
aWMgREVWSUNFX0FUVFIod2FrZV91cF9tb3VzZSwKPiAtICAgICAgICAgICAgICAgMDY0NCwgd2Fr
ZV91cF9tb3VzZV9zaG93LCAgICAgICB3YWtlX3VwX21vdXNlX3N0b3JlKTsKPiArc3RhdGljIERF
VklDRV9BVFRSX1JXKHdha2VfdXBfcG1lKTsKPiArc3RhdGljIERFVklDRV9BVFRSX1JXKHdha2Vf
dXBfbW9kZW0pOwo+ICtzdGF0aWMgREVWSUNFX0FUVFJfUlcod2FrZV91cF9sYW4pOwo+ICtzdGF0
aWMgREVWSUNFX0FUVFJfUlcod2FrZV91cF93bGFuKTsKPiArc3RhdGljIERFVklDRV9BVFRSX1JX
KHdha2VfdXBfa2V5KTsKPiArc3RhdGljIERFVklDRV9BVFRSX1JXKHdha2VfdXBfbW91c2UpOwoK
QWNrZWQtYnk6IEFuZHkgU2hldmNoZW5rbyA8YW5keS5zaGV2Y2hlbmtvQGdtYWlsLmNvbT4KCmZv
ciBQRHg4NiBiaXRzLgoKSGF2ZSB0byBzYXkgdGhhdCB3aGlsZSBpdCBkb2Vzbid0IGNoYW5nZSB0
aGUgYXR0cmlidXRlcyBoZXJlLCBpdCBtaWdodApyZXF1aXJlIHN0aWxsIHRvIGJlIHJldmlzaXRl
ZCBieSBzZWN1cml0eSBwZW9wbGUsIGlmIHRoZXkgd2lzaC4KCi0tIApXaXRoIEJlc3QgUmVnYXJk
cywKQW5keSBTaGV2Y2hlbmtvCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCkludGVsLWdmeCBtYWlsaW5nIGxpc3QKSW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNr
dG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2lu
dGVsLWdmeAo=
