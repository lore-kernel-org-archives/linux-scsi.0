From: Bu Tao <butao@huawei.com>
Subject: Re: [PATCH v2 2/5] dt-bindings: scsi: ufs: add document for hi3660-ufs
Date: Thu, 22 Jun 2017 20:23:33 +0800
Message-ID: <f63c5e13-74d2-280c-af80-22ee55d71282@huawei.com>
References: <20170616065119.10704-1-butao@hisilicon.com>
 <20170616065119.10704-3-butao@hisilicon.com>
 <CAK8P3a2aPorzpUzwL=dkUkYNCGkhQMDPOkKRW1-=Hf=yCdvTsQ@mail.gmail.com>
 <0f79aeea-53e3-6bea-ffa6-0e057f2ff83b@huawei.com>
 <CAK8P3a2z7VbPb95Ltj=Duh1v_Yqxedb_g=ADNPWOrpEz1dCTuw@mail.gmail.com>
 <24438c4d-21c8-6302-acd4-4f0e223232ce@huawei.com>
 <CAK8P3a1MRx5zRp5-7iDY32+6PGsyHFaOom-bkWmftpLUS=8gBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAK8P3a1MRx5zRp5-7iDY32+6PGsyHFaOom-bkWmftpLUS=8gBA@mail.gmail.com>
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

CgrlnKggMjAxNy82LzIyIDIwOjE1LCBBcm5kIEJlcmdtYW5uIOWGmemBkzoKPiBPbiBUaHUsIEp1
biAyMiwgMjAxNyBhdCAxOjU4IFBNLCBCdSBUYW8gPGJ1dGFvQGh1YXdlaS5jb20+IHdyb3RlOgo+
PiDlnKggMjAxNy82LzIyIDE5OjUxLCBBcm5kIEJlcmdtYW5uIOWGmemBkzoKPj4+IE9uIFRodSwg
SnVuIDIyLCAyMDE3IGF0IDE6NDQgUE0sIEJ1IFRhbyA8YnV0YW9AaHVhd2VpLmNvbT4gd3JvdGU6
Cj4+Pj4g5ZyoIDIwMTcvNi8xNyA1OjUxLCBBcm5kIEJlcmdtYW5uIOWGmemBkzoKPj4+Pj4gT24g
RnJpLCBKdW4gMTYsIDIwMTcgYXQgODo1MSBBTSwgQnUgVGFvIDxidXRhb0BoaXNpbGljb24uY29t
PiB3cm90ZToKPj4+Pgo+Pj4+IEkgZG8gbm90IGtub3cgd2hlaGVyIG90aGVyIFNvQyBuZWVkIHRv
IHVzZSB0aGUgb3B0aW9uYWwgcHJvcGVydGllcyBhcwo+Pj4+IGFib3Zlci4gU28gaGVyZSB0aGUg
bmFtZSBvZiB0aGUgb3B0aW9uYWwgcHJvcGVydGllcyBoYXMgImhpMzY2MCIuCj4+Pgo+Pj4KPj4+
IFRoZXkgc2hvdWxkIG5vdCBoYXZlICJoaTM2NjAiIGluIHRoZWlyIG5hbWVzIGVpdGhlciB3YXks
IGluZGVwZW5kZW50Cj4+PiBvZiB3aGVyZSB0aGV5IGFyZSB1c2VkLgo+Pgo+Pgo+PiBPaCwgY2hh
bmdlIHRoZSAiaGkzNjYwIiB0byAiaGlzaWxpY29uIj8KPj4gZS5nLiB1ZnMtaGkzNjYwLXVzZS1y
YXRlLUIgIC0tPiAgdWZzLWhpc2lsaWNvbi11c2UtcmF0ZS1CCj4KPiBObywganVzdCAndXNlLXJh
dGUtQicsIG5vIHByZWZpeCBmb3IgdGhpcy4KPgo+Pj4+PiAobm90ZTogdGhpcyBpcyBkaWZmZXJl
bnQgZnJvbSB0aGUgdmFsdWUgb2YgdGhlICJjb21wYXRpYmxlIiBwcm9wZXJ0eQo+Pj4+PiB0aGF0
Cj4+Pj4+IGlzIG1lYW50IHRvIGJlIGFzIHNwZWNpZmljIGFzIHBvc3NpYmxlIi4KPj4+Pj4KPj4+
Pj4gQWxzbywgcGxlYXNlIGNsYXJpZnkgaG93IHlvdXIgYmluZGluZyByZWxhdGVzIHRvIHRoZSB1
ZnNoY2QgYmluZGluZwo+Pj4+PiBpbiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mv
dWZzL3Vmc2hjZC1wbHRmcm0udHh0OiBkb2VzCj4+Pj4+IGhpMzY2MCBpbXBsZW1lbnQgYW55IHJl
Z2lzdGVycyB0aGF0IGFyZSBzaGFyZWQgd2l0aCB1ZnNoY2QsIG9yIGRvZXMKPj4+Pj4gaXQgdXNl
IHRoZSBzYW1lIHBoeXNpY2FsIGludGVyZmFjZSB3aXRoIGEgZGlmZmVyZW50IHJlZ2lzdGVyIHNl
dD8KPj4+Pgo+Pj4+Cj4+Pj4gTm8sIG9ubHkgc2hvdyBob3cgdG8gdXNlIHRoZSBkdC1iaW5kaW5n
IGZvciBoaTM2NjAgU29DCj4+Pgo+Pj4KPj4+IE15IHF1ZXN0aW9uIHdhcyBhYm91dCB0aGUgaGFy
ZHdhcmU6IGRvZXMgaGkzNjYwIGltcGxlbWVudCB1ZnNoY2QKPj4+IG9yIG5vdD8KPj4KPj4KPj4g
WUVTCj4KPiBPaywgdGhlbiB0aGUgcHJvcGVydGllcyBzaG91bGQgYmUgZG9jdW1lbnRlZCBhcyBv
cHRpb25hbCBpbiB0aGUKPiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZzL3Vm
c2hjZC1wbHRmcm0udHh0IGZpbGUgZm9yIGFueXRoaW5nCj4gdGhhdCBoYXMgYSBwcm9wZXIgaW50
ZXJwcmV0YXRpb24gaW4gdGhlIGNvbnRleHQgb2YgdGhlIGdlbmVyaWMgdWZzaGNkCj4gZHJpdmVy
Lgo+Cj4gICAgICAgQXJuZAo+CgpPSyBJIHdpbGwgbW9kaWZ5IHRoaXMgYW5kIHVwZGF0ZSB0aGUg
cGF0Y2ggc29vbi4KCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpsaW51eC1hcm0ta2VybmVsIG1haWxpbmcgbGlzdApsaW51eC1hcm0ta2VybmVsQGxpc3Rz
LmluZnJhZGVhZC5vcmcKaHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5m
by9saW51eC1hcm0ta2VybmVsCg==
