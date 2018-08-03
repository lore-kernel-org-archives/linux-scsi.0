From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: Re: [PATCH v2 2/9] dmapool: cleanup error messages
Date: Fri, 3 Aug 2018 13:03:17 -0400
Message-ID: <a2e9e4fd-2aab-bc7e-8dbb-db4ece8cd84f@cybernetics.com>
References: <a9f7ca9a-38d5-12e2-7d15-ab026425e85a@cybernetics.com>
	<CAHp75Ve0su_S3ZWTtUEUohrs-iPiD1uzFOHhesLrWzJPOa2LNg@mail.gmail.com>
	<7a943124-c65e-f0ed-cc5c-20b23f021505@cybernetics.com>
	<b8547f8d-ac88-3d7b-9c2d-60a2f779259e@cybernetics.com>
	<CAHp75VcoLVkp+BkFBLSqn95=3SaV-zr8cO1eSoQsrzZtJZESNQ@mail.gmail.com>
	<20180803162212.GA4718@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180803162212.GA4718-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
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
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gMDgvMDMvMjAxOCAxMjoyMiBQTSwgTWF0dGhldyBXaWxjb3ggd3JvdGU6Cj4gT24gRnJpLCBB
dWcgMDMsIDIwMTggYXQgMDY6NTk6MjBQTSArMDMwMCwgQW5keSBTaGV2Y2hlbmtvIHdyb3RlOgo+
Pj4+PiBJJ20gcHJldHR5IHN1cmUgdGhpcyB3YXMgY3JlYXRlZCBpbiBhbiBvcmRlciB0byBhdm9p
ZCBiYWQgbG9va2luZyAoYW5kCj4+Pj4+IGluIHNvbWUgY2FzZXMgZnJpZ2h0ZW5pbmcpICJOVUxM
IGRldmljZSAqIiBwYXJ0Lgo+PiBKRllJOiBnaXQgbG9nIC0tbm8tbWVyZ2VzIC0tZ3JlcCAnTlVM
TCBkZXZpY2UgXConCj4gSSB0aGluayB0aG9zZSBjb21taXRzIGFjdHVhbGx5IGFyZ3VlIGluIGZh
dm91ciBvZiBUb255J3MgcGF0Y2ggdG8gcmVtb3ZlCj4gdGhlIHNwZWNpYWwgY2FzaW5nLiAgSXMg
aXQgcmVhbGx5IHVzZWZ1bCB0byBjcmVhdGUgZG1hIHBvb2xzIHdpdGggYSBOVUxMCj4gZGV2aWNl
Pwo+Cj4KZG1hX2FsbG9jX2NvaGVyZW50KCkgZG9lcyBhcHBlYXIgdG8gc3VwcG9ydCBhIE5VTEwg
ZGV2LCBzbyBpdCBtaWdodCBtYWtlCnNlbnNlIGluIHRoZW9yeS7CoCBCdXQgSSBjYW4ndCBmaW5k
IGFueSBpbi10cmVlIGNhbGxlcnMgdGhhdCBhY3R1YWxseQpwYXNzIGEgTlVMTCBkZXYgdG8gZG1h
X3Bvb2xfY3JlYXRlKCkuwqAgU28gZm9yIG9uZSBvZiB0aGUgZHJlYWRlZCAoTlVMTApkZXZpY2Ug
KikgbWVzc2FnZXMgdG8gc2hvdyB1cCwgaXQgd291bGQgdGFrZSBib3RoIGEgbmV3IGNhbGxlciB0
aGF0CnBhc3NlcyBhIE5VTEwgZGV2IHRvIGRtYV9wb29sX2NyZWF0ZSgpIGFuZCBhIGJ1ZyB0byBj
YXVzZSB0aGUgbWVzc2FnZSB0bwpiZSBwcmludGVkLsKgIElzIHRoYXQgd29ydGggdGhlIHNwZWNp
YWwgY2FzaW5nPwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KaW9tbXUgbWFpbGluZyBsaXN0CmlvbW11QGxpc3RzLmxpbnV4LWZvdW5kYXRpb24ub3JnCmh0
dHBzOi8vbGlzdHMubGludXhmb3VuZGF0aW9uLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2lvbW11
