From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 08/11] block: Improve zone reset execution
Date: Fri, 12 Oct 2018 09:39:53 +0200
Message-ID: <b16e29dc-ed3a-f267-54a4-8c3b065ccbce@suse.de>
References: <20181012023012.29923-1-damien.lemoal@wdc.com>
	<20181012023012.29923-9-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181012023012.29923-9-damien.lemoal@wdc.com>
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
bmVlZCB0byBzeW5jaHJvbm91c2x5IGV4ZWN1dGUgYWxsIFJFUV9PUF9aT05FX1JFU0VUIEJJT3MK
PiBuZWNlc3NhcnkgdG8gcmVzZXQgYSByYW5nZSBvZiB6b25lcy4gU2ltaWxhcmx5IHRvIHdoYXQg
aXMgZG9uZSBmb3IKPiBkaXNjYXJkIEJJT3MgaW4gYmxrLWxpYi5jLCBhbGwgem9uZSByZXNldCBC
SU9zIGNhbiBiZSBjaGFpbmVkIGFuZAo+IGV4ZWN1dGVkIGFzeW5jaHJvbm91c2x5IGFuZCBhIHN5
bmNocm9ub3VzIGNhbGwgZG9uZSBvbmx5IGZvciB0aGUgbGFzdAo+IEJJTyBvZiB0aGUgY2hhaW4u
Cj4gCj4gTW9kaWZ5IGJsa2Rldl9yZXNldF96b25lcygpIHRvIG9wZXJhdGUgc2ltaWxhcmx5IHRv
Cj4gYmxrZGV2X2lzc3VlX2Rpc2NhcmQoKSB1c2luZyB0aGUgbmV4dF9iaW8oKSBoZWxwZXIgZm9y
IGNoYWluaW5nIEJJT3MuIFRvCj4gYXZvaWQgY29kZSBkdXBsaWNhdGlvbiBvZiB0aGF0IGZ1bmN0
aW9uIGluIGJsa196b25lZC5jLCByZW5hbWUKPiBuZXh0X2JpbygpIGludG8gYmxrX25leHRfYmlv
KCkgYW5kIGRlY2xhcmUgaXQgYXMgYSBibG9jayBpbnRlcm5hbAo+IGZ1bmN0aW9uIGluIGJsay5o
Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IERhbWllbiBMZSBNb2FsIDxkYW1pZW4ubGVtb2FsQHdkYy5j
b20+Cj4gUmV2aWV3ZWQtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IC0tLQo+
ICAgYmxvY2svYmxrLWxpYi5jICAgfCAxMyArKysrKystLS0tLS0tCj4gICBibG9jay9ibGstem9u
ZWQuYyB8IDI5ICsrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tCj4gICBibG9jay9ibGsuaCAg
ICAgICB8ICAyICsrCj4gICAzIGZpbGVzIGNoYW5nZWQsIDI0IGluc2VydGlvbnMoKyksIDIwIGRl
bGV0aW9ucygtKQo+IApOZWF0LgoKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBz
dXNlLmNvbT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZQkJICAgVGVh
bWxlYWQgU3RvcmFnZSAmIE5ldHdvcmtpbmcKaGFyZUBzdXNlLmRlCQkJICAgICAgICAgICAgICAg
KzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBMSU5VWCBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBO
w7xybmJlcmcKR0Y6IEYuIEltZW5kw7ZyZmZlciwgSi4gU21pdGhhcmQsIEouIEd1aWxkLCBELiBV
cG1hbnl1LCBHLiBOb3J0b24KSFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
