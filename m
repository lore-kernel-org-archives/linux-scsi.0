From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
Subject: Re: [PATCH V4 9/9] xen/blkback: use helper in vbd_sz()
Date: Mon, 15 Jul 2019 12:36:40 +0200
Message-ID: <20190715103640.i6gwasdjdkltm47n@MacBook-Air-de-Roger.local>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
 <20190708184711.2984-10-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
Content-Disposition: inline
In-Reply-To: <20190708184711.2984-10-chaitanya.kulkarni@wdc.com>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: damien.lemoal@wdc.com, linux-btrace@vger.kernel.org, bvanassche@acm.org, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, yuchao0@huawei.com, colyli@suse.de, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, jaegeuk@kernel.org, xen-devel@lists.xenproject.org, kent.overstreet@gmail.com
List-Id: linux-scsi@vger.kernel.org

T24gTW9uLCBKdWwgMDgsIDIwMTkgYXQgMTE6NDc6MTFBTSAtMDcwMCwgQ2hhaXRhbnlhIEt1bGth
cm5pIHdyb3RlOgo+IFRoaXMgcGF0Y2ggdXBkYXRlcyB0aGUgdmJkX3N6KCkgbWFjcm8gd2l0aCBu
ZXdseSBpbnRyb2R1Y2VkIGhlbHBlcgo+IGZ1bmN0aW9uIHRvIHJlYWQgdGhlIG5yX3NlY3RzIGZy
b20gYmxvY2sgZGV2aWNlJ3MgaGRfcGFydHMgd2l0aCB0aGUKPiBoZWxwIG9mIHBhcnRfbnJfc2Vj
dHNfcmVhZCgpLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8Y2hhaXRh
bnlhLmt1bGthcm5pQHdkYy5jb20+CgpBY2tlZC1ieTogUm9nZXIgUGF1IE1vbm7DqSA8cm9nZXIu
cGF1QGNpdHJpeC5jb20+CgpUaGFua3MsIFJvZ2VyLgoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxA
bGlzdHMueGVucHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFu
L2xpc3RpbmZvL3hlbi1kZXZlbA==
