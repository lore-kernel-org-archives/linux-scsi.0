From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
Date: Fri, 30 Nov 2018 14:40:19 -0800
Message-ID: <20181130224019.GA27562@linux.intel.com>
References: <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
 <20181130195652.7syqys76646kpaph@linux-r8p5>
 <20181130205521.GA21006@linux.intel.com>
 <1543611662.3031.20.camel@HansenPartnership.com>
 <20181130214405.GG23772@linux.intel.com>
 <1543615069.3031.27.camel@HansenPartnership.com>
 <20181130221219.GA25537@linux.intel.com>
 <20181130151459.3ca2f5c8@lwn.net>
 <20181130222605.GA26261@linux.intel.com>
 <1543617045.3031.41.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <1543617045.3031.41.camel@HansenPartnership.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>, Geert Uytterhoeven <geert+renesas@glider.be>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, nouveau <nouveau@lists.freedesktop.org>, Amir Goldstein <amir73il@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-ide@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Linux mtd <linux-mtd@lists.infradead.org>, makita.toshiaki@lab.ntt.co.jp, yanjun.zhu@oracle.com, Davidlohr Bueso <dave@stgolabs.net>, linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Helge Deller <deller@gmx.de>, federico.vaga@vaga.pv.it, Yonghong Song <yhs@fb.com>, Paolo Abeni <pabeni@redhat.com>, Linux Media Mailing List <linux-media@vger.kernel.org>, Petr Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>, Linux PM list <linux-pm@vger.kernel.org>, shannon.nelson@oracle.com, sean.wang@mediatek.com, Steven
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCBOb3YgMzAsIDIwMTggYXQgMDI6MzA6NDVQTSAtMDgwMCwgSmFtZXMgQm90dG9tbGV5
IHdyb3RlOgo+IE9uIEZyaSwgMjAxOC0xMS0zMCBhdCAxNDoyNiAtMDgwMCwgSmFya2tvIFNha2tp
bmVuIHdyb3RlOgo+ID4gT24gRnJpLCBOb3YgMzAsIDIwMTggYXQgMDM6MTQ6NTlQTSAtMDcwMCwg
Sm9uYXRoYW4gQ29yYmV0IHdyb3RlOgo+IFsuLi5dCj4gPiA+IEhhdmUgeW91IHJlYWQgRG9jdW1l
bnRhdGlvbi9wcm9jZXNzL2NvZGUtb2YtY29uZHVjdC0KPiA+ID4gaW50ZXJwcmV0YXRpb24ucnN0
PyAKPiA+ID4gQXMgaGFzIGJlZW4gcG9pbnRlZCBvdXQsIGl0IGNvbnRhaW5zIGEgY2xlYXIgYW5z
d2VyIHRvIGhvdyB0aGluZ3MKPiA+ID4gc2hvdWxkIGJlIGludGVycHJldGVkIGhlcmUuCj4gPiAK
PiA+IFVnaCwgd2FzIG5vdCBhd2FyZSB0aGF0IHRoZXJlIHR3byBkb2N1bWVudHMuCj4gPiAKPiA+
IFllYWgsIGRlZmluaXRlbHkgc2hlZHMgbGlnaHQuIFdoeSB0aGUgZG9jdW1lbnRzIGNvdWxkIG5v
dCBiZSBtZXJnZWQKPiA+IHRvIHNpbmdsZSBjb21tb24gc2Vuc2UgY29kZSBvZiBjb25kdWN0Pwo+
IAo+IFRoZSBmYWN0IHRoYXQgd2UndmUgYXJyaXZlZCBhdCBlc3NlbnRpYWxseSBhbiBvcmlnaW5h
bCBDb0MKPiByZWludGVycHJldGVkIHRvIHRoZSBwb2ludCB3aGVyZSBpdCdzIGVmZmVjdGl2ZWx5
IGEgbmV3IENvQyBoYXMgYmVlbgo+IHRoZSBzb3VyY2Ugb2YgbXVjaCBkZWJhdGUgYW5kIHJlY3Jp
bWluYXRpb24gb3ZlciB0aGUgbGFzdCBmZXcgbW9udGhzCj4gLi4uIHlvdSBjYW4gcmVhZCBpdCBp
biB0aGUga3N1bW1pdC1kaXNjdXNzIGFyY2hpdmVzLCBidXQgSSByZWFsbHkgdGhpbmsKPiB3ZSBk
b24ndCB3YW50IHRvIHJlb3BlbiB0aGF0IGNhbiBvZiB3b3Jtcy4KCkdvdCB5b3UuLi4gV2VsbCBJ
IG5vdyByZWFkIHRoZSAybmQgYW1lbmRtZW50IG5vdyB0aHJvdWdoLCBhbmQgeWVhaCwga2luZApv
ZiB3YXkgSSB3b3JrL2Z1bmN0aW9uIGFueXdheS4KClRoYW5rIHlvdSBmb3IgdGhlIHBhdGllbmNl
Li4uCgovSmFya2tvCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9y
ZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZl
bAo=
