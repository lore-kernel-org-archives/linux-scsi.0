From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 05/11] block: Limit allocation of zone
 descriptors for report zones
Date: Fri, 12 Oct 2018 09:36:45 +0200
Message-ID: <34452bd8-5649-4f7f-35f6-f370811dc68c@suse.de>
References: <20181012023012.29923-1-damien.lemoal@wdc.com>
	<20181012023012.29923-6-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181012023012.29923-6-damien.lemoal@wdc.com>
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

T24gMTAvMTIvMTggNDozMCBBTSwgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj4gVGhlcmUgaXMgbm8g
cG9pbnQgaW4gYWxsb2NhdGluZyBtb3JlIHpvbmUgZGVzY3JpcHRvcnMgdGhhbiB0aGUgbnVtYmVy
IG9mCj4gem9uZXMgYSBibG9jayBkZXZpY2UgaGFzIGZvciBkb2luZyBhIHpvbmUgcmVwb3J0LiBB
dm9pZCBkb2luZyB0aGF0IGluCj4gYmxrZGV2X3JlcG9ydF96b25lc19pb2N0bCgpIGJ5IGxpbWl0
aW5nIHRoZSBudW1iZXIgb2Ygem9uZSBkZWNyaXB0b3JzCj4gYWxsb2NhdGVkIGludGVybmFsbHkg
dG8gcHJvY2VzcyB0aGUgdXNlciByZXF1ZXN0Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IERhbWllbiBM
ZSBNb2FsIDxkYW1pZW4ubGVtb2FsQHdkYy5jb20+Cj4gUmV2aWV3ZWQtYnk6IENocmlzdG9waCBI
ZWxsd2lnIDxoY2hAbHN0LmRlPgo+IC0tLQo+ICAgYmxvY2svYmxrLXpvbmVkLmMgfCAzICstLQo+
ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9ucygtKQo+IApSZXZp
ZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuY29tPgoKQ2hlZXJzLAoKSGFubmVz
Ci0tIApEci4gSGFubmVzIFJlaW5lY2tlCQkgICBUZWFtbGVhZCBTdG9yYWdlICYgTmV0d29ya2lu
ZwpoYXJlQHN1c2UuZGUJCQkgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIExJ
TlVYIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpHRjogRi4gSW1lbmTDtnJm
ZmVyLCBKLiBTbWl0aGFyZCwgSi4gR3VpbGQsIEQuIFVwbWFueXUsIEcuIE5vcnRvbgpIUkIgMjEy
ODQgKEFHIE7DvHJuYmVyZykKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRo
YXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
