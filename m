From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: Re: [PATCH v2 8/9] dmapool: reduce footprint in struct page
Date: Fri, 3 Aug 2018 10:04:44 -0400
Message-ID: <37abe59f-70cb-d125-b87f-49f63de6ece7@cybernetics.com>
References: <0ccfd31b-0a3f-9ae8-85c8-e176cd5453a9@cybernetics.com>
	<20180802235626.GA5773@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180802235626.GA5773-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
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
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gMDgvMDIvMjAxOCAwNzo1NiBQTSwgTWF0dGhldyBXaWxjb3ggd3JvdGU6Cj4KPj4gT25lIG9m
IHRoZSBuaWNlIHRoaW5ncyBhYm91dCB0aGlzIGlzIHRoYXQgZG1hX3Bvb2xfZnJlZSgpIGNhbiBk
byBzb21lCj4+IGFkZGl0aW9uYWwgc2FuaXR5IGNoZWNrczoKPj4gKikgQ2hlY2sgdGhhdCB0aGUg
b2Zmc2V0IG9mIHRoZSBwYXNzZWQtaW4gYWRkcmVzcyBjb3JyZXNwb25kcyB0byBhIHZhbGlkCj4+
IGJsb2NrIG9mZnNldC4KPiBDYW4ndCB3ZSBkbyB0aGF0IGFscmVhZHk/ICBTdWJ0cmFjdCB0aGUg
YmFzZSBhZGRyZXNzIG9mIHRoZSBwYWdlIGZyb20KPiB0aGUgcGFzc2VkLWluIHZhZGRyIGFuZCBj
aGVjayBpdCdzIGEgbXVsdGlwbGUgb2YgcG9vbC0+c2l6ZT8KVGhlIGdhcHMgY2F1c2VkIGJ5ICdi
b3VuZGFyeScgbWFrZSBpdCBhIGxvdCBtb3JlIGNvbXBsaWNhdGVkIHRoYW4gdGhhdC7CoApTZWUg
cG9vbF9vZmZzZXRfdG9fYmxrX2lkeCgpLsKgIFlvdXIgc3VnZ2VzdGlvbiBpcyB0aGUgZmFzdC1w
YXRoIHRvcCBwYXJ0Cm9mIHBvb2xfb2Zmc2V0X3RvX2Jsa19pZHgoKSB3aGVyZSBkbWFfcG9vbF9j
cmVhdGUoKSBzZXQKYmxrc19wZXJfYm91bmRhcnkgdG8gMCB0byBnZXQgYSBzcGVlZCBib29zdC7C
oCBUaGUgdWdseSBzbG93IGNhc2UgdG8gdGFrZQp0aGUgYm91bmRhcnkgaW50byBhY2NvdW50IGlz
IHRoZSBib3R0b20gcGFydCBvZiBwb29sX29mZnNldF90b19ibGtfaWR4KCkuCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmlvbW11IG1haWxpbmcgbGlzdApp
b21tdUBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZwpodHRwczovL2xpc3RzLmxpbnV4Zm91bmRh
dGlvbi5vcmcvbWFpbG1hbi9saXN0aW5mby9pb21tdQ==
