From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 04/11] block: Introduce blkdev_nr_zones()
	helper
Date: Fri, 12 Oct 2018 09:36:11 +0200
Message-ID: <88ebc7eb-f5f8-6966-7820-3c1a5b36b72c@suse.de>
References: <20181012023012.29923-1-damien.lemoal@wdc.com>
	<20181012023012.29923-5-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181012023012.29923-5-damien.lemoal@wdc.com>
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

T24gMTAvMTIvMTggNDozMCBBTSwgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj4gSW50cm9kdWNlIHRo
ZSBibGtkZXZfbnJfem9uZXMoKSBoZWxwZXIgZnVuY3Rpb24gdG8gZ2V0IHRoZSB0b3RhbAo+IG51
bWJlciBvZiB6b25lcyBvZiBhIHpvbmVkIGJsb2NrIGRldmljZS4gVGhpcyBudW1iZXIgaXMgYWx3
YXlzIDAgZm9yIGEKPiByZWd1bGFyIGJsb2NrIGRldmljZSAocS0+bGltaXRzLnpvbmVkID09IEJM
S19aT05FRF9OT05FIGNhc2UpLgo+IAo+IFJlcGxhY2UgaGFyZC1jb2RlZCBudW1iZXIgb2Ygem9u
ZXMgY2FsY3VsYXRpb24gaW4gZG16X2dldF96b25lZF9kZXZpY2UoKQo+IHdpdGggYSBjYWxsIHRv
IHRoaXMgaGVscGVyLgo+IAo+IFNpZ25lZC1vZmYtYnk6IERhbWllbiBMZSBNb2FsIDxkYW1pZW4u
bGVtb2FsQHdkYy5jb20+Cj4gUmV2aWV3ZWQtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0
LmRlPgo+IC0tLQo+ICAgYmxvY2svYmxrLXpvbmVkLmMgICAgICAgICAgICB8IDI3ICsrKysrKysr
KysrKysrKysrKysrKysrKysrKwo+ICAgZHJpdmVycy9tZC9kbS16b25lZC10YXJnZXQuYyB8ICAz
ICstLQo+ICAgaW5jbHVkZS9saW51eC9ibGtkZXYuaCAgICAgICB8ICA1ICsrKysrCj4gICAzIGZp
bGVzIGNoYW5nZWQsIDMzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4gClJldmlld2Vk
LWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5jb20+CgpDaGVlcnMsCgpIYW5uZXMKLS0g
CkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgIFRlYW1sZWFkIFN0b3JhZ2UgJiBOZXR3b3JraW5nCmhh
cmVAc3VzZS5kZQkJCSAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgTElOVVgg
R21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkdGOiBGLiBJbWVuZMO2cmZmZXIs
IEouIFNtaXRoYXJkLCBKLiBHdWlsZCwgRC4gVXBtYW55dSwgRy4gTm9ydG9uCkhSQiAyMTI4NCAo
QUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5j
b20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
