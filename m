From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
Date: Sat, 1 Dec 2018 09:20:03 +0100
Message-ID: <CAMuHMdUkpLWm5NZmYj=uMgVncw6ZOb7j9KxFoDGhrnr7vzpx_w@mail.gmail.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
 <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
 <20181130195652.7syqys76646kpaph@linux-r8p5>
 <20181130205521.GA21006@linux.intel.com>
 <1543611662.3031.20.camel@HansenPartnership.com>
 <20181130214405.GG23772@linux.intel.com>
 <1543615069.3031.27.camel@HansenPartnership.com>
 <20181130221219.GA25537@linux.intel.com>
 <20181130151459.3ca2f5c8@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20181130151459.3ca2f5c8@lwn.net>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>, Geert Uytterhoeven <geert+renesas@glider.be>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, nouveau@lists.freedesktop.org, amir73il@gmail.com, DRI Development <dri-devel@lists.freedesktop.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-ide@vger.kernel.org, Eric Dumazet <edumazet@google.com>, MTD Maling List <linux-mtd@lists.infradead.org>, makita.toshiaki@lab.ntt.co.jp, yanjun.zhu@oracle.com, Davidlohr Bueso <dave@stgolabs.net>, scsi <linux-scsi@vger.kernel.org>, Helge Deller <deller@gmx.de>, Steven Rostedt <rostedt@goodmis.org>, federico.vaga@vaga.pv.it, yhs@fb.com, pabeni@redhat.com, Linux Media Mailing List <linux-media@vger.kernel.org>, Petr Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>, Linux PM list <linux-pm@vger.kernel.org>, shannon.nelson@oracle.com, sean.wang@medi
List-Id: linux-scsi@vger.kernel.org

SGkgSm9uLAoKT24gRnJpLCBOb3YgMzAsIDIwMTggYXQgMTE6MTUgUE0gSm9uYXRoYW4gQ29yYmV0
IDxjb3JiZXRAbHduLm5ldD4gd3JvdGU6Cj4gT24gRnJpLCAzMCBOb3YgMjAxOCAxNDoxMjoxOSAt
MDgwMAo+IEphcmtrbyBTYWtraW5lbiA8amFya2tvLnNha2tpbmVuQGxpbnV4LmludGVsLmNvbT4g
d3JvdGU6Cj4KPiA+IEFzIGEgbWFpbnRhaW5lciBteXNlbGYgKGFuZCBiYXNlZCBvbiBzb21ld2hh
dCBkaXN0dXJiZWQgZmVlZGJhY2sgZnJvbQo+ID4gb3RoZXIgbWFpbnRhaW5lcnMpIEkgY2FuIG9u
bHkgbWFrZSB0aGUgY29uY2x1c2lvbiB0aGF0IG5vYm9keSBrbm93cyB3aGF0Cj4gPiB0aGUgcmVz
cG9uc2liaWxpdHkgcGFydCBoZXJlIG1lYW5zLgo+ID4KPiA+IEkgd291bGQgaW50ZXJwcmV0LCBp
ZiBJIHJlYWQgaXQgbGlrZSBhdCBsYXd5ZXIgYXQgbGVhc3QsIHRoYXQgZXZlbiBmb3IKPiA+IGV4
aXN0aW5nIGNvZGUgeW91IHdvdWxkIG5lZWQgdG8gZG8gdGhlIGNoYW5nZXMgcG9zdG1vcnRlcm0u
Cj4gPgo+ID4gSXMgdGhpcyB3cm9uZyBpbnRlcnByZXRhdGlvbj8gIFNob3VsZCBJIGNvbmNsdWRl
IHRoYXQgSSBtYWRlIGEgbWlzdGFrZQo+ID4gYnkgcmVhZGluZyB0aGUgQ29DIGFuZCB0cnlpbmcg
dG8gdW5kZXJzdGFuZCB3aGF0IGl0ICphY3R1YWxseSogc2F5cz8KPiA+IEFmdGVyIHRoaXMgZGlz
Y3Vzc2lvbiwgSSBjYW4gc2F5IHRoYXQgSSB1bmRlcnN0YW5kIGl0IGxlc3MgdGhhbiBiZWZvcmUu
Cj4KPiBIYXZlIHlvdSByZWFkIERvY3VtZW50YXRpb24vcHJvY2Vzcy9jb2RlLW9mLWNvbmR1Y3Qt
aW50ZXJwcmV0YXRpb24ucnN0Pwo+IEFzIGhhcyBiZWVuIHBvaW50ZWQgb3V0LCBpdCBjb250YWlu
cyBhIGNsZWFyIGFuc3dlciB0byBob3cgdGhpbmdzIHNob3VsZAo+IGJlIGludGVycHJldGVkIGhl
cmUuCgpJbmRlZWQ6Cgp8IENvbnRyaWJ1dGlvbnMgc3VibWl0dGVkIGZvciB0aGUga2VybmVsIHNo
b3VsZCB1c2UgYXBwcm9wcmlhdGUgbGFuZ3VhZ2UuCnwgQ29udGVudCB0aGF0IGFscmVhZHkgZXhp
c3RzIHByZWRhdGluZyB0aGUgQ29kZSBvZiBDb25kdWN0IHdpbGwgbm90IGJlCnwgYWRkcmVzc2Vk
IG5vdyBhcyBhIHZpb2xhdGlvbi4KCkhvd2V2ZXI6Cgp8IEluYXBwcm9wcmlhdGUgbGFuZ3VhZ2Ug
Y2FuIGJlIHNlZW4gYXMgYQp8IGJ1ZywgdGhvdWdoOyBzdWNoIGJ1Z3Mgd2lsbCBiZSBmaXhlZCBt
b3JlIHF1aWNrbHkgaWYgYW55IGludGVyZXN0ZWQKfCBwYXJ0aWVzIHN1Ym1pdCBwYXRjaGVzIHRv
IHRoYXQgZWZmZWN0LgoKR3J7b2V0amUsZWV0aW5nfXMsCgogICAgICAgICAgICAgICAgICAgICAg
ICBHZWVydAoKLS0gCkdlZXJ0IFV5dHRlcmhvZXZlbiAtLSBUaGVyZSdzIGxvdHMgb2YgTGludXgg
YmV5b25kIGlhMzIgLS0gZ2VlcnRAbGludXgtbTY4ay5vcmcKCkluIHBlcnNvbmFsIGNvbnZlcnNh
dGlvbnMgd2l0aCB0ZWNobmljYWwgcGVvcGxlLCBJIGNhbGwgbXlzZWxmIGEgaGFja2VyLiBCdXQK
d2hlbiBJJ20gdGFsa2luZyB0byBqb3VybmFsaXN0cyBJIGp1c3Qgc2F5ICJwcm9ncmFtbWVyIiBv
ciBzb21ldGhpbmcgbGlrZSB0aGF0LgogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC0t
IExpbnVzIFRvcnZhbGRzCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9w
Lm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1k
ZXZlbAo=
