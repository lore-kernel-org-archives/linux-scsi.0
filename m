From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V3 1/9] block: add a helper function to read
 nr_setcs
Date: Tue,  2 Jul 2019 10:42:27 -0700
Message-ID: <20190702174236.3332-2-chaitanya.kulkarni@wdc.com>
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

VGhpcyBwYXRjaCBpbnRyb2R1Y2VzIGhlbHBlciBmdW5jdGlvbiB0byByZWFkIHRoZSBudW1iZXIg
b2Ygc2VjdG9ycwpmcm9tIHN0cnVjdCBibG9ja19kZXZpY2UtPmJkX3BhcnQgbWVtYmVyLiBGb3Ig
bW9yZSBkZXRhaWxzIFBsZWFzZSByZWZlcgp0byB0aGUgY29tbWVudCBpbiB0aGUgaW5jbHVkZS9s
aW51eC9nZW5oZC5oIGZvciBwYXJ0X25yX3NlY3RzX3JlYWQoKS4KClNpZ25lZC1vZmYtYnk6IENo
YWl0YW55YSBLdWxrYXJuaSA8Y2hhaXRhbnlhLmt1bGthcm5pQHdkYy5jb20+Ci0tLQogaW5jbHVk
ZS9saW51eC9ibGtkZXYuaCB8IDYgKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25z
KCspCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9ibGtkZXYuaCBiL2luY2x1ZGUvbGludXgv
YmxrZGV2LmgKaW5kZXggNTkyNjY5YmNjNTM2Li5iZTdlZTVhMGIwZGQgMTAwNjQ0Ci0tLSBhL2lu
Y2x1ZGUvbGludXgvYmxrZGV2LmgKKysrIGIvaW5jbHVkZS9saW51eC9ibGtkZXYuaApAQCAtMTQ3
NSw2ICsxNDc1LDEyIEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBwdXRfZGV2X3NlY3RvcihTZWN0b3Ig
cCkKIAlwdXRfcGFnZShwLnYpOwogfQogCisvKiBIZWxwZXIgZnVuY3Rpb24gdG8gcmVhZCB0aGUg
YmRldi0+YmRfcGFydC0+bnJfc2VjdHMgKi8KK3N0YXRpYyBpbmxpbmUgc2VjdG9yX3QgYmRldl9u
cl9zZWN0cyhzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2KQoreworCXJldHVybiBwYXJ0X25yX3Nl
Y3RzX3JlYWQoYmRldi0+YmRfcGFydCk7Cit9CisKIGludCBrYmxvY2tkX3NjaGVkdWxlX3dvcmso
c3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsKIGludCBrYmxvY2tkX3NjaGVkdWxlX3dvcmtfb24o
aW50IGNwdSwgc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsKIGludCBrYmxvY2tkX21vZF9kZWxh
eWVkX3dvcmtfb24oaW50IGNwdSwgc3RydWN0IGRlbGF5ZWRfd29yayAqZHdvcmssIHVuc2lnbmVk
IGxvbmcgZGVsYXkpOwotLSAKMi4xOS4xCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMu
eGVucHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL3hlbi1kZXZlbA==
