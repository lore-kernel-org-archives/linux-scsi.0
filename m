From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
Date: Fri, 30 Nov 2018 13:42:33 -0800
Message-ID: <20181130214233.GF23772@linux.intel.com>
References: <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
 <20181130195652.7syqys76646kpaph@linux-r8p5>
 <d7c34289-f03a-b641-cc9c-00395306511d@kernel.dk>
 <20181130.123507.1940310466680455876.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20181130.123507.1940310466680455876.davem@davemloft.net>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: David Miller <davem@davemloft.net>
Cc: linux-mips@linux-mips.org, geert+renesas@glider.be, linux-doc@vger.kernel.org, nouveau@lists.freedesktop.org, amir73il@gmail.com, linux@dominikbrodowski.net, linux-ide@vger.kernel.org, edumazet@google.com, linux-mtd@lists.infradead.org, makita.toshiaki@lab.ntt.co.jp, yanjun.zhu@oracle.com, dave@stgolabs.net, linux-scsi@vger.kernel.org, corbet@lwn.net, deller@gmx.de, federico.vaga@vaga.pv.it, yhs@fb.com, pabeni@redhat.com, linux-media@vger.kernel.org, pmladek@suse.com, keescook@chromium.org, linux-pm@vger.kernel.org, shannon.nelson@oracle.com, sean.wang@mediatek.com, rostedt@goodmis.org, sbrivio@redhat.com, linux-m68k@lists.linux-m68k.org, dri-devel@lists.freedesktop.org, matthias.bgg@gmail.com, andriy.shevchenko@linux.intel.com, dja@axtens.net, axboe@kernel.dk, willemb@google.com, linux-parisc@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sergey.
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCBOb3YgMzAsIDIwMTggYXQgMTI6MzU6MDdQTSAtMDgwMCwgRGF2aWQgTWlsbGVyIHdy
b3RlOgo+IEZyb206IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KPiBEYXRlOiBGcmksIDMw
IE5vdiAyMDE4IDEzOjEyOjI2IC0wNzAwCj4gCj4gPiBPbiAxMS8zMC8xOCAxMjo1NiBQTSwgRGF2
aWRsb2hyIEJ1ZXNvIHdyb3RlOgo+ID4+IE9uIEZyaSwgMzAgTm92IDIwMTgsIEtlZXMgQ29vayB3
cm90ZToKPiA+PiAKPiA+Pj4gT24gRnJpLCBOb3YgMzAsIDIwMTggYXQgMTE6MjcgQU0gSmFya2tv
IFNha2tpbmVuCj4gPj4+IDxqYXJra28uc2Fra2luZW5AbGludXguaW50ZWwuY29tPiB3cm90ZToK
PiA+Pj4+Cj4gPj4+PiBJbiBvcmRlciB0byBjb21wbHkgd2l0aCB0aGUgQ29DLCByZXBsYWNlICoq
Kiogd2l0aCBhIGh1Zy4KPiA+PiAKPiA+PiBJIGhvcGUgdGhpcyBpcyBzb21lIGtpbmQgb2Ygam9r
ZS4gSG93IHdvdWxkIGFueW9uZSBnZXQgb2ZmZW5kZWQgYnkgcmVhZGluZwo+ID4+IHRlY2huaWNh
bCBjb21tZW50cz8gVGhpcyBpcyBhbGwgYmV5b25kIG1lLi4uCj4gPiAKPiA+IEFncmVlLCB0aGlz
IGlzIGluc2FuaXR5Lgo+IAo+IEFuZCBldmVuIHdvcnNlIGl0IGlzIGNlbnNvcnNoaXAuCgpJdCBp
cyBub3QgY2xvc2UgdG8gYSBjZW5jb3JzaGlwLCBlc3BlY2lhbGx5IHdoZW4gSSB1c2VkIFJGQyB0
YWcsIHdoaWNoCmVzc2VudGlhbGx5IHNheXMgdGhhdCBJJ20gbm90IHNheWluZyAicGxlYXNlIHRh
a2UgdGhpcyIsIHJpZ2h0PwoKQ2FuIHlvdSB0ZWxsIGhvdyB0aGUgQ29DIHNob3VsZCBiZSBpbnRl
cnByZXRlZCB0aGVuPyBJIHJlYWQgaXQgdGhyb3VnaApvbiBteSBwbGFuZSB0cmlwIHdpdGggYW4g
ZXllIGdsYXNzLgoKSXMgY3Vyc2luZyBPSz8KCi9KYXJra28KX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2
ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21h
aWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
