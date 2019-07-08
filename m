From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 5/9] bcache: update cached_dev_init() with
 helper
Date: Mon,  8 Jul 2019 11:47:07 -0700
Message-ID: <20190708184711.2984-6-chaitanya.kulkarni@wdc.com>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: linux-block@vger.kernel.org
Cc: damien.lemoal@wdc.com, linux-btrace@vger.kernel.org, bvanassche@acm.org, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, yuchao0@huawei.com, colyli@suse.de, linux-bcache@vger.kernel.org, jaegeuk@kernel.org, xen-devel@lists.xenproject.org, kent.overstreet@gmail.com, roger.pau@citrix.com
List-Id: linux-scsi@vger.kernel.org

SW4gdGhlIGJjYWNoZSB3aGVuIGluaXRpYWxpemluZyB0aGUgY2FjaGVkIGRldmljZSB3ZSBkb24n
dCBhY3R1YWxseQp1c2UgYW55IHNvcnQgb2YgbG9ja2luZyB3aGVuIHJlYWRpbmcgdGhlIG51bWJl
ciBvZiBzZWN0b3JzIGZyb20gdGhlCnBhcnQuIFRoaXMgcGF0Y2ggdXBkYXRlcyB0aGUgY2FjaGVk
X2Rldl9pbml0KCkgd2l0aCBuZXdseSBpbnRyb2R1Y2VkCmhlbHBlciBmdW5jdGlvbiB0byByZWFk
IHRoZSBucl9zZWN0cyBmcm9tIGJsb2NrIGRldmljZSdzIGhkX3BhcnRzIHdpdGgKdGhlIGhlbHAg
b2YgcGFydF9ucl9zZWN0c19yZWFkKCkuCgpBY2tlZC1ieTogQ29seSBMaSA8Y29seWxpQHN1c2Uu
ZGU+ClNpZ25lZC1vZmYtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8Y2hhaXRhbnlhLmt1bGthcm5p
QHdkYy5jb20+Ci0tLQogZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIuYyB8IDIgKy0KIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbWQvYmNhY2hlL3N1cGVyLmMgYi9kcml2ZXJzL21kL2JjYWNoZS9zdXBlci5jCmluZGV4IDI2
ZTM3NGZiZjU3Yy4uMDI0YzUyZDExYjBmIDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL2JjYWNoZS9z
dXBlci5jCisrKyBiL2RyaXZlcnMvbWQvYmNhY2hlL3N1cGVyLmMKQEAgLTEzMDIsNyArMTMwMiw3
IEBAIHN0YXRpYyBpbnQgY2FjaGVkX2Rldl9pbml0KHN0cnVjdCBjYWNoZWRfZGV2ICpkYywgdW5z
aWduZWQgaW50IGJsb2NrX3NpemUpCiAJCQlxLT5saW1pdHMucmFpZF9wYXJ0aWFsX3N0cmlwZXNf
ZXhwZW5zaXZlOwogCiAJcmV0ID0gYmNhY2hlX2RldmljZV9pbml0KCZkYy0+ZGlzaywgYmxvY2tf
c2l6ZSwKLQkJCSBkYy0+YmRldi0+YmRfcGFydC0+bnJfc2VjdHMgLSBkYy0+c2IuZGF0YV9vZmZz
ZXQpOworCQkJIGJkZXZfbnJfc2VjdHMoZGMtPmJkZXYpIC0gZGMtPnNiLmRhdGFfb2Zmc2V0KTsK
IAlpZiAocmV0KQogCQlyZXR1cm4gcmV0OwogCi0tIAoyLjE3LjAKCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpYZW4tZGV2ZWwgbWFpbGluZyBsaXN0Clhl
bi1kZXZlbEBsaXN0cy54ZW5wcm9qZWN0Lm9yZwpodHRwczovL2xpc3RzLnhlbnByb2plY3Qub3Jn
L21haWxtYW4vbGlzdGluZm8veGVuLWRldmVs
