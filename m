From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND][PATCH 0/2] Cleanup asm/scatterlist.h
Date: Fri, 28 Mar 2014 15:14:12 -0700
Message-ID: <20140328151412.9d3ce44ee4c5ad3b1c75751d@linux-foundation.org>
References: <1395512032-20575-1-git-send-email-lauraa@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1395512032-20575-1-git-send-email-lauraa@codeaurora.org>
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
Cc: linux-ia64@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux@vger.kernel.org, Lennox Wu <lennox.wu@gmail.com>, Chen Liqin <liqin.linux@gmail.com>, Jesper Nilsson <jesper.nilsson@axis.com>, linux-am33-list@redhat.com, Russell King <linux@arm.linux.org.uk>, linux-scsi@vger.kernel.org, Hirokazu Takata <takata@linux-m32r.org>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>, linux-s390@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au, Mikael Starvik <starvik@axis.com>, linux-m32r@ml.linux-m32r.org, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, Michal Simek <monstr@monstr.eu>, Tony Luck <tony.luck@intel.com>, linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org, James E.J. Bottoml
List-Id: linux-scsi@vger.kernel.org

T24gU2F0LCAyMiBNYXIgMjAxNCAxMToxMzo1MCAtMDcwMCBMYXVyYSBBYmJvdHQgPGxhdXJhYUBj
b2RlYXVyb3JhLm9yZz4gd3JvdGU6Cgo+IEkgaGF2ZW4ndCBnb3R0ZW4gbWFueSByZXNwb25zZXMg
c28gSSdtIGdvaW5nIHRvIHRyeSBzZW5kaW5nIGFnYWluCj4gKHRoaXMgdGltZSB3aXRoIGEgY292
ZXIgbGV0dGVyIHdoaWNoIEkgcHJvYmFibHkgc2hvdWxkIGhhdmUgZG9uZSBpbgo+IHRoZSBmaXJz
dCBwbGFjZS4uLikKPiAKPiBBUkNIX0hBU19TR19DSEFJTiBpcyBjdXJyZW50bHkgZGVmaW5lZCBh
cyBuZWVkZWQgaW4gYXNtL3NjYXR0ZXJsaXN0LmguCj4gSXQgd2FzIHN1Z2dlc3RlZFsxXSB0aGF0
IHRoaXMgc2hvdWxkIHByb2JhYmx5IGJlIGEgcHJvcGVyIEtjb25maWcuCj4gQXQgdGhlIHNhbWUg
dGltZSwgd2UgY2FuIGNsZWFuIHVwIG1vc3Qgb2YgdGhlIGFzbS9zY2F0dGVybGlzdC5oIGZpbGVz
Cj4gdG8gcmVkdWNlIHJlZHVuZGFuY3kuIFRoaXMgbWFrZXMgcGFyaXNjIHRoZSBvbmx5IGFyY2hp
dGVjdHVyZSB0aGF0IHN0aWxsCj4gaGFzIGFuIGFzbS9zY2F0dGVybGlzdC5oIGZpbGUgZHVlIHRv
IHRoZSAjZGVmaW5lIHNnX3ZpcnRfYWRkciAod2hpY2gKPiBjb3VsZCBwcm9iYWJseSBiZSBjbGVh
bmVkIHVwIGZ1cnRoZXIgc3RpbGwpCj4gCj4gQW5kcmV3LCBvbmNlIHdlIGdldCBhIGZldyBtb3Jl
IEFja2VkLWJ5cyBjYW4gd2UgdGFrZSB0aGlzIHRocm91Z2ggeW91ciB0cmVlCj4gYXMgc3VnZ2Vz
dGVkIGJ5IFdpbGw/CgpHcmFiYmVkLiAgSXQncyBzdXBlciBsYXRlIGZvciAzLjE1LXJjMSBhbmQg
SSdtIHRoaW5raW5nIG9mIG1lcmdpbmcgdGhpcwppbiAzLjE2LXJjMS4gIE9yIEkgY2FuIG1heWJl
IHNxdWVlemUgaXQgaW50byAzLjE1LXJjMiBpcyB0aGVyZSdzIGFuCmltbWVkaWF0aXNoIG5lZWQg
Zm9yIGl0PwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpM
aW51eHBwYy1kZXYgbWFpbGluZyBsaXN0CkxpbnV4cHBjLWRldkBsaXN0cy5vemxhYnMub3JnCmh0
dHBzOi8vbGlzdHMub3psYWJzLm9yZy9saXN0aW5mby9saW51eHBwYy1kZXY=
