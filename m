From: Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [PATCH V3 2/9] blk-zoned: update blkdev_nr_zones()
 with helper
Date: Wed, 3 Jul 2019 09:20:37 +0900
Message-ID: <20190703002037.GC15705@minwoo-desktop>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
 <20190702174236.3332-3-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
Content-Disposition: inline
In-Reply-To: <20190702174236.3332-3-chaitanya.kulkarni@wdc.com>
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

T24gMTktMDctMDIgMTA6NDI6MjgsIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToKPiBUaGlzIHBh
dGNoIHVwZGF0ZXMgdGhlIGJsa2Rldl9ucl96b25lcygpIHdpdGggbmV3bHkgaW50cm9kdWNlZCBo
ZWxwZXIKPiBmdW5jdGlvbiB0byByZWFkIHRoZSBucl9zZWN0cyBmcm9tIGJsb2NrIGRldmljZSdz
IGhkX3BhcnRzIHdpdGggdGhlCj4gaGVscCBpZiBwYXJ0X25yX3NlY3RzX3JlYWQoKS4KCkl0IGxv
b2tzIGdvb2QgdG8gbWUuCgpSZXZpZXdlZC1ieTogTWlud29vIEltIDxtaW53b28uaW0uZGV2QGdt
YWlsLmNvbT4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Clhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxpc3RzLnhlbnByb2plY3Qub3JnCmh0
dHBzOi8vbGlzdHMueGVucHJvamVjdC5vcmcvbWFpbG1hbi9saXN0aW5mby94ZW4tZGV2ZWw=
