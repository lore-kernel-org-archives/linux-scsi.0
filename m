From: Bu Tao <butao@huawei.com>
Subject: Re: [PATCH v2 2/5] dt-bindings: scsi: ufs: add document for hi3660-ufs
Date: Thu, 22 Jun 2017 19:58:45 +0800
Message-ID: <24438c4d-21c8-6302-acd4-4f0e223232ce@huawei.com>
References: <20170616065119.10704-1-butao@hisilicon.com>
 <20170616065119.10704-3-butao@hisilicon.com>
 <CAK8P3a2aPorzpUzwL=dkUkYNCGkhQMDPOkKRW1-=Hf=yCdvTsQ@mail.gmail.com>
 <0f79aeea-53e3-6bea-ffa6-0e057f2ff83b@huawei.com>
 <CAK8P3a2z7VbPb95Ltj=Duh1v_Yqxedb_g=ADNPWOrpEz1dCTuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAK8P3a2z7VbPb95Ltj=Duh1v_Yqxedb_g=ADNPWOrpEz1dCTuw@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Eric Anholt <eric@anholt.net>, Krzysztof Kozlowski <krzk@kernel.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>, Wei Xu <xuwei5@hisilicon.com>, Thierry Reding <treding@nvidia.com>, devicetree@vger.kernel.org, suzhuangluan@hisilicon.com, kongfei@hisilicon.com, Rob Herring <robh+dt@kernel.org>, Gregory CLEMENT <gregory.clement@free-electrons.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Thomas Petazzoni <thomas.petazzoni@free-electrons.com>, Guodong Xu <guodong.xu@linaro.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Riku Voipio <riku.voipio@linaro.org>Linux
List-Id: linux-scsi@vger.kernel.org

