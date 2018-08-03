From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: Re: [PATCH v2 6/9] dmapool: improve scalability of dma_pool_free
Date: Fri, 3 Aug 2018 16:05:35 -0400
Message-ID: <fee77a48-a86b-75eb-7648-6e6e13c3e8e8@cybernetics.com>
References: <eabf88b3-c40f-9973-efed-30af46f42c8d@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <eabf88b3-c40f-9973-efed-30af46f42c8d-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
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
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Rm9yIHYzIG9mIHRoZSBwYXRjaHNldCwgSSB3YXMgYWxzbyBjb25zaWRlcmluZyB0byBhZGQgYSBu
b3RlIHRvIHRoZQprZXJuZWwtZG9jIGNvbW1lbnRzIGZvciBkbWFfcG9vbF9jcmVhdGUoKSB0byB1
c2UgZG1hX2FsbG9jX2NvaGVyZW50KCkKZGlyZWN0bHkgaW5zdGVhZCBvZiBhIGRtYSBwb29sIGlm
IHRoZSBkcml2ZXIgaW50ZW5kcyB0byBhbGxvdyB1c2Vyc3BhY2UKdG8gbW1hcCgpIHRoZSByZXR1
cm5lZCBwYWdlcywgZHVlIHRvIHRoZSBuZXcgdXNlIG9mIHRoZSBfbWFwY291bnQgdW5pb24KaW4g
c3RydWN0IHBhZ2UuwqAgV291bGQgeW91IGNvbnNpZGVyIHRoYXQgdXNlZnVsIGluZm9ybWF0aW9u
IG9yIHBvaW50bGVzcwp0cml2aWE/Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmlvbW11IG1haWxpbmcgbGlzdAppb21tdUBsaXN0cy5saW51eC1mb3VuZGF0
aW9uLm9yZwpodHRwczovL2xpc3RzLmxpbnV4Zm91bmRhdGlvbi5vcmcvbWFpbG1hbi9saXN0aW5m
by9pb21tdQ==
