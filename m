From: Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [PATCH V3 3/9] blk-zoned: update
 blkdev_report_zone() with helper
Date: Wed, 3 Jul 2019 09:21:07 +0900
Message-ID: <20190703002107.GD15705@minwoo-desktop>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
 <20190702174236.3332-4-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
Content-Disposition: inline
In-Reply-To: <20190702174236.3332-4-chaitanya.kulkarni@wdc.com>
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

T24gMTktMDctMDIgMTA6NDI6MjksIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToKPiBUaGlzIHBh
dGNoIHVwZGF0ZXMgdGhlIGJsa2Rldl9yZXBvcnRfem9uZShzKSgpIHdpdGggbmV3bHkgaW50cm9k
dWNlZAo+IGhlbHBlciBmdW5jdGlvbiB0byByZWFkIHRoZSBucl9zZWN0cyBmcm9tIGJsb2NrIGRl
dmljZSdzIGhkX3BhcnRzIHdpdGgKPiB0aGUgaGVscCBvZiBwYXJ0X25yX3NlY3RzX3JlYWQoKS4K
Ckl0IGxvb2tzIGdvb2QgdG8gbWUuCgpSZXZpZXdlZC1ieTogTWlud29vIEltIDxtaW53b28uaW0u
ZGV2QGdtYWlsLmNvbT4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbnByb2plY3Qu
b3JnCmh0dHBzOi8vbGlzdHMueGVucHJvamVjdC5vcmcvbWFpbG1hbi9saXN0aW5mby94ZW4tZGV2
ZWw=
