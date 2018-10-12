From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 01/11] scsi: sd_zbc: Rearrange code
Date: Fri, 12 Oct 2018 09:29:33 +0200
Message-ID: <35001c63-9bde-3c73-4a18-f81145f5c424@suse.de>
References: <20181012023012.29923-1-damien.lemoal@wdc.com>
	<20181012023012.29923-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181012023012.29923-2-damien.lemoal@wdc.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

T24gMTAvMTIvMTggNDozMCBBTSwgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj4gTW92ZSB0aGUgdXJz
d3J6IGNoZWNrIG91dCBvZiBzZF96YmNfcmVhZF96b25lcygpIGFuZCBpbnRvCj4gc2RfemJjX3Jl
YWRfem9uZWRfY2hhcmFjdGVyaXN0aWNzKCkgd2hlcmUgdGhhdCB2YWx1ZSBpcyBvYnRhaW5lZCAo
cmVhZAo+IGZyb20gdGhlIGRpc2sgem9uZWQgY2hhcmFjdGVyaXN0aWNzIFZQRCBwYWdlKS4gU2lu
Y2UgdGhpcyBmdW5jdGlvbiBub3cKPiBkb2VzIG1vcmUgdGhhbiBzaW1wbHkgcmVhZGluZyB0aGUg
VlBEIHBhZ2UsIHJlbmFtZSBpdCB0bwo+IHNkX3piY19jaGVja196b25lZF9jaGFyYWN0ZXJpc3Rp
Y3MoKS4KPiBBbHNvIGZpeCB0aGUgZXJyb3IgbWVzc2FnZSBkaXNwbGF5ZWQgd2hlbiByZWFkaW5n
IHRoYXQgVlBEIHBhZ2UgZmFpbHMuCj4gCj4gU2lnbmVkLW9mZi1ieTogRGFtaWVuIExlIE1vYWwg
PGRhbWllbi5sZW1vYWxAd2RjLmNvbT4KPiBSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcg
PGhjaEBsc3QuZGU+Cj4gLS0tCj4gICBkcml2ZXJzL3Njc2kvc2RfemJjLmMgfCAzOSArKysrKysr
KysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxOSBp
bnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkKPiAKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWlu
ZWNrZSA8aGFyZUBzdXNlLmNvbT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWlu
ZWNrZQkJICAgVGVhbWxlYWQgU3RvcmFnZSAmIE5ldHdvcmtpbmcKaGFyZUBzdXNlLmRlCQkJICAg
ICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBMSU5VWCBHbWJILCBNYXhmZWxkc3Ry
LiA1LCA5MDQwOSBOw7xybmJlcmcKR0Y6IEYuIEltZW5kw7ZyZmZlciwgSi4gU21pdGhhcmQsIEou
IEd1aWxkLCBELiBVcG1hbnl1LCBHLiBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
