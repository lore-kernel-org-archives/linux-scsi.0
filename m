From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: Re: [PATCH v3 08/10] dmapool: improve accuracy of debug statistics
Date: Wed, 8 Aug 2018 09:18:48 -0400
Message-ID: <99f91604-f7ea-aaaa-fc15-3c1264603d0b@cybernetics.com>
References: <cbe2fb30-54b3-663e-4e30-448353723b8f@cybernetics.com>
	<CAHp75Vcnf8m0zW+8Y8=fTE+F_bDjmaQpR0s2qiTdkOzqe2+fBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAHp75Vcnf8m0zW+8Y8=fTE+F_bDjmaQpR0s2qiTdkOzqe2+fBA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gMDgvMDgvMjAxOCAwNTo1NCBBTSwgQW5keSBTaGV2Y2hlbmtvIHdyb3RlOgo+IE9uIFR1ZSwg
QXVnIDcsIDIwMTggYXQgNzo0OSBQTSwgVG9ueSBCYXR0ZXJzYnkgPHRvbnliQGN5YmVybmV0aWNz
LmNvbT4gd3JvdGU6Cj4+IFRoZSAidG90YWwgbnVtYmVyIG9mIGJsb2NrcyBpbiBwb29sIiBkZWJ1
ZyBzdGF0aXN0aWMgY3VycmVudGx5IGRvZXMgbm90Cj4+IHRha2UgdGhlIGJvdW5kYXJ5IHZhbHVl
IGludG8gYWNjb3VudCwgc28gaXQgZGl2ZXJnZXMgZnJvbSB0aGUgInRvdGFsCj4+IG51bWJlciBv
ZiBibG9ja3MgaW4gdXNlIiBzdGF0aXN0aWMgd2hlbiBhIGJvdW5kYXJ5IGlzIGluIGVmZmVjdC4g
IEFkZCBhCj4+IGNhbGN1bGF0aW9uIGZvciB0aGUgbnVtYmVyIG9mIGJsb2NrcyBwZXIgYWxsb2Nh
dGlvbiB0aGF0IHRha2VzIHRoZQo+PiBib3VuZGFyeSBpbnRvIGFjY291bnQsIGFuZCB1c2UgaXQg
dG8gcmVwbGFjZSB0aGUgaW5hY2N1cmF0ZSBjYWxjdWxhdGlvbi4KPgo+PiArICAgICAgIHJldHZh
bC0+Ymxrc19wZXJfYWxsb2MgPQo+PiArICAgICAgICAgICAgICAgKGFsbG9jYXRpb24gLyBib3Vu
ZGFyeSkgKiAoYm91bmRhcnkgLyBzaXplKSArCj4+ICsgICAgICAgICAgICAgICAoYWxsb2NhdGlv
biAlIGJvdW5kYXJ5KSAvIHNpemU7Cj4gSWYgYm91bmRhcnkgaXMgZ3VhcmFudGVlZCB0byBiZSBw
b3dlciBvZiAyLCB0aGlzIGNhbiBhdm9pZCBjb3N0Cj4gZGl2aXNpb25zICh0aG91Z2ggaXQncyBh
IHNsb3cgcGF0aCBhbnl3YXkpLgo+CkF0IHRoaXMgcG9pbnQgaW4gdGhlIGZ1bmN0aW9uLCBib3Vu
ZGFyeSBpcyBndWFyYW50ZWVkIHRvIGJlIGVpdGhlciBhCnBvd2VyIG9mIDIgb3IgZXF1YWwgdG8g
YWxsb2NhdGlvbiwgd2hpY2ggbWlnaHQgbm90IGJlIGEgcG93ZXIgb2YgMi7CoCBOb3QKd29ydGgg
c3BlY2lhbC1jYXNpbmcgYSBzbG93IHBhdGguCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwppb21tdSBtYWlsaW5nIGxpc3QKaW9tbXVAbGlzdHMubGludXgt
Zm91bmRhdGlvbi5vcmcKaHR0cHM6Ly9saXN0cy5saW51eGZvdW5kYXRpb24ub3JnL21haWxtYW4v
bGlzdGluZm8vaW9tbXU=
