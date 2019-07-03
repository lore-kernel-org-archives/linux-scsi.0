From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V3 1/9] block: add a helper function to read
 nr_setcs
Date: Wed, 3 Jul 2019 08:03:27 -0700
Message-ID: <26917678-fd82-b6c8-761e-220bc7d3b179@acm.org>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
 <20190702174236.3332-2-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <20190702174236.3332-2-chaitanya.kulkarni@wdc.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, linux-block@vger.kernel.org
Cc: damien.lemoal@wdc.com, linux-btrace@vger.kernel.org, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, yuchao0@huawei.com, colyli@suse.de, linux-bcache@vger.kernel.org, jaegeuk@kernel.org, xen-devel@lists.xenproject.org, kent.overstreet@gmail.com, roger.pau@citrix.com
List-Id: linux-scsi@vger.kernel.org

T24gNy8yLzE5IDEwOjQyIEFNLCBDaGFpdGFueWEgS3Vsa2Fybmkgd3JvdGU6Cj4gKy8qIEhlbHBl
ciBmdW5jdGlvbiB0byByZWFkIHRoZSBiZGV2LT5iZF9wYXJ0LT5ucl9zZWN0cyAqLwo+ICtzdGF0
aWMgaW5saW5lIHNlY3Rvcl90IGJkZXZfbnJfc2VjdHMoc3RydWN0IGJsb2NrX2RldmljZSAqYmRl
dikKPiArewo+ICsJcmV0dXJuIHBhcnRfbnJfc2VjdHNfcmVhZChiZGV2LT5iZF9wYXJ0KTsKPiAr
fQoKSXMgdGhlIGNvbW1lbnQgYWJvdmUgYmRldl9ucl9zZWN0cygpIHJlYWxseSB1c2VmdWwgb3Ig
c2hvdWxkIGl0IGJlIGxlZnQgb3V0PwoKVGhhbmtzLAoKQmFydC4KCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVu
LWRldmVsQGxpc3RzLnhlbnByb2plY3Qub3JnCmh0dHBzOi8vbGlzdHMueGVucHJvamVjdC5vcmcv
bWFpbG1hbi9saXN0aW5mby94ZW4tZGV2ZWw=
