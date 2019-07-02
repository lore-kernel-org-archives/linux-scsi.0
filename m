From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [COMPILE TEST ONLY PATCH V3 9/9] xen/blkback: use
 helper in vbd_sz()
Date: Tue,  2 Jul 2019 10:42:35 -0700
Message-ID: <20190702174236.3332-10-chaitanya.kulkarni@wdc.com>
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

VGhpcyBwYXRjaCB1cGRhdGVzIHRoZSB2YmRfc3ooKSBtYWNybyB3aXRoIG5ld2x5IGludHJvZHVj
ZWQgaGVscGVyCmZ1bmN0aW9uIHRvIHJlYWQgdGhlIG5yX3NlY3RzIGZyb20gYmxvY2sgZGV2aWNl
J3MgaGRfcGFydHMgd2l0aCB0aGUKaGVscCBvZiBwYXJ0X25yX3NlY3RzX3JlYWQoKS4KClNpZ25l
ZC1vZmYtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8Y2hhaXRhbnlhLmt1bGthcm5pQHdkYy5jb20+
Ci0tLQogZHJpdmVycy9ibG9jay94ZW4tYmxrYmFjay9jb21tb24uaCB8IDIgKy0KIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvYmxvY2sveGVuLWJsa2JhY2svY29tbW9uLmggYi9kcml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNr
L2NvbW1vbi5oCmluZGV4IDFkMzAwMmQ3NzNmNy4uZjk2Y2I4ZDFjYjk5IDEwMDY0NAotLS0gYS9k
cml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNrL2NvbW1vbi5oCisrKyBiL2RyaXZlcnMvYmxvY2sveGVu
LWJsa2JhY2svY29tbW9uLmgKQEAgLTM1OSw3ICszNTksNyBAQCBzdHJ1Y3QgcGVuZGluZ19yZXEg
ewogCiAKICNkZWZpbmUgdmJkX3N6KF92KQkoKF92KS0+YmRldi0+YmRfcGFydCA/IFwKLQkJCSAo
X3YpLT5iZGV2LT5iZF9wYXJ0LT5ucl9zZWN0cyA6IFwKKwkJCSAgYmRldl9ucl9zZWN0cygoX3Yp
LT5iZGV2KSA6IFwKIAkJCSAgZ2V0X2NhcGFjaXR5KChfdiktPmJkZXYtPmJkX2Rpc2spKQogCiAj
ZGVmaW5lIHhlbl9ibGtpZl9nZXQoX2IpIChhdG9taWNfaW5jKCYoX2IpLT5yZWZjbnQpKQotLSAK
Mi4xOS4xCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
WGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVucHJvamVjdC5vcmcKaHR0
cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3hlbi1kZXZlbA==
