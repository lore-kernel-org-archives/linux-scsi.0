From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v2] scsi: xen-scsifront: add error handling
 for xenbus_printf
Date: Thu, 14 Jun 2018 17:54:44 -0400
Message-ID: <6ed19f75-20d0-9870-1334-8d0eaabd0534@oracle.com>
References: <1528774962-39173-1-git-send-email-jiazhouyang09@gmail.com>
 <1528992514-53963-1-git-send-email-jiazhouyang09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <1528992514-53963-1-git-send-email-jiazhouyang09@gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: Zhouyang Jia <jiazhouyang09@gmail.com>
Cc: Juergen Gross <jgross@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
List-Id: linux-scsi@vger.kernel.org

T24gMDYvMTQvMjAxOCAxMjowOCBQTSwgWmhvdXlhbmcgSmlhIHdyb3RlOgo+IFdoZW4geGVuYnVz
X3ByaW50ZiBmYWlscywgdGhlIGxhY2sgb2YgZXJyb3ItaGFuZGxpbmcgY29kZSBtYXkKPiBjYXVz
ZSB1bmV4cGVjdGVkIHJlc3VsdHMuCj4KPiBUaGlzIHBhdGNoIGFkZHMgZXJyb3ItaGFuZGxpbmcg
Y29kZSBhZnRlciBjYWxsaW5nIHhlbmJ1c19wcmludGYuCj4KPiBTaWduZWQtb2ZmLWJ5OiBaaG91
eWFuZyBKaWEgPGppYXpob3V5YW5nMDlAZ21haWwuY29tPgo+IC0tLQo+IHYxLT52MjoKPiAtIEZp
eCBkZXJlZmVyZW5jaW5nIGJlZm9yZSBjaGVja2luZwo+IC0tLQo+ICBkcml2ZXJzL3Njc2kveGVu
LXNjc2lmcm9udC5jIHwgMjkgKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0KPiAgMSBmaWxl
IGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCj4KPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL3hlbi1zY3NpZnJvbnQuYyBiL2RyaXZlcnMvc2NzaS94ZW4tc2NzaWZy
b250LmMKPiBpbmRleCAzNmY1OWExLi5hN2Y2MTExIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvc2Nz
aS94ZW4tc2NzaWZyb250LmMKPiArKysgYi9kcml2ZXJzL3Njc2kveGVuLXNjc2lmcm9udC5jCj4g
QEAgLTY1NCwxMCArNjU0LDE2IEBAIHN0YXRpYyBpbnQgc2NzaWZyb250X2Rldl9yZXNldF9oYW5k
bGVyKHN0cnVjdCBzY3NpX2NtbmQgKnNjKQo+ICBzdGF0aWMgaW50IHNjc2lmcm9udF9zZGV2X2Nv
bmZpZ3VyZShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYpCj4gIHsKPiAgCXN0cnVjdCB2c2NzaWZy
bnRfaW5mbyAqaW5mbyA9IHNob3N0X3ByaXYoc2Rldi0+aG9zdCk7Cj4gKwlpbnQgZXJyOwo+ICAK
PiAtCWlmIChpbmZvICYmIGN1cnJlbnQgPT0gaW5mby0+Y3VycikKPiAtCQl4ZW5idXNfcHJpbnRm
KFhCVF9OSUwsIGluZm8tPmRldi0+bm9kZW5hbWUsCj4gKwlpZiAoaW5mbyAmJiBjdXJyZW50ID09
IGluZm8tPmN1cnIpIHsKPiArCQllcnIgPSB4ZW5idXNfcHJpbnRmKFhCVF9OSUwsIGluZm8tPmRl
di0+bm9kZW5hbWUsCj4gIAkJCSAgICAgIGluZm8tPmRldl9zdGF0ZV9wYXRoLCAiJWQiLCBYZW5i
dXNTdGF0ZUNvbm5lY3RlZCk7Cj4gKwkJaWYgKGVycikgewo+ICsJCQlkZXZfZXJyKCZpbmZvLT5k
ZXYtPmRldiwgIndyaXRpbmcgZGV2X3N0YXRlX3BhdGhcbiIpOwoKVGhlc2UgZXJyb3JzIHNob3Vs
ZCBiZSByZXBvcnRlZCB1c2luZyB4ZW5idXNfZGV2X2Vycm9yKCkuCgpBbmQgdGhlIHNlY29uZCBw
YXRjaCB0b28uCgotYm9yaXMKCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVucHJv
amVjdC5vcmcKaHR0cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3hl
bi1kZXZlbA==
