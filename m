From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 6/9] f2fs: use helper in init_blkz_info()
Date: Mon,  8 Jul 2019 11:47:08 -0700
Message-ID: <20190708184711.2984-7-chaitanya.kulkarni@wdc.com>
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

VGhpcyBwYXRjaCB1cGRhdGVzIHRoZSBpbml0X2Jsa3pfaW5mbygpIHdpdGggbmV3bHkgaW50cm9k
dWNlZCBoZWxwZXIKZnVuY3Rpb24gdG8gcmVhZCB0aGUgbnJfc2VjdHMgZnJvbSBibG9jayBkZXZp
Y2UncyBoZF9wYXJ0cyB3aXRoIHRoZQpoZWxwIG9mIHBhcnRfbnJfc2VjdHNfcmVhZCgpLgoKU2ln
bmVkLW9mZi1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxjaGFpdGFueWEua3Vsa2FybmlAd2RjLmNv
bT4KLS0tCiBmcy9mMmZzL3N1cGVyLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9mMmZzL3N1cGVyLmMgYi9mcy9m
MmZzL3N1cGVyLmMKaW5kZXggNmI5NTliYmIzMzZhLi4yNGUyODQ4YWZjZjUgMTAwNjQ0Ci0tLSBh
L2ZzL2YyZnMvc3VwZXIuYworKysgYi9mcy9mMmZzL3N1cGVyLmMKQEAgLTI3OTgsNyArMjc5OCw3
IEBAIHN0YXRpYyBpbnQgaW5pdF9wZXJjcHVfaW5mbyhzdHJ1Y3QgZjJmc19zYl9pbmZvICpzYmkp
CiBzdGF0aWMgaW50IGluaXRfYmxrel9pbmZvKHN0cnVjdCBmMmZzX3NiX2luZm8gKnNiaSwgaW50
IGRldmkpCiB7CiAJc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiA9IEZERVYoZGV2aSkuYmRldjsK
LQlzZWN0b3JfdCBucl9zZWN0b3JzID0gYmRldi0+YmRfcGFydC0+bnJfc2VjdHM7CisJc2VjdG9y
X3QgbnJfc2VjdG9ycyA9IGJkZXZfbnJfc2VjdHMoYmRldik7CiAJc2VjdG9yX3Qgc2VjdG9yID0g
MDsKIAlzdHJ1Y3QgYmxrX3pvbmUgKnpvbmVzOwogCXVuc2lnbmVkIGludCBpLCBucl96b25lczsK
LS0gCjIuMTcuMAoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbnByb2plY3Qub3Jn
Cmh0dHBzOi8vbGlzdHMueGVucHJvamVjdC5vcmcvbWFpbG1hbi9saXN0aW5mby94ZW4tZGV2ZWw=
