From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 8/9] target/pscsi: use helper in
 pscsi_get_blocks()
Date: Mon,  8 Jul 2019 11:47:10 -0700
Message-ID: <20190708184711.2984-9-chaitanya.kulkarni@wdc.com>
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

VGhpcyBwYXRjaCB1cGRhdGVzIHRoZSBwc2NzaV9nZXRfYmxvY2tzKCkgd2l0aCBuZXdseSBpbnRy
b2R1Y2VkIGhlbHBlcgpmdW5jdGlvbiB0byByZWFkIHRoZSBucl9zZWN0cyBmcm9tIGJsb2NrIGRl
dmljZSdzIGhkX3BhcnRzIHdpdGggdGhlCmhlbHAgb2YgcGFydF9ucl9zZWN0c19yZWFkKCkuCgpT
aWduZWQtb2ZmLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGNoYWl0YW55YS5rdWxrYXJuaUB3ZGMu
Y29tPgotLS0KIGRyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3BzY3NpLmMgfCAyICstCiAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV9wc2NzaS5jIGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0
X2NvcmVfcHNjc2kuYwppbmRleCBjOWQ5MmIzZTc3N2QuLmRhNDgxZWRhYjJkZSAxMDA2NDQKLS0t
IGEvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfcHNjc2kuYworKysgYi9kcml2ZXJzL3Rhcmdl
dC90YXJnZXRfY29yZV9wc2NzaS5jCkBAIC0xMDMwLDcgKzEwMzAsNyBAQCBzdGF0aWMgc2VjdG9y
X3QgcHNjc2lfZ2V0X2Jsb2NrcyhzdHJ1Y3Qgc2VfZGV2aWNlICpkZXYpCiAJc3RydWN0IHBzY3Np
X2Rldl92aXJ0ICpwZHYgPSBQU0NTSV9ERVYoZGV2KTsKIAogCWlmIChwZHYtPnBkdl9iZCAmJiBw
ZHYtPnBkdl9iZC0+YmRfcGFydCkKLQkJcmV0dXJuIHBkdi0+cGR2X2JkLT5iZF9wYXJ0LT5ucl9z
ZWN0czsKKwkJcmV0dXJuIGJkZXZfbnJfc2VjdHMocGR2LT5wZHZfYmQpOwogCiAJcmV0dXJuIDA7
CiB9Ci0tIAoyLjE3LjAKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpYZW4tZGV2ZWwgbWFpbGluZyBsaXN0Clhlbi1kZXZlbEBsaXN0cy54ZW5wcm9qZWN0
Lm9yZwpodHRwczovL2xpc3RzLnhlbnByb2plY3Qub3JnL21haWxtYW4vbGlzdGluZm8veGVuLWRl
dmVs
