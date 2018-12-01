From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
Date: Fri, 30 Nov 2018 20:08:05 -0800
Message-ID: <20181201040805.GA14569@linux.intel.com>
References: <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
 <d7c34289-f03a-b641-cc9c-00395306511d@kernel.dk>
 <20181130.123507.1940310466680455876.davem@davemloft.net>
 <2007856.n5V9iKLVsV@eth7>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
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
Cc: linux-mips@linux-mips.org, geert+renesas@glider.be, linux-doc@vger.kernel.org, nouveau@lists.freedesktop.org, amir73il@gmail.com, linux@dominikbrodowski.net, linux-ide@vger.kernel.org, edumazet@google.com, linux-mtd@lists.infradead.org, makita.toshiaki@lab.ntt.co.jp, yanjun.zhu@oracle.com, dave@stgolabs.net, linux-scsi@vger.kernel.org, corbet@lwn.net, deller@gmx.de, federico.vaga@vaga.pv.it, yhs@fb.com, pabeni@redhat.com, linux-media@vger.kernel.org, pmladek@suse.com, keescook@chromium.org, linux-pm@vger.kernel.org, shannon.nelson@oracle.com, sean.wang@mediatek.com, rostedt@goodmis.org, sbrivio@redhat.com, linux-m68k@lists.linux-m68k.org, dri-devel@lists.freedesktop.org, matthias.bgg@gmail.com, andriy.shevchenko@linux.intel.com, dja@axtens.net, axboe@kernel.dk, willemb@google.com, linux-parisc@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sergey.
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCBOb3YgMzAsIDIwMTggYXQgMDg6Mzk6MDFQTSArMDAwMCwgQWJ1c2Ugd3JvdGU6Cj4g
T24gRnJpZGF5LCAzMCBOb3ZlbWJlciAyMDE4IDIwOjM1OjA3IEdNVCBEYXZpZCBNaWxsZXIgd3Jv
dGU6Cj4gPiBGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+Cj4gPiBEYXRlOiBGcmks
IDMwIE5vdiAyMDE4IDEzOjEyOjI2IC0wNzAwCj4gPiAKPiA+ID4gT24gMTEvMzAvMTggMTI6NTYg
UE0sIERhdmlkbG9ociBCdWVzbyB3cm90ZToKPiA+ID4+IE9uIEZyaSwgMzAgTm92IDIwMTgsIEtl
ZXMgQ29vayB3cm90ZToKPiA+ID4+IAo+ID4gPj4+IE9uIEZyaSwgTm92IDMwLCAyMDE4IGF0IDEx
OjI3IEFNIEphcmtrbyBTYWtraW5lbgo+ID4gPj4+IDxqYXJra28uc2Fra2luZW5AbGludXguaW50
ZWwuY29tPiB3cm90ZToKPiA+ID4+Pj4KPiA+ID4+Pj4gSW4gb3JkZXIgdG8gY29tcGx5IHdpdGgg
dGhlIENvQywgcmVwbGFjZSAqKioqIHdpdGggYSBodWcuCj4gPiA+PiAKPiA+ID4+IEkgaG9wZSB0
aGlzIGlzIHNvbWUga2luZCBvZiBqb2tlLiBIb3cgd291bGQgYW55b25lIGdldCBvZmZlbmRlZCBi
eSByZWFkaW5nCj4gPiA+PiB0ZWNobmljYWwgY29tbWVudHM/IFRoaXMgaXMgYWxsIGJleW9uZCBt
ZS4uLgo+ID4gPiAKPiA+ID4gQWdyZWUsIHRoaXMgaXMgaW5zYW5pdHkuCj4gPiAKPiA+IEFuZCBl
dmVuIHdvcnNlIGl0IGlzIGNlbnNvcnNoaXAuCj4gPiAKPiAKPiBGdWNrCj4gRnVjawo+IEZ1Y2sK
PiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+
IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4g
RnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBG
dWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1
Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVj
awo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNr
Cj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sK
PiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+
IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4g
RnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBG
dWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1
Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVjawo+IEZ1Y2sKPiBGdWNrCj4gRnVj
awo+IEZ1Y2sKPiBGdWNrCj4gCj4gSSBhc3N1bWUgSSB3aWxsIG5vdyBiZSBiYXJyZWQuCj4gCj4g
CgpUaGFuayB5b3UgZm9yIHRha2luZyB0aGUgb3Bwb3J0dW5pdHkgdG8gcHJhY3RpY2UgZnJlZSBz
cGVlY2ggaW4gdGhlCmFsd2F5cyBzbyB3ZWxjb21pbmcgYW5kIGluY2x1c2l2ZSBvbi1saW5lIHdv
cmxkIDotKSBOb3cgSSdsbCBqdXN0IGhhdmUKdG8gZmluZCBteSBub3RlYm9vayBhbmQgd3JpdGUg
dGhpcyBwcm9zZSBkb3duIHNvIHRoYXQgSSdsbCBuZXZlciBmb3JnZXQKaXQuIFRoYW5rcyBhZ2Fp
bi4KCi9KYXJra28KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3Jn
Cmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
Cg==
