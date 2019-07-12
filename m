From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH V4 1/9] block: add a helper function to read
 nr_setcs
Date: Fri, 12 Jul 2019 16:09:56 +0000
Message-ID: <BYAPR04MB5749AF90A9E9C81B4A6857F386F20@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
 <20190708184711.2984-2-chaitanya.kulkarni@wdc.com>
 <yq18st457yb.fsf@oracle.com>
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
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-btrace@vger.kernel.org" <linux-btrace@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "yuchao0@huawei.com" <yuchao0@huawei.com>, "colyli@suse.de" <colyli@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>
List-Id: linux-scsi@vger.kernel.org

T24gNy8xMS8xOSA2OjU5IFBNLCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3JvdGU6Cj4gSGkgQ2hhaXRh
bnlhLAo+Cj4+ICtzdGF0aWMgaW5saW5lIHNlY3Rvcl90IGJkZXZfbnJfc2VjdHMoc3RydWN0IGJs
b2NrX2RldmljZSAqYmRldikKPj4gK3sKPj4gKwlyZXR1cm4gcGFydF9ucl9zZWN0c19yZWFkKGJk
ZXYtPmJkX3BhcnQpOwo+PiArfQo+IENhbiBiZGV2IGVuZCB1cCBiZWluZyBOVUxMIGluIGFueSBv
ZiB0aGUgY2FsbCBzaXRlcz8KPgo+IE90aGVyd2lzZSBubyBvYmplY3Rpb25zLgo+ClRoYW5rcyBm
b3IgbWVudGlvbmluZyB0aGF0LiBJbml0aWFsIHZlcnNpb24gd2hpY2ggd2FzIG5vdCBwb3N0ZWQg
aGFkCnRoYXQgY2hlY2suCgpUaGlzIHNlcmllcyBqdXN0IHJlcGxhY2VzIHRoZSBleGlzdGluZyBh
Y2Nlc3NlcyB3aXRob3V0IGNoYW5naW5nIGFueXRoaW5nLgoKU28gaWYgYW55IG9mIHRoZSBleGl0
aW5nIGNvZGUgaGFzIHRoYXQgYnVnIHRoZW4gaXQgd2lsbCBibG93IHVwIG5pY2VseS4KCkZvciBm
dXR1cmUgY2FsbGVycyBJIGRvbid0IG1pbmQgYWRkaW5nIGEgbmV3IGNoZWNrIGFuZCByZXNlbmQg
dGhlIHNlcmllcy4KCldvdWxkIHlvdSBwcmVmZXIgYWRkaW5nIGEgY2hlY2sgID8KCgoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxp
bmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVucHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0cy54ZW5w
cm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3hlbi1kZXZlbA==
