From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V3 2/9] blk-zoned: update blkdev_nr_zones() with
 helper
Date: Tue,  2 Jul 2019 10:42:28 -0700
Message-ID: <20190702174236.3332-3-chaitanya.kulkarni@wdc.com>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
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

VGhpcyBwYXRjaCB1cGRhdGVzIHRoZSBibGtkZXZfbnJfem9uZXMoKSB3aXRoIG5ld2x5IGludHJv
ZHVjZWQgaGVscGVyCmZ1bmN0aW9uIHRvIHJlYWQgdGhlIG5yX3NlY3RzIGZyb20gYmxvY2sgZGV2
aWNlJ3MgaGRfcGFydHMgd2l0aCB0aGUKaGVscCBpZiBwYXJ0X25yX3NlY3RzX3JlYWQoKS4KClNp
Z25lZC1vZmYtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8Y2hhaXRhbnlhLmt1bGthcm5pQHdkYy5j
b20+Ci0tLQogYmxvY2svYmxrLXpvbmVkLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9ibG9jay9ibGstem9uZWQuYyBi
L2Jsb2NrL2Jsay16b25lZC5jCmluZGV4IGFlN2U5MWJkMDYxOC4uNTA1MWRiMzVjM2ZkIDEwMDY0
NAotLS0gYS9ibG9jay9ibGstem9uZWQuYworKysgYi9ibG9jay9ibGstem9uZWQuYwpAQCAtOTAs
NyArOTAsNyBAQCB1bnNpZ25lZCBpbnQgYmxrZGV2X25yX3pvbmVzKHN0cnVjdCBibG9ja19kZXZp
Y2UgKmJkZXYpCiAJaWYgKCFibGtfcXVldWVfaXNfem9uZWQocSkpCiAJCXJldHVybiAwOwogCi0J
cmV0dXJuIF9fYmxrZGV2X25yX3pvbmVzKHEsIGJkZXYtPmJkX3BhcnQtPm5yX3NlY3RzKTsKKwly
ZXR1cm4gX19ibGtkZXZfbnJfem9uZXMocSwgYmRldl9ucl9zZWN0cyhiZGV2KSk7CiB9CiBFWFBP
UlRfU1lNQk9MX0dQTChibGtkZXZfbnJfem9uZXMpOwogCi0tIAoyLjE5LjEKCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpYZW4tZGV2ZWwgbWFpbGluZyBs
aXN0Clhlbi1kZXZlbEBsaXN0cy54ZW5wcm9qZWN0Lm9yZwpodHRwczovL2xpc3RzLnhlbnByb2pl
Y3Qub3JnL21haWxtYW4vbGlzdGluZm8veGVuLWRldmVs
