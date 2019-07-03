From: Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [PATCH V3 4/9] blk-zoned: update
 blkdev_reset_zones() with helper
Date: Wed, 3 Jul 2019 09:23:47 +0900
Message-ID: <20190703002347.GE15705@minwoo-desktop>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
 <20190702174236.3332-5-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
Content-Disposition: inline
In-Reply-To: <20190702174236.3332-5-chaitanya.kulkarni@wdc.com>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: damien.lemoal@wdc.com, linux-btrace@vger.kernel.org, bvanassche@acm.org, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, yuchao0@huawei.com, colyli@suse.de, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Minwoo Im <minwoo.im.dev@gmail.com>, jaegeuk@kernel.org, xen-devel@lists.xenproject.org, kent.overstreet@gmail.com, roger.pau@citrix.com
List-Id: linux-scsi@vger.kernel.org

T24gMTktMDctMDIgMTA6NDI6MzAsIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToKPiBUaGlzIHBh
dGNoIHVwZGF0ZXMgdGhlIGJsa2Rldl9yZXNldF96b25lcygpIHdpdGggbmV3bHkgaW50cm9kdWNl
ZAo+IGhlbHBlciBmdW5jdGlvbiB0byByZWFkIHRoZSBucl9zZWN0cyBmcm9tIGJsb2NrIGRldmlj
ZSdzIGhkX3BhcnRzIHdpdGgKPiB0aGUgaGVscCBvZiBwYXJ0X25yX3NlY3RzX3JlYWQoKS4KCkNo
YWl0YW55YSwKCkFyZSB0aGUgZmlyc3QgdGhyZWUgcGF0Y2hlcyBzcGxpdCBmb3IgYSBzcGVjaWFs
IHJlYXNvbj8gIElNSE8sIGl0IGNvdWxkCmJlIHNxdWFzaGVkIGludG8gYSBzaW5nbGUgb25lLgoK
SXQgbG9va3MgZ29vZCB0byBtZSwgYnkgdGhlIHdheS4KClJldmlld2VkLWJ5OiBNaW53b28gSW0g
PG1pbndvby5pbS5kZXZAZ21haWwuY29tPgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMu
eGVucHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL3hlbi1kZXZlbA==
