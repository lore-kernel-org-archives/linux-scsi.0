From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RESEND][PATCH 1/2] lib/scatterlist: Make ARCH_HAS_SG_CHAIN an
 actual Kconfig
Date: Mon, 24 Mar 2014 06:47:06 +0100
Message-ID: <20140324054706.GA4487@osiris>
References: <1395512032-20575-1-git-send-email-lauraa@codeaurora.org>
 <1395512032-20575-2-git-send-email-lauraa@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <1395512032-20575-2-git-send-email-lauraa@codeaurora.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux390@de.ibm.com, sparclinux@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-ia64@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

T24gU2F0LCBNYXIgMjIsIDIwMTQgYXQgMTE6MTM6NTFBTSAtMDcwMCwgTGF1cmEgQWJib3R0IHdy
b3RlOgo+IFJhdGhlciB0aGFuIGhhdmUgYXJjaGl0ZWN0dXJlcyAjZGVmaW5lIEFSQ0hfSEFTX1NH
X0NIQUlOIGluIGFuIGFyY2hpdGVjdHVyZQo+IHNwZWNpZmljIHNjYXR0ZXJsaXN0LmgsIG1ha2Ug
aXQgYSBwcm9wZXIgS2NvbmZpZyBvcHRpb24gYW5kIHVzZSB0aGF0Cj4gaW5zdGVhZC4gQXQgc2Ft
ZSB0aW1lLCByZW1vdmUgdGhlIGhlYWRlciBmaWxlcyBhcmUgYXJlIG5vdyBtb3N0bHkKPiB1c2Vs
ZXNzIGFuZCBqdXN0IGluY2x1ZGUgYXNtLWdlbmVyaWMvc2NhdHRlcmxpc3QuaC4KPiAKClsuLi5d
Cgo+IGRpZmYgLS1naXQgYS9hcmNoL3MzOTAvS2NvbmZpZyBiL2FyY2gvczM5MC9LY29uZmlnCj4g
aW5kZXggNjVhMDc3NS4uZDZjMjA1OSAxMDA2NDQKPiAtLS0gYS9hcmNoL3MzOTAvS2NvbmZpZwo+
ICsrKyBiL2FyY2gvczM5MC9LY29uZmlnCj4gQEAgLTE0Miw2ICsxNDIsNyBAQCBjb25maWcgUzM5
MAo+ICAJc2VsZWN0IFNZU0NUTF9FWENFUFRJT05fVFJBQ0UKPiAgCXNlbGVjdCBWSVJUX0NQVV9B
Q0NPVU5USU5HCj4gIAlzZWxlY3QgVklSVF9UT19CVVMKPiArCXNlbGVjdCBBUkNIX0hBU19TR19D
SEFJTgo+IAoKQWNrZWQtYnk6IEhlaWtvIENhcnN0ZW5zIDxoZWlrby5jYXJzdGVuc0BkZS5pYm0u
Y29tPgoKRldJVywgaXQgd291bGQgaGF2ZSBiZWVuIG5pY2UgdG8ga2VlcCB0aGUgbGlzdCBvZiBz
ZWxlY3RlZCBjb25maWdzIHNvcnRlZC4KSG93ZXZlciBubyBuZWVkIHRvIHJlc2VuZC4KCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4cHBjLWRldiBt
YWlsaW5nIGxpc3QKTGludXhwcGMtZGV2QGxpc3RzLm96bGFicy5vcmcKaHR0cHM6Ly9saXN0cy5v
emxhYnMub3JnL2xpc3RpbmZvL2xpbnV4cHBjLWRldg==
