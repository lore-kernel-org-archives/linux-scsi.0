From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: Re: [PATCH v2 2/9] dmapool: cleanup error messages
Date: Fri, 3 Aug 2018 17:18:25 -0400
Message-ID: <4ed8f094-ae62-65c1-ec46-0d39b594abba@cybernetics.com>
References: <a9f7ca9a-38d5-12e2-7d15-ab026425e85a@cybernetics.com>
	<CAHp75Ve0su_S3ZWTtUEUohrs-iPiD1uzFOHhesLrWzJPOa2LNg@mail.gmail.com>
	<7a943124-c65e-f0ed-cc5c-20b23f021505@cybernetics.com>
	<b8547f8d-ac88-3d7b-9c2d-60a2f779259e@cybernetics.com>
	<CAHp75VcoLVkp+BkFBLSqn95=3SaV-zr8cO1eSoQsrzZtJZESNQ@mail.gmail.com>
	<20180803162212.GA4718@bombadil.infradead.org>
	<a2e9e4fd-2aab-bc7e-8dbb-db4ece8cd84f@cybernetics.com>
	<f0762902-8f28-82eb-b871-337c2da290cf@cybernetics.com>
	<20180803210745.GB9329@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180803210745.GB9329-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
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
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gMDgvMDMvMjAxOCAwNTowNyBQTSwgTWF0dGhldyBXaWxjb3ggd3JvdGU6Cj4gT24gRnJpLCBB
dWcgMDMsIDIwMTggYXQgMDI6NDM6MDdQTSAtMDQwMCwgVG9ueSBCYXR0ZXJzYnkgd3JvdGU6Cj4+
IE91dCBvZiBjdXJpb3NpdHksIEkganVzdCB0cmllZCB0byBjcmVhdGUgYSBkbWFwb29sIHdpdGgg
YSBOVUxMIGRldiBhbmQKPj4gaXQgY3Jhc2hlZCBvbiB0aGlzOgo+Pgo+PiBzdGF0aWMgaW5saW5l
IGludCBkZXZfdG9fbm9kZShzdHJ1Y3QgZGV2aWNlICpkZXYpCj4+IHsKPj4gCXJldHVybiBkZXYt
Pm51bWFfbm9kZTsKPj4gfQo+Pgo+PiBzdHJ1Y3QgZG1hX3Bvb2wgKmRtYV9wb29sX2NyZWF0ZShj
b25zdCBjaGFyICpuYW1lLCBzdHJ1Y3QgZGV2aWNlICpkZXYsCj4+IAkJCQkgc2l6ZV90IHNpemUs
IHNpemVfdCBhbGlnbiwgc2l6ZV90IGJvdW5kYXJ5KQo+PiB7Cj4+IAkuLi4KPj4gCXJldHZhbCA9
IGttYWxsb2Nfbm9kZShzaXplb2YoKnJldHZhbCksIEdGUF9LRVJORUwsIGRldl90b19ub2RlKGRl
dikpOwo+PiAJLi4uCj4+IH0KPj4KPj4gU28gZWl0aGVyIGl0IG5lZWRzIG1vcmUgc3BlY2lhbCBj
YXNlcyBmb3Igc3VwcG9ydGluZyBhIE5VTEwgZGV2LCBvciB0aGUKPj4gc3BlY2lhbCBjYXNlcyBj
YW4gYmUgcmVtb3ZlZCBzaW5jZSBubyBvbmUgZG9lcyB0aGF0IGFueXdheS4KPiBBY3R1YWxseSwg
aXQncyB3b3JzZS4gIGRldl90b19ub2RlKCkgd29ya3Mgd2l0aCBhIE5VTEwgZGV2IC4uLiB1bmxl
c3MKPiBDT05GSUdfTlVNQSBpcyBzZXQuICBTbyB3ZSdyZSBsZWF2aW5nIGEgdGltZWJvbWIgYnkg
cHJldGVuZGluZyB0bwo+IGFsbG93IGl0LiAgTGV0J3MganVzdCAnaWYgKCFkZXYpIHJldHVybiBO
VUxMOycgZWFybHkgaW4gY3JlYXRlLgo+Cj4KTG9va2luZyBmdXJ0aGVyIGRvd24gaXQgZG9lcyBz
dHVmZiB3aXRoIGRldi0+ZG1hX3Bvb2xzIHVuY29uZGl0aW9uYWxseQp0aGF0IGRvZXNuJ3QgZGVw
ZW5kIG9uIHRoZSBjb25maWcuwqAgU28gaXQgd291bGQgYmxvdyB1cCBvbiBub24tTlVNQQphbHNv
LsKgIFNvIG5vIHRpbWVib21iLCBqdXN0IGFuIGltbWVkaWF0ZSBrYWJvb20uCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwppb21tdSBtYWlsaW5nIGxpc3QK
aW9tbXVAbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmcKaHR0cHM6Ly9saXN0cy5saW51eGZvdW5k
YXRpb24ub3JnL21haWxtYW4vbGlzdGluZm8vaW9tbXU=
