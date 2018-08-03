From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: Re: [PATCH v2 2/9] dmapool: cleanup error messages
Date: Fri, 3 Aug 2018 12:10:19 -0400
Message-ID: <f5e210ae-e932-4b3a-6774-082e8ddce79e@cybernetics.com>
References: <a9f7ca9a-38d5-12e2-7d15-ab026425e85a@cybernetics.com>
	<CAHp75Ve0su_S3ZWTtUEUohrs-iPiD1uzFOHhesLrWzJPOa2LNg@mail.gmail.com>
	<7a943124-c65e-f0ed-cc5c-20b23f021505@cybernetics.com>
	<b8547f8d-ac88-3d7b-9c2d-60a2f779259e@cybernetics.com>
	<CAHp75VcoLVkp+BkFBLSqn95=3SaV-zr8cO1eSoQsrzZtJZESNQ@mail.gmail.com>
	<CAHp75VdkFfND+Mr+L96kkGEF7K49Fr2HWezQQ3DBOQvxTLjBcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAHp75VdkFfND+Mr+L96kkGEF7K49Fr2HWezQQ3DBOQvxTLjBcw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gMDgvMDMvMjAxOCAxMjowMSBQTSwgQW5keSBTaGV2Y2hlbmtvIHdyb3RlOgo+IE9uIEZyaSwg
QXVnIDMsIDIwMTggYXQgNjo1OSBQTSwgQW5keSBTaGV2Y2hlbmtvCj4gPGFuZHkuc2hldmNoZW5r
b0BnbWFpbC5jb20+IHdyb3RlOgo+PiBPbiBGcmksIEF1ZyAzLCAyMDE4IGF0IDY6MTcgUE0sIFRv
bnkgQmF0dGVyc2J5IDx0b255YkBjeWJlcm5ldGljcy5jb20+IHdyb3RlOgo+Pj4gQnV0IHRoZW4g
SSBkZWNpZGVkIHRvIHNpbXBsaWZ5IGl0IHRvIGp1c3QgdXNlIGRldl9lcnIoKS4gIEkgc3RpbGwg
aGF2ZQo+Pj4gdGhlIG9sZCB2ZXJzaW9uLiAgV2hlbiBJIHN1Ym1pdCB2MyBvZiB0aGUgcGF0Y2hz
ZXQsIHdoaWNoIHdvdWxkIHlvdSBwcmVmZXI/Cj4+IEpGWUk6IGdpdCBsb2cgLS1uby1tZXJnZXMg
LS1ncmVwICdOVUxMIGRldmljZSBcKicKPiBFeGFtcGxlOgo+Cj4gY29tbWl0IGI0YmE5N2U3Njc2
M2M0ZTU4MmUzYWYxMDc5ZTIyMGU5M2IxYjBkNzYKPiBBdXRob3I6IENocmlzIFdpbHNvbiA8Y2hy
aXNAY2hyaXMtd2lsc29uLmNvLnVrPgo+IERhdGU6ICAgRnJpIEF1ZyAxOSAwODozNzo1MCAyMDE2
ICswMTAwCj4KPiAgICBkcm06IEF2b2lkIGNhbGxpbmcgZGV2X3ByaW50ayguZGV2ID0gTlVMTCkK
PgoKUG9pbnQgdGFrZW4uwqAgSSdsbCBnbyB3aXRoIHBvb2xfZXJyKCkgb24gdGhlIG5leHQgcm91
bmQuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmlvbW11
IG1haWxpbmcgbGlzdAppb21tdUBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZwpodHRwczovL2xp
c3RzLmxpbnV4Zm91bmRhdGlvbi5vcmcvbWFpbG1hbi9saXN0aW5mby9pb21tdQ==
