From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH V3 4/9] blk-zoned: update
 blkdev_reset_zones() with helper
Date: Wed, 3 Jul 2019 02:29:33 +0000
Message-ID: <DM6PR04MB5754D27FC41D86E2D419DD6C86FB0@DM6PR04MB5754.namprd04.prod.outlook.com>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
 <20190702174236.3332-5-chaitanya.kulkarni@wdc.com>
 <20190703002347.GE15705@minwoo-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: Minwoo Im <minwoo.im.dev@gmail.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-btrace@vger.kernel.org" <linux-btrace@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "yuchao0@huawei.com" <yuchao0@huawei.com>, "colyli@suse.de" <colyli@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>
List-Id: linux-scsi@vger.kernel.org

T24gNy8yLzE5IDU6MjMgUE0sIE1pbndvbyBJbSB3cm90ZToKPiBPbiAxOS0wNy0wMiAxMDo0Mjoz
MCwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOgo+PiBUaGlzIHBhdGNoIHVwZGF0ZXMgdGhlIGJs
a2Rldl9yZXNldF96b25lcygpIHdpdGggbmV3bHkgaW50cm9kdWNlZAo+PiBoZWxwZXIgZnVuY3Rp
b24gdG8gcmVhZCB0aGUgbnJfc2VjdHMgZnJvbSBibG9jayBkZXZpY2UncyBoZF9wYXJ0cyB3aXRo
Cj4+IHRoZSBoZWxwIG9mIHBhcnRfbnJfc2VjdHNfcmVhZCgpLgo+IENoYWl0YW55YSwKPgo+IEFy
ZSB0aGUgZmlyc3QgdGhyZWUgcGF0Y2hlcyBzcGxpdCBmb3IgYSBzcGVjaWFsIHJlYXNvbj8gIElN
SE8sIGl0IGNvdWxkCj4gYmUgc3F1YXNoZWQgaW50byBhIHNpbmdsZSBvbmUuCj4KPiBJdCBsb29r
cyBnb29kIHRvIG1lLCBieSB0aGUgd2F5LgoKSW4gdGhlIGJsay16b25lZC5jIGluIHRoaXMgd2F5
IGl0IGlzIGVhc2llciB0byBiaXNlY3QgaWYvd2hlbiB0aGUgcHJvYmxlbQoKY29tZXMuCgo+Cj4g
UmV2aWV3ZWQtYnk6IE1pbndvbyBJbSA8bWlud29vLmltLmRldkBnbWFpbC5jb20+Cj4KCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpYZW4tZGV2ZWwgbWFp
bGluZyBsaXN0Clhlbi1kZXZlbEBsaXN0cy54ZW5wcm9qZWN0Lm9yZwpodHRwczovL2xpc3RzLnhl
bnByb2plY3Qub3JnL21haWxtYW4vbGlzdGluZm8veGVuLWRldmVs
