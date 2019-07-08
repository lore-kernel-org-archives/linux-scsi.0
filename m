From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 1/9] block: add a helper function to read
 nr_setcs
Date: Mon,  8 Jul 2019 11:47:03 -0700
Message-ID: <20190708184711.2984-2-chaitanya.kulkarni@wdc.com>
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

VGhpcyBwYXRjaCBpbnRyb2R1Y2VzIGhlbHBlciBmdW5jdGlvbiB0byByZWFkIHRoZSBudW1iZXIg
b2Ygc2VjdG9ycwpmcm9tIHN0cnVjdCBibG9ja19kZXZpY2UtPmJkX3BhcnQgbWVtYmVyLiBGb3Ig
bW9yZSBkZXRhaWxzIFBsZWFzZSByZWZlcgp0byB0aGUgY29tbWVudCBpbiB0aGUgaW5jbHVkZS9s
aW51eC9nZW5oZC5oIGZvciBwYXJ0X25yX3NlY3RzX3JlYWQoKS4KClNpZ25lZC1vZmYtYnk6IENo
YWl0YW55YSBLdWxrYXJuaSA8Y2hhaXRhbnlhLmt1bGthcm5pQHdkYy5jb20+Ci0tLQogaW5jbHVk
ZS9saW51eC9ibGtkZXYuaCB8IDUgKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMo
KykKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2Jsa2Rldi5oIGIvaW5jbHVkZS9saW51eC9i
bGtkZXYuaAppbmRleCAwYzQ4MjM3MWM4YjMuLjU3ODM4MzcxMjA5MyAxMDA2NDQKLS0tIGEvaW5j
bHVkZS9saW51eC9ibGtkZXYuaAorKysgYi9pbmNsdWRlL2xpbnV4L2Jsa2Rldi5oCkBAIC0xNDY0
LDYgKzE0NjQsMTEgQEAgc3RhdGljIGlubGluZSB2b2lkIHB1dF9kZXZfc2VjdG9yKFNlY3RvciBw
KQogCXB1dF9wYWdlKHAudik7CiB9CiAKK3N0YXRpYyBpbmxpbmUgc2VjdG9yX3QgYmRldl9ucl9z
ZWN0cyhzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2KQoreworCXJldHVybiBwYXJ0X25yX3NlY3Rz
X3JlYWQoYmRldi0+YmRfcGFydCk7Cit9CisKIGludCBrYmxvY2tkX3NjaGVkdWxlX3dvcmsoc3Ry
dWN0IHdvcmtfc3RydWN0ICp3b3JrKTsKIGludCBrYmxvY2tkX3NjaGVkdWxlX3dvcmtfb24oaW50
IGNwdSwgc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsKIGludCBrYmxvY2tkX21vZF9kZWxheWVk
X3dvcmtfb24oaW50IGNwdSwgc3RydWN0IGRlbGF5ZWRfd29yayAqZHdvcmssIHVuc2lnbmVkIGxv
bmcgZGVsYXkpOwotLSAKMi4xNy4wCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVu
cHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZv
L3hlbi1kZXZlbA==
