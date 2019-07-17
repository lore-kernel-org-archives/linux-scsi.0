From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V4 1/9] block: add a helper function to read
 nr_setcs
Date: Tue, 16 Jul 2019 22:28:30 -0400
Message-ID: <yq1sgr5z969.fsf@oracle.com>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
 <20190708184711.2984-2-chaitanya.kulkarni@wdc.com>
 <yq18st457yb.fsf@oracle.com>
 <BYAPR04MB5749AF90A9E9C81B4A6857F386F20@BYAPR04MB5749.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <BYAPR04MB5749AF90A9E9C81B4A6857F386F20@BYAPR04MB5749.namprd04.prod.outlook.com>
 (Chaitanya Kulkarni's message of "Fri, 12 Jul 2019 16:09:56 +0000")
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-btrace@vger.kernel.org" <linux-btrace@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "yuchao0@huawei.com" <yuchao0@huawei.com>, "colyli@suse.de" <colyli@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>
List-Id: linux-scsi@vger.kernel.org

CkNoYWl0YW55YSwKCj4gVGhpcyBzZXJpZXMganVzdCByZXBsYWNlcyB0aGUgZXhpc3RpbmcgYWNj
ZXNzZXMgd2l0aG91dCBjaGFuZ2luZwo+IGFueXRoaW5nLgo+Cj4gU28gaWYgYW55IG9mIHRoZSBl
eGl0aW5nIGNvZGUgaGFzIHRoYXQgYnVnIHRoZW4gaXQgd2lsbCBibG93IHVwCj4gbmljZWx5Lgo+
Cj4gRm9yIGZ1dHVyZSBjYWxsZXJzIEkgZG9uJ3QgbWluZCBhZGRpbmcgYSBuZXcgY2hlY2sgYW5k
IHJlc2VuZCB0aGUKPiBzZXJpZXMuCj4KPiBXb3VsZCB5b3UgcHJlZmVyIGFkZGluZyBhIGNoZWNr
ID8KCkkgY2hlY2tlZCB5b3VyIGNhbGwgc2l0ZXMgYW5kIHRoZXkgbG9vayBmaW5lLiBBbHNvLCBJ
IGRvbid0IHRoaW5rCnJldHVybmluZyBhIGNhcGFjaXR5IG9mIDAgb24gZXJyb3IgaXMgZ29pbmcg
dG8gaGVscCB1cyBtdWNoLgoKUmV2aWV3ZWQtYnk6IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGlu
LnBldGVyc2VuQG9yYWNsZS5jb20+CgotLSAKTWFydGluIEsuIFBldGVyc2VuCU9yYWNsZSBMaW51
eCBFbmdpbmVlcmluZwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVucHJvamVjdC5v
cmcKaHR0cHM6Ly9saXN0cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3hlbi1kZXZl
bA==
