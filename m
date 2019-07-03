From: Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [PATCH V3 1/9] block: add a helper function to read
 nr_setcs
Date: Wed, 3 Jul 2019 09:19:04 +0900
Message-ID: <20190703001904.GB15705@minwoo-desktop>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
 <20190702174236.3332-2-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
Content-Disposition: inline
In-Reply-To: <20190702174236.3332-2-chaitanya.kulkarni@wdc.com>
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

T24gMTktMDctMDIgMTA6NDI6MjcsIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToKPiBUaGlzIHBh
dGNoIGludHJvZHVjZXMgaGVscGVyIGZ1bmN0aW9uIHRvIHJlYWQgdGhlIG51bWJlciBvZiBzZWN0
b3JzCj4gZnJvbSBzdHJ1Y3QgYmxvY2tfZGV2aWNlLT5iZF9wYXJ0IG1lbWJlci4gRm9yIG1vcmUg
ZGV0YWlscyBQbGVhc2UgcmVmZXIKPiB0byB0aGUgY29tbWVudCBpbiB0aGUgaW5jbHVkZS9saW51
eC9nZW5oZC5oIGZvciBwYXJ0X25yX3NlY3RzX3JlYWQoKS4KCldpdGhvdXQgYmRfbXV0ZXggbG9j
a2VkLCB0aGlzIGhlbHBlciBzZWVtcyB1c2VmdWwgdG8gaGF2ZS4KClJldmlld2VkLWJ5OiBNaW53
b28gSW0gPG1pbndvby5pbS5kZXZAZ21haWwuY29tPgoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxA
bGlzdHMueGVucHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFu
L2xpc3RpbmZvL3hlbi1kZXZlbA==
