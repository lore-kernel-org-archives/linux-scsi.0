From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 00/13] Get rid of DocBook
Date: Mon, 15 May 2017 07:34:31 -0700
Message-ID: <CAGXu5jJSv49uy98r3=7nRqeKyzZWDC=QbvFMoKPWjWUhbcDhTw@mail.gmail.com>
References: <cover.1494775891.git.mchehab@s-opensource.com>
 <CAGXu5j+KgtD+Vj8-K-3XVKdQnWQ8JJUWSjWwrhxP+ApAyyEPKg@mail.gmail.com>
 <20170514190057.17e41167@vento.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20170514190057.17e41167@vento.lan>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-ide@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-ia64@vger.kernel.org, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Richard Sailer <richard@weltraumpflege.org>, "Herton R. Krzesinski" <herton@redhat.com>, moderated for non-subscribers <alsa-devel@alsa-project.org>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, Jaroslav Kysela <perex@perex.cz>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Vetter <daniel.vetter@intel.com>, Jiri Slaby <jslaby@suse.cz>, Ingo Molnar <mingo@kernel.org>, Hans-Christian Noren Egtvedt <egtvedt@samfundet.no>, Markus Heiser <markus.heiser@darmarit.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>Sanjeev <g>
List-Id: linux-scsi@vger.kernel.org

T24gU3VuLCBNYXkgMTQsIDIwMTcgYXQgMzowMCBQTSwgTWF1cm8gQ2FydmFsaG8gQ2hlaGFiCjxt
Y2hlaGFiQHMtb3BlbnNvdXJjZS5jb20+IHdyb3RlOgo+IEVtIFN1biwgMTQgTWF5IDIwMTcgMTQ6
MDU6MDkgLTA3MDAKPiBLZWVzIENvb2sgPGtlZXNjb29rQGNocm9taXVtLm9yZz4gZXNjcmV2ZXU6
Cj4KPj4gT24gU3VuLCBNYXkgMTQsIDIwMTcgYXQgODozOCBBTSwgTWF1cm8gQ2FydmFsaG8gQ2hl
aGFiCj4+IDxtY2hlaGFiQHMtb3BlbnNvdXJjZS5jb20+IHdyb3RlOgo+PiA+IEFzIGp1c3Qgb25l
IGJvb2sgKGxzbSkgd2FzIG1pc3NpbmcgY29udmVyc2lvbiwgbGV0J3MgY29udmVydCBpdAo+PiA+
IGFuZCBzdG9yZSBhcyBpZiBpdCB3ZXJlIGEgcGxhaW4gdGV4dCBmaWxlIHVuZGVyIERvY3VtZW50
YXRpb24vbHNtLnR4dCwKPj4gPiBhZGRpbmcgYSBub3RpY2UgdGhhdCBpdCByZXF1aXJlcyB1cGRh
dGUuCj4+Cj4+IEkgY291bGQgcHJvYmFibHkgZm9sZCB0aGlzIGNoYW5nZSBpbnRvIG15IHJzdC1p
ZmljYXRpb24gb2YKPj4gRG9jdW1lbnRhdGlvbi9zZWN1cml0eS8KPj4KPj4gaHR0cHM6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQva2Vlcy9saW51eC5naXQvbG9nLz9o
PWtzcHAvcnN0Cj4+Cj4+IFNwZWNpZmljYWxseSwgdGhlIG5ldyBEb2N1bWVudGF0aW9uL3NlY3Vy
aXR5L0xTTS5yc3Qgd2FzIHJhdGhlciBzaG9ydC4KPj4gSSB0aGluayB5b3VyIGxzbS50eHQgYW5k
IHRoaXMgb25lIGNvdWxkIGJlIGxpa2VseSBtZXJnZWQuCj4KPiBZZWFoLCBtYWtlcyBzZW5zZS4g
SSdtIG5vdCBzdXJlIHdoYXQgd291bGQgYmUgdGhlIGJlc3Qgd2F5IHRvCj4gcHJvY2VlZCwgYXMs
IGN1cnJlbnRseSwgYWZ0ZXIgcmVtb3ZpbmcgbHNtLnRtcGwsIG15IHBhdGNoCj4gc2VyaWVzIHJl
bW92ZSBEb2NCb29rLCBhcyBldmVyeXRoaW5nIGVsc2Ugd2FzIGFscmVhZHkgcmVtb3ZlZC4KPgo+
IEkgc2VlIGEgZmV3IHdheXMgZm9yIHVzIHRvIHByb2NlZWQ6Cj4KPiAxKSBZb3UgY291bGQgc3Vi
bWl0IHRoZSBwYXRjaGVzIHlvdSBoYXZlIHNvIGZhciB0byBkb2NzIC1uZXh0LAo+IHRvIGJlIG1l
cmdlZCBiZWZvcmUgbXkgcGF0Y2ggc2VyaWVzOwoKSSBzZW50IG15IHNlcmllcyBhbHJlYWR5IChp
dCBnb3QgQ0NlZCB0byBsaW51eC1kb2MpOyBpdCdzIGNvbGxlY3RlZCBhCmZldyBBY2tzIGFscmVh
ZHkuIEknbSBub3Qgc3VyZSB3aGF0IHRoZSB0aW1pbmcgZm9yIHRoYXQgbWVhbnMsIHRob3VnaC4K
Cj4gMikgSSBjb3VsZCBzZW5kIHlvdSBhIHBhdGNoIGJhc2VkIG9uIHlvdXIgdHJlZS4gSSdsbCBu
ZWVkIHRvCj4gcmViYXNlIHRoaXMgc2VyaWVzIHRvIGJlIGFwcGxpZWQgb24gdGhlIHRvcCBvZiB5
b3VyIHRyZWUgKyBkb2NzLW5leHQsCj4gd2l0aCB3b3VsZCByZXF1aXJlIHRoYXQgeW91ciBwYXRj
aCBzZXJpZXMgd291bGQgYmUgbWVyZ2VkIGJlZm9yZSwKPiBhdCBkb2NzIC1uZXh0Owo+Cj4gMykg
d2UgY2FuIGhhbmRsZSBib3RoIHNlcmllcyBpbmRlcGVuZGVudGx5LiBXaGVuIGJvdGggZ2V0cwo+
IG1lcmdlZCBhdCBkb2NzIC1uZXh0LCBhIHNpbXBsZSBwYXRjaCwgZWl0aGVyIHdyaXR0ZW4gYnkg
eW91IG9yCj4gbWUsIGNvdWxkIG1lcmdlIGJvdGggZmlsZXMuCgpJIGRvbid0IHNlZSBhIHJlYXNv
biBmb3IgdXMgdG8gbWFrZSB0aGUgdHJlZXMgZGVwZW5kIG9uIGVhY2ggb3RoZXIuCkxldCdzIGp1
c3QgcHJvY2VlZCBhcy1pcyBhbmQgd2hlbmV2ZXIgd2UncmUgaW4gYSBwb3NpdGlvbiB0byBtZXJn
ZSB0aGUKTFNNIGRvY3MsIHdlIGNhbiBkbyB0aGF0LgoKPiBJTU8sICgzKSBpcyBzaW1wbGVyLCBi
dXQgaWYgeW91IHByZWZlciwgd2UgY2FuIGRvIG9uIHNvbWUgb3RoZXIKPiB3YXkuCgpBZ3JlZWQu
CgotS2VlcwoKLS0gCktlZXMgQ29vawpQaXhlbCBTZWN1cml0eQpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1k
ZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcv
bWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
