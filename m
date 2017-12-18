From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [trivial PATCH] treewide: Align function definition open/close
 braces
Date: Mon, 18 Dec 2017 14:31:12 +0200
Message-ID: <CAHp75Vfw=AQHkiC7WhUkuytxG_reO8rmEfpA7z-2yAekFQ4AYQ@mail.gmail.com>
References: <1513556924.31581.51.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1513556924.31581.51.camel@perches.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Joe Perches <joe@perches.com>
Cc: linux-rtc@vger.kernel.org, ALSA Development Mailing List <alsa-devel@alsa-project.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Jiri Kosina <trivial@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, MPT-FusionLinux.pdl@broadcom.com, acpi4asus-user <acpi4asus-user@lists.sourceforge.net>, "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org, Platform Driver <platform-driver-x86@vger.kernel.org>, linux-xfs@vger.kernel.org, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-audit@redhat.com, amd-gfx@lists.freedesktop.org, netdev <netdev@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, ocfs2-devel@oss.oracle.com, Linux Media Mailing List <linux-media@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gTW9uLCBEZWMgMTgsIDIwMTcgYXQgMjoyOCBBTSwgSm9lIFBlcmNoZXMgPGpvZUBwZXJjaGVz
LmNvbT4gd3JvdGU6Cj4gU29tZSBmdW5jdGlvbnMgZGVmaW5pdGlvbnMgaGF2ZSBlaXRoZXIgdGhl
IGluaXRpYWwgb3BlbiBicmFjZSBhbmQvb3IKPiB0aGUgY2xvc2luZyBicmFjZSBvdXRzaWRlIG9m
IGNvbHVtbiAxLgo+Cj4gTW92ZSB0aG9zZSBicmFjZXMgdG8gY29sdW1uIDEuCj4KPiBUaGlzIGFs
bG93cyB2YXJpb3VzIGZ1bmN0aW9uIGFuYWx5emVycyBsaWtlIGdudSBjb21wbGV4aXR5IHRvIHdv
cmsKPiBwcm9wZXJseSBmb3IgdGhlc2UgbW9kaWZpZWQgZnVuY3Rpb25zLgo+Cj4gTWlzY2VsbGFu
ZWE6Cj4KPiBvIFJlbW92ZSBleHRyYSB0cmFpbGluZyA7IGFuZCBibGFuayBsaW5lIGZyb20geGZz
X2FnZl92ZXJpZnkKPgo+IFNpZ25lZC1vZmYtYnk6IEpvZSBQZXJjaGVzIDxqb2VAcGVyY2hlcy5j
b20+Cgo+ICBkcml2ZXJzL3BsYXRmb3JtL3g4Ni9lZWVwYy1sYXB0b3AuYyAgICAgICAgICAgICAg
ICAgIHwgIDIgKy0KCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGxhdGZvcm0veDg2L2VlZXBjLWxh
cHRvcC5jIGIvZHJpdmVycy9wbGF0Zm9ybS94ODYvZWVlcGMtbGFwdG9wLmMKPiBpbmRleCA1YTY4
MTk2Mjg5OWMuLjRjMzg5MDRhOGEzMiAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3BsYXRmb3JtL3g4
Ni9lZWVwYy1sYXB0b3AuYwo+ICsrKyBiL2RyaXZlcnMvcGxhdGZvcm0veDg2L2VlZXBjLWxhcHRv
cC5jCj4gQEAgLTQ5Miw3ICs0OTIsNyBAQCBzdGF0aWMgdm9pZCBlZWVwY19wbGF0Zm9ybV9leGl0
KHN0cnVjdCBlZWVwY19sYXB0b3AgKmVlZXBjKQo+ICAgKiBwb3RlbnRpYWxseSBiYWQgdGltZSwg
c3VjaCBhcyBhIHRpbWVyIGludGVycnVwdC4KPiAgICovCj4gIHN0YXRpYyB2b2lkIHRwZF9sZWRf
dXBkYXRlKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKPiAtIHsKPiArewo+ICAgICAgICAgc3Ry
dWN0IGVlZXBjX2xhcHRvcCAqZWVlcGM7Cj4KPiAgICAgICAgIGVlZXBjID0gY29udGFpbmVyX29m
KHdvcmssIHN0cnVjdCBlZWVwY19sYXB0b3AsIHRwZF9sZWRfd29yayk7Cj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvcnRjL3J0Yy1hYi1iNXplLXMzLmMgYi9kcml2ZXJzL3J0Yy9ydGMtYWItYjV6ZS1z
My5jCj4gaW5kZXggYTMxOWJmMWU0OWRlLi5lZjVjMTZkZmFiZmEgMTAwNjQ0CgpBY2tlZC1ieTog
QW5keSBTaGV2Y2hlbmtvIDxhbmR5LnNoZXZjaGVua29AZ21haWwuY29tPgoKZm9yIFBEeDg2IGNo
YW5nZXMuCgoKLS0gCldpdGggQmVzdCBSZWdhcmRzLApBbmR5IFNoZXZjaGVua28KX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcg
bGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRl
c2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
