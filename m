From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
Date: Fri, 30 Nov 2018 15:43:57 -0500
Message-ID: <20181130154242.39f59eea@gandalf.local.home>
References: <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
 <d7c34289-f03a-b641-cc9c-00395306511d@kernel.dk>
 <20181130.123507.1940310466680455876.davem@davemloft.net>
 <2007856.n5V9iKLVsV@eth7>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <2007856.n5V9iKLVsV@eth7>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Abuse <abuse@2.abuse.bgcomp.co.uk>
Cc: linux-mips@linux-mips.org, geert+renesas@glider.be, linux-doc@vger.kernel.org, nouveau@lists.freedesktop.org, amir73il@gmail.com, dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org, edumazet@google.com, linux-mtd@lists.infradead.org, makita.toshiaki@lab.ntt.co.jp, yanjun.zhu@oracle.com, dave@stgolabs.net, linux-scsi@vger.kernel.org, corbet@lwn.net, deller@gmx.de, federico.vaga@vaga.pv.it, yhs@fb.com, pabeni@redhat.com, linux-media@vger.kernel.org, pmladek@suse.com, keescook@chromium.org, linux-pm@vger.kernel.org, shannon.nelson@oracle.com, sean.wang@mediatek.com, linux@dominikbrodowski.net, sbrivio@redhat.com, linux-m68k@lists.linux-m68k.org, jarkko.sakkinen@linux.intel.com, matthias.bgg@gmail.com, andriy.shevchenko@linux.intel.com, dja@axtens.net, axboe@kernel.dk, willemb@google.com, linux-parisc@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAzMCBOb3YgMjAxOCAyMDozOTowMSArMDAwMApBYnVzZSA8YWJ1c2VAMi5hYnVzZS5i
Z2NvbXAuY28udWs+IHdyb3RlOgoKPiBPbiBGcmlkYXksIDMwIE5vdmVtYmVyIDIwMTggMjA6MzU6
MDcgR01UIERhdmlkIE1pbGxlciB3cm90ZToKPiA+IEZyb206IEplbnMgQXhib2UgPGF4Ym9lQGtl
cm5lbC5kaz4KPiA+IERhdGU6IEZyaSwgMzAgTm92IDIwMTggMTM6MTI6MjYgLTA3MDAKPiA+ICAg
Cj4gPiA+IE9uIDExLzMwLzE4IDEyOjU2IFBNLCBEYXZpZGxvaHIgQnVlc28gd3JvdGU6ICAKPiA+
ID4+IE9uIEZyaSwgMzAgTm92IDIwMTgsIEtlZXMgQ29vayB3cm90ZToKPiA+ID4+ICAgCj4gPiA+
Pj4gT24gRnJpLCBOb3YgMzAsIDIwMTggYXQgMTE6MjcgQU0gSmFya2tvIFNha2tpbmVuCj4gPiA+
Pj4gPGphcmtrby5zYWtraW5lbkBsaW51eC5pbnRlbC5jb20+IHdyb3RlOiAgCj4gPiA+Pj4+Cj4g
PiA+Pj4+IEluIG9yZGVyIHRvIGNvbXBseSB3aXRoIHRoZSBDb0MsIHJlcGxhY2UgKioqKiB3aXRo
IGEgaHVnLiAgCj4gPiA+PiAKPiA+ID4+IEkgaG9wZSB0aGlzIGlzIHNvbWUga2luZCBvZiBqb2tl
LiBIb3cgd291bGQgYW55b25lIGdldCBvZmZlbmRlZCBieSByZWFkaW5nCj4gPiA+PiB0ZWNobmlj
YWwgY29tbWVudHM/IFRoaXMgaXMgYWxsIGJleW9uZCBtZS4uLiAgCj4gPiA+IAo+ID4gPiBBZ3Jl
ZSwgdGhpcyBpcyBpbnNhbml0eS4gIAo+ID4gCj4gPiBBbmQgZXZlbiB3b3JzZSBpdCBpcyBjZW5z
b3JzaGlwLgo+ID4gICAKPiAKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBI
dWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcK
PiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBI
dWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcK
PiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBI
dWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcK
PiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBI
dWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcK
PiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBI
dWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcK
PiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBIdWcKPiBI
dWcKPiBIdWcKPiAKPiBJIGFzc3VtZSBJIHdpbGwgbm93IGJlIGJhcnJlZC4KPiAKCi0tIFN0ZXZl
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2
ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9s
aXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
