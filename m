From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v4 5/7] lib/hexdump.c: Allow multiple groups to be
 separated by lines '|'
Date: Mon, 24 Jun 2019 22:37:03 -0700
Message-ID: <c364c36338d385eba60c523828ad8995c792ae4d.camel@perches.com>
References: <20190625031726.12173-1-alastair@au1.ibm.com>
 <20190625031726.12173-6-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190625031726.12173-6-alastair@au1.ibm.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Alastair D'Silva <alastair@au1.ibm.com>, alastair@d-silva.org
Cc: linux-fbdev@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>, Petr Mladek <pmladek@suse.com>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>, ath10k@lists.infradead.org, intel-gfx@lists.freedesktop.org, Dan Carpenter <dan.carpenter@oracle.com>, Jose Abreu <Jose.Abreu@synopsys.com>, Tom Lendacky <thomas.lendacky@amd.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Kalle Valo <kvalo@codeaurora.org>, Karsten Keil <isdn@linux-pingi.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>D
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTI1IGF0IDEzOjE3ICsxMDAwLCBBbGFzdGFpciBEJ1NpbHZhIHdyb3Rl
Ogo+IEZyb206IEFsYXN0YWlyIEQnU2lsdmEgPGFsYXN0YWlyQGQtc2lsdmEub3JnPgo+IAo+IFdp
dGggdGhlIHdpZGVyIGRpc3BsYXkgZm9ybWF0LCBpdCBjYW4gYmVjb21lIGhhcmQgdG8gaWRlbnRp
ZnkgaG93IG1hbnkKPiBieXRlcyBpbnRvIHRoZSBsaW5lIHlvdSBhcmUgbG9va2luZyBhdC4KPiAK
PiBUaGUgcGF0Y2ggYWRkcyBuZXcgZmxhZ3MgdG8gaGV4X2R1bXBfdG9fYnVmZmVyKCkgYW5kIHBy
aW50X2hleF9kdW1wKCkgdG8KPiBwcmludCB2ZXJ0aWNhbCBsaW5lcyB0byBzZXBhcmF0ZSBldmVy
eSBOIGdyb3VwcyBvZiBieXRlcy4KPiAKPiBlZy4KPiBidWY6MDAwMDAwMDA6IDQ1NGQ0MTRlIDQz
NDE1MDUzfDRlNDk1ZjQ1IDAwNTg0NTQ0ICBOQU1FU1BBQ3xFX0lOREVYLgo+IGJ1ZjowMDAwMDAx
MDogMDAwMDAwMDAgMDAwMDAwMDJ8MDAwMDAwMDAgMDAwMDAwMDAgIC4uLi4uLi4ufC4uLi4uLi4u
Cj4gCj4gU2lnbmVkLW9mZi1ieTogQWxhc3RhaXIgRCdTaWx2YSA8YWxhc3RhaXJAZC1zaWx2YS5v
cmc+Cj4gLS0tCj4gIGluY2x1ZGUvbGludXgvcHJpbnRrLmggfCAgMyArKysKPiAgbGliL2hleGR1
bXAuYyAgICAgICAgICB8IDU5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0t
LS0tLQo+ICAyIGZpbGVzIGNoYW5nZWQsIDU0IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0p
Cj4gCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcHJpbnRrLmggYi9pbmNsdWRlL2xpbnV4
L3ByaW50ay5oCltdCj4gQEAgLTQ4NSw2ICs0ODUsOSBAQCBlbnVtIHsKPiAgCj4gICNkZWZpbmUg
SEVYRFVNUF9BU0NJSQkJCUJJVCgwKQo+ICAjZGVmaW5lIEhFWERVTVBfU1VQUFJFU1NfUkVQRUFU
RUQJQklUKDEpCj4gKyNkZWZpbmUgSEVYRFVNUF8yX0dSUF9MSU5FUwkJQklUKDIpCj4gKyNkZWZp
bmUgSEVYRFVNUF80X0dSUF9MSU5FUwkJQklUKDMpCj4gKyNkZWZpbmUgSEVYRFVNUF84X0dSUF9M
SU5FUwkJQklUKDQpCgpUaGVzZSBhcmVuJ3QgcmVhbGx5IGJpdHMgYXMgb25seSBvbmUgdmFsdWUg
c2hvdWxkIGJlIHNldAphcyA4IG92ZXJyaWRlcyA0IGFuZCA0IG92ZXJyaWRlcyAyLgoKSSB3b3Vs
ZCBhbHNvIGV4cGVjdCB0aGlzIHRvIGJlIGEgdmFsdWUgb2YgMiBpbiB5b3VyIGFib3ZlCmV4YW1w
bGUsIHJhdGhlciB0aGFuIDguICBJdCdzIGRlc2NyaWJlZCBhcyBncm91cHMgbm90IGJ5dGVzLgoK
VGhlIGV4YW1wbGUgaXMgc2hvd2luZyBhIHdoYXQgd291bGQgbm9ybWFsbHkgYmUgYSBzcGFjZSAn
ICcKc2VwYXJhdG9yIGFzIGEgdmVydGljYWwgYmFyICd8JyBldmVyeSAybmQgZ3JvdXBpbmcuCgoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