CgrlnKggMjAxNy82LzIyIDE5OjUxLCBBcm5kIEJlcmdtYW5uIOWGmemBkzoKPiBPbiBUaHUsIEp1
biAyMiwgMjAxNyBhdCAxOjQ0IFBNLCBCdSBUYW8gPGJ1dGFvQGh1YXdlaS5jb20+IHdyb3RlOgo+
PiDlnKggMjAxNy82LzE3IDU6NTEsIEFybmQgQmVyZ21hbm4g5YaZ6YGTOgo+Pj4gT24gRnJpLCBK
dW4gMTYsIDIwMTcgYXQgODo1MSBBTSwgQnUgVGFvIDxidXRhb0BoaXNpbGljb24uY29tPiB3cm90
ZToKPj4+PiArT3B0aW9uYWwgcHJvcGVydGllcyBmb3IgYm9hcmQgZGV2aWNlOgo+Pj4+ICstIHVm
cy1oaTM2NjAtdXNlLXJhdGUtQiAgICAgICAgICAgICAgICA6IHNwZWNpZmllcyBVRlMgcmF0ZS1C
Cj4+Pj4gKy0gdWZzLWhpMzY2MC1icm9rZW4tZmFzdGF1dG8gICA6IHNwZWNpZmllcyBubyBmYXN0
YXV0bwo+Pj4+ICstIHVmcy1oaTM2NjAtdXNlLUhTLUdFQVIzICAgICAgOiBzcGVjaWZpZXMgVUZT
IEhTLUdFQVIzCj4+Pj4gKy0gdWZzLWhpMzY2MC11c2UtSFMtR0VBUjIgICAgICA6IHNwZWNpZmll
cyBVRlMgSFMtR0VBUjIKPj4+PiArLSB1ZnMtaGkzNjYwLXVzZS1IUy1HRUFSMSAgICAgIDogc3Bl
Y2lmaWVzIFVGUyBIUy1HRUFSMQo+Pj4+ICstIHVmcy1oaTM2NjAtYnJva2VuLWNsay1nYXRlLWJ5
cGFzcyAgICA6IHNwZWNpZmllcyBubyBjbGstZ2F0ZQo+Pj4+ICstIHVmcy1oaTM2NjAtdXNlLW9u
ZS1saW5lICAgICAgOiBzcGVjaWZpZXMgVUZTIHVzZSBvbmUgbGluZSB3b3JrCj4+Pj4gKy0gcmVz
ZXQtZ3BpbyAgICAgICAgICAgICAgICAgICA6IHNwZWNpZmllcyB0byByZXNldCBkZXZpY2VzCj4+
Pgo+Pj4KPj4+IFNvbWUgb2YgdGhlc2Ugc291bmQgcmF0aGVyIGdlbmVyaWMgYW5kIG1pZ2h0IGFw
cGx5IHRvIFVGUyBpbXBsZW1lbnRhdGlvbnMKPj4+IG90aGVyIHRoYW4gaGkzNjYwLCBzbyBJJ2Qg
c3VnZ2VzdCBhZGRpbmcgdGhlbSB0byB0aGUgYmFzZSB1ZnMgYmluZGluZyB3aXRoCj4+PiBhIGdl
bmVyaWMgbmFtZSBpbnN0ZWFkLgo+Pj4KPj4+IEFueSBEVCBwcm9wZXJ0aWVzIHRoYXQgbWlnaHQg
YmUgdXNlZnVsIGFjcm9zcyBtdWx0aXBsZSBpbXBsZW1lbnRhdGlvbnMKPj4+IHNob3VsZCBiZSBw
YXJzZWQgaW4gZ2VuZXJpYyBjb2RlIHRoYXQgZ2V0cyBjYWxsZWQgYnkgdGhlIGluZGl2aWR1YWwK
Pj4+IGRyaXZlcnMsCj4+PiBhbmQgdGhlbiB0aGUgcHJvcGVydGllcyB0aGF0IGFyZSBzcGVjaWZp
YyB0byB0aGUgaW50ZWdyYXRpb24gd29yayBkb25lIGJ5Cj4+PiBoaXNpbGljb24gc2hvdWxkIGJl
IHByZWZpeGVkIHdpdGggImhpc2lsaWNvbiwiLCBidXQgbm90IG5vcm1hbGx5IHdpdGggdGhlCj4+
PiBTb0MgbmFtZTogaXQgaXMgcXVpdGUgcG9zc2libGUgdGhhdCBhbm90aGVyIFNvQyB3aWxsIGJl
IGRlcml2ZWQgZnJvbSB0aGlzCj4+PiBjaGlwIGFuZCBpdCBzaG91bGQgcmV1c2UgdGhlIHByb3Bl
cnRpZXMuCj4+Cj4+Cj4+IEkgZG8gbm90IGtub3cgd2hlaGVyIG90aGVyIFNvQyBuZWVkIHRvIHVz
ZSB0aGUgb3B0aW9uYWwgcHJvcGVydGllcyBhcwo+PiBhYm92ZXIuIFNvIGhlcmUgdGhlIG5hbWUg
b2YgdGhlIG9wdGlvbmFsIHByb3BlcnRpZXMgaGFzICJoaTM2NjAiLgo+Cj4gVGhleSBzaG91bGQg
bm90IGhhdmUgImhpMzY2MCIgaW4gdGhlaXIgbmFtZXMgZWl0aGVyIHdheSwgaW5kZXBlbmRlbnQK
PiBvZiB3aGVyZSB0aGV5IGFyZSB1c2VkLgoKT2gsIGNoYW5nZSB0aGUgImhpMzY2MCIgdG8gImhp
c2lsaWNvbiI/CmUuZy4gdWZzLWhpMzY2MC11c2UtcmF0ZS1CICAtLT4gIHVmcy1oaXNpbGljb24t
dXNlLXJhdGUtQgo+Cj4+PiAobm90ZTogdGhpcyBpcyBkaWZmZXJlbnQgZnJvbSB0aGUgdmFsdWUg
b2YgdGhlICJjb21wYXRpYmxlIiBwcm9wZXJ0eSB0aGF0Cj4+PiBpcyBtZWFudCB0byBiZSBhcyBz
cGVjaWZpYyBhcyBwb3NzaWJsZSIuCj4+Pgo+Pj4gQWxzbywgcGxlYXNlIGNsYXJpZnkgaG93IHlv
dXIgYmluZGluZyByZWxhdGVzIHRvIHRoZSB1ZnNoY2QgYmluZGluZwo+Pj4gaW4gRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy91ZnNoY2QtcGx0ZnJtLnR4dDogZG9lcwo+Pj4g
aGkzNjYwIGltcGxlbWVudCBhbnkgcmVnaXN0ZXJzIHRoYXQgYXJlIHNoYXJlZCB3aXRoIHVmc2hj
ZCwgb3IgZG9lcwo+Pj4gaXQgdXNlIHRoZSBzYW1lIHBoeXNpY2FsIGludGVyZmFjZSB3aXRoIGEg
ZGlmZmVyZW50IHJlZ2lzdGVyIHNldD8KPj4KPj4gTm8sIG9ubHkgc2hvdyBob3cgdG8gdXNlIHRo
ZSBkdC1iaW5kaW5nIGZvciBoaTM2NjAgU29DCj4KPiBNeSBxdWVzdGlvbiB3YXMgYWJvdXQgdGhl
IGhhcmR3YXJlOiBkb2VzIGhpMzY2MCBpbXBsZW1lbnQgdWZzaGNkCj4gb3Igbm90PwoKWUVTCj4K
PiAgICAgICBBcm5kCj4KCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpsaW51eC1hcm0ta2VybmVsIG1haWxpbmcgbGlzdApsaW51eC1hcm0ta2VybmVsQGxp
c3RzLmluZnJhZGVhZC5vcmcKaHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0
aW5mby9saW51eC1hcm0ta2VybmVsCg==
