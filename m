From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V3 7/9] blktrace: use helper in
 blk_trace_setup_lba()
Date: Tue,  2 Jul 2019 10:42:33 -0700
Message-ID: <20190702174236.3332-8-chaitanya.kulkarni@wdc.com>
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

VGhpcyBwYXRjaCB1cGRhdGVzIHRoZSBibGtfdHJhY2Vfc2V0dXBfbGJhKCkgd2l0aCBuZXdseSBp
bnRyb2R1Y2VkCmhlbHBlciBmdW5jdGlvbiB0byByZWFkIHRoZSBucl9zZWN0cyBmcm9tIGJsb2Nr
IGRldmljZSdzIGhkX3BhcnRzIHdpdGgKdGhlIGhlbHAgb2YgcGFydF9ucl9zZWN0c19yZWFkKCku
CgpTaWduZWQtb2ZmLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGNoYWl0YW55YS5rdWxrYXJuaUB3
ZGMuY29tPgotLS0KIGtlcm5lbC90cmFjZS9ibGt0cmFjZS5jIHwgMiArLQogMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL3Ry
YWNlL2Jsa3RyYWNlLmMgYi9rZXJuZWwvdHJhY2UvYmxrdHJhY2UuYwppbmRleCBlMWM2ZDc5ZmI0
Y2MuLjM1ZmY0OTUwM2I4NSAxMDA2NDQKLS0tIGEva2VybmVsL3RyYWNlL2Jsa3RyYWNlLmMKKysr
IGIva2VybmVsL3RyYWNlL2Jsa3RyYWNlLmMKQEAgLTQ2MSw3ICs0NjEsNyBAQCBzdGF0aWMgdm9p
ZCBibGtfdHJhY2Vfc2V0dXBfbGJhKHN0cnVjdCBibGtfdHJhY2UgKmJ0LAogCiAJaWYgKHBhcnQp
IHsKIAkJYnQtPnN0YXJ0X2xiYSA9IHBhcnQtPnN0YXJ0X3NlY3Q7Ci0JCWJ0LT5lbmRfbGJhID0g
cGFydC0+c3RhcnRfc2VjdCArIHBhcnQtPm5yX3NlY3RzOworCQlidC0+ZW5kX2xiYSA9IHBhcnQt
PnN0YXJ0X3NlY3QgKyBiZGV2X25yX3NlY3RzKGJkZXYpOwogCX0gZWxzZSB7CiAJCWJ0LT5zdGFy
dF9sYmEgPSAwOwogCQlidC0+ZW5kX2xiYSA9IC0xVUxMOwotLSAKMi4xOS4xCgoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcg
bGlzdApYZW4tZGV2ZWxAbGlzdHMueGVucHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0cy54ZW5wcm9q
ZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3hlbi1kZXZlbA==
