From: Asias He <asias.hejun@gmail.com>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass of
	disks naming
Date: Sat, 31 Mar 2012 11:03:47 +0800
Message-ID: <CAFO3S41ag8wih8941qmpUGM=JbY_MsF28pNom-SRxW3M67_k3A@mail.gmail.com>
References: <4F7581D4.4040301@cn.fujitsu.com> <4F7582B0.5010609@cn.fujitsu.com>
	<CAFO3S427vWXHBDaRmfwqZrGZ2Y8RPUn7CQswQou9EGMh43jU8Q@mail.gmail.com>
	<4F765A72.6090006@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <4F765A72.6090006@cn.fujitsu.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, KVM <kvm@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, LKML <linux-kernel@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gU2F0LCBNYXIgMzEsIDIwMTIgYXQgOToxNCBBTSwgUmVuIE1pbmd4aW4gPHJlbm14QGNuLmZ1
aml0c3UuY29tPiB3cm90ZToKPiDCoEhpLCBIZToKPgo+Cj4gT24gMDMvMzAvMjAxMiAwNzoyMiBQ
TSwgQXNpYXMgSGUgd3JvdGU6Cj4+Cj4+IE9uIEZyaSwgTWFyIDMwLCAyMDEyIGF0IDU6NTMgUE0s
IFJlbiBNaW5neGluPHJlbm14QGNuLmZ1aml0c3UuY29tPiDCoHdyb3RlOgo+Pj4KPj4+IMKgVGhl
IGN1cnJlbnQgdmlydGJsaydzIG5hbWluZyBhbGdvcml0aG0gb25seSBzdXBwb3J0cyAyNjMgwqBk
aXNrcy4KPj4+IElmIHRoZXJlIGFyZSBtYXNzIG9mIHZpcnRibGtzKGV4Y2VlZGluZyAyNjMpLCB0
aGVyZSB3aWxsIGJlIGRpc2tzCj4+PiB3aXRoIHRoZSBzYW1lIG5hbWUuCj4+Cj4+IFRoaXMgZml4
IGlzIHByZXR0eSBuaWNlLiBIb3dldmVyLCBjdXJyZW50IHZpcnRibGsncyBuYW1pbmcgc3RpbGwK
Pj4gc3VwcG9ydHMgdXAgdG8gMTgyNzggZGlza3MsIG5vPwo+PiAoIGluZGV4IDAgwqAtPiDCoHZk
YSwgaW5kZXggMTgyNzcgLT4gwqB2ZHp6eiApLgo+Cj4KPiBTb3JyeSwgSSBpbnRlbmRlZCB0byB0
eXBlIDI2XjMrICgyNl4yKzI2KS4uLgo+IEl0IG1heSBzdGlsbCBiZSBhIHJlc3RyaWN0aW9uIHdo
aWNoIHNob3VsZCBiZSBpbXByb3ZlZCB0aG91Z2guCgpPSy4KCi0tIApBc2lhcyBIZQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpWaXJ0dWFsaXphdGlvbiBt
YWlsaW5nIGxpc3QKVmlydHVhbGl6YXRpb25AbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmcKaHR0
cHM6Ly9saXN0cy5saW51eGZvdW5kYXRpb24ub3JnL21haWxtYW4vbGlzdGluZm8vdmlydHVhbGl6
YXRpb24=
