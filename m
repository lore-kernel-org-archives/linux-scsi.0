From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
Date: Fri, 30 Nov 2018 14:30:45 -0800
Message-ID: <1543617045.3031.41.camel@HansenPartnership.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
 <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
 <20181130195652.7syqys76646kpaph@linux-r8p5>
 <20181130205521.GA21006@linux.intel.com>
 <1543611662.3031.20.camel@HansenPartnership.com>
 <20181130214405.GG23772@linux.intel.com>
 <1543615069.3031.27.camel@HansenPartnership.com>
 <20181130221219.GA25537@linux.intel.com> <20181130151459.3ca2f5c8@lwn.net>
 <20181130222605.GA26261@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20181130222605.GA26261@linux.intel.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>, Geert Uytterhoeven <geert+renesas@glider.be>, "open
 list:DOCUMENTATION" <linux-doc@vger.kernel.org>, nouveau <nouveau@lists.freedesktop.org>, Amir Goldstein <amir73il@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-ide@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Linux mtd <linux-mtd@lists.infradead.org>, makita.toshiaki@lab.ntt.co.jp, yanjun.zhu@oracle.com, Davidlohr Bueso <dave@stgolabs.net>, linux-scsi@vger.kernel.org, Helge Deller <deller@gmx.de>, federico.vaga@vaga.pv.it, Yonghong Song <yhs@fb.com>, Paolo Abeni <pabeni@redhat.com>, Linux Media Mailing List <linux-media@vger.kernel.org>, Petr Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>, Linux PM list <linux-pm@vger.kernel.org>, shannon.nelson@oracle.com, sean.wang@mediatek.com, Steven Rostedt <rostedt@goodmis.org>, Stefan
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE4LTExLTMwIGF0IDE0OjI2IC0wODAwLCBKYXJra28gU2Fra2luZW4gd3JvdGU6
Cj4gT24gRnJpLCBOb3YgMzAsIDIwMTggYXQgMDM6MTQ6NTlQTSAtMDcwMCwgSm9uYXRoYW4gQ29y
YmV0IHdyb3RlOgpbLi4uXQo+ID4gSGF2ZSB5b3UgcmVhZCBEb2N1bWVudGF0aW9uL3Byb2Nlc3Mv
Y29kZS1vZi1jb25kdWN0LQo+ID4gaW50ZXJwcmV0YXRpb24ucnN0PyAKPiA+IEFzIGhhcyBiZWVu
IHBvaW50ZWQgb3V0LCBpdCBjb250YWlucyBhIGNsZWFyIGFuc3dlciB0byBob3cgdGhpbmdzCj4g
PiBzaG91bGQgYmUgaW50ZXJwcmV0ZWQgaGVyZS4KPiAKPiBVZ2gsIHdhcyBub3QgYXdhcmUgdGhh
dCB0aGVyZSB0d28gZG9jdW1lbnRzLgo+IAo+IFllYWgsIGRlZmluaXRlbHkgc2hlZHMgbGlnaHQu
IFdoeSB0aGUgZG9jdW1lbnRzIGNvdWxkIG5vdCBiZSBtZXJnZWQKPiB0byBzaW5nbGUgY29tbW9u
IHNlbnNlIGNvZGUgb2YgY29uZHVjdD8KClRoZSBmYWN0IHRoYXQgd2UndmUgYXJyaXZlZCBhdCBl
c3NlbnRpYWxseSBhbiBvcmlnaW5hbCBDb0MKcmVpbnRlcnByZXRlZCB0byB0aGUgcG9pbnQgd2hl
cmUgaXQncyBlZmZlY3RpdmVseSBhIG5ldyBDb0MgaGFzIGJlZW4KdGhlIHNvdXJjZSBvZiBtdWNo
IGRlYmF0ZSBhbmQgcmVjcmltaW5hdGlvbiBvdmVyIHRoZSBsYXN0IGZldyBtb250aHMKLi4uIHlv
dSBjYW4gcmVhZCBpdCBpbiB0aGUga3N1bW1pdC1kaXNjdXNzIGFyY2hpdmVzLCBidXQgSSByZWFs
bHkgdGhpbmsKd2UgZG9uJ3Qgd2FudCB0byByZW9wZW4gdGhhdCBjYW4gb2Ygd29ybXMuCgpKYW1l
cwoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczov
L2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
