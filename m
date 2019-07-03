From: Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [PATCH V3 4/9] blk-zoned: update
 blkdev_reset_zones() with helper
Date: Wed, 3 Jul 2019 14:25:28 +0900
Message-ID: <20190703052528.GB21258@minwoo-desktop>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
 <20190702174236.3332-5-chaitanya.kulkarni@wdc.com>
 <20190703002347.GE15705@minwoo-desktop>
 <DM6PR04MB5754D27FC41D86E2D419DD6C86FB0@DM6PR04MB5754.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
Content-Disposition: inline
In-Reply-To: <DM6PR04MB5754D27FC41D86E2D419DD6C86FB0@DM6PR04MB5754.namprd04.prod.outlook.com>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-btrace@vger.kernel.org" <linux-btrace@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "yuchao0@huawei.com" <yuchao0@huawei.com>, "colyli@suse.de" <colyli@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Minwoo Im <minwoo.im.dev@gmail.com>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>
List-Id: linux-scsi@vger.kernel.org

T24gMTktMDctMDMgMDI6Mjk6MzMsIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToKPiBPbiA3LzIv
MTkgNToyMyBQTSwgTWlud29vIEltIHdyb3RlOgo+ID4gT24gMTktMDctMDIgMTA6NDI6MzAsIENo
YWl0YW55YSBLdWxrYXJuaSB3cm90ZToKPiA+PiBUaGlzIHBhdGNoIHVwZGF0ZXMgdGhlIGJsa2Rl
dl9yZXNldF96b25lcygpIHdpdGggbmV3bHkgaW50cm9kdWNlZAo+ID4+IGhlbHBlciBmdW5jdGlv
biB0byByZWFkIHRoZSBucl9zZWN0cyBmcm9tIGJsb2NrIGRldmljZSdzIGhkX3BhcnRzIHdpdGgK
PiA+PiB0aGUgaGVscCBvZiBwYXJ0X25yX3NlY3RzX3JlYWQoKS4KPiA+IENoYWl0YW55YSwKPiA+
Cj4gPiBBcmUgdGhlIGZpcnN0IHRocmVlIHBhdGNoZXMgc3BsaXQgZm9yIGEgc3BlY2lhbCByZWFz
b24/ICBJTUhPLCBpdCBjb3VsZAo+ID4gYmUgc3F1YXNoZWQgaW50byBhIHNpbmdsZSBvbmUuCj4g
Pgo+ID4gSXQgbG9va3MgZ29vZCB0byBtZSwgYnkgdGhlIHdheS4KPiAKPiBJbiB0aGUgYmxrLXpv
bmVkLmMgaW4gdGhpcyB3YXkgaXQgaXMgZWFzaWVyIHRvIGJpc2VjdCBpZi93aGVuIHRoZSBwcm9i
bGVtCj4gCj4gY29tZXMuCgpPaCBva2F5LiAgVGhhdCBtYWtlcyBzZW5zZS4KClRoYW5rcywgQ2hh
aXRhbnlhLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
WGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVucHJvamVjdC5vcmcKaHR0
cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3hlbi1kZXZlbA==
