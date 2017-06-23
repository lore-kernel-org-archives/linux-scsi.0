From: Bu Tao <butao@huawei.com>
Subject: Re: [PATCH v2 2/5] dt-bindings: scsi: ufs: add document for hi3660-ufs
Date: Fri, 23 Jun 2017 09:09:54 +0800
Message-ID: <f1dad4f6-e424-7a38-8148-2669074efa35@huawei.com>
References: <20170616065119.10704-1-butao@hisilicon.com>
 <20170616065119.10704-3-butao@hisilicon.com>
 <CAK8P3a2aPorzpUzwL=dkUkYNCGkhQMDPOkKRW1-=Hf=yCdvTsQ@mail.gmail.com>
 <0f79aeea-53e3-6bea-ffa6-0e057f2ff83b@huawei.com>
 <CAK8P3a2z7VbPb95Ltj=Duh1v_Yqxedb_g=ADNPWOrpEz1dCTuw@mail.gmail.com>
 <5c4c0a7b844055b32b8463fcee04401e@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <5c4c0a7b844055b32b8463fcee04401e@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Subhash Jadavani <subhashj@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Eric Anholt <eric@anholt.net>, Krzysztof Kozlowski <krzk@kernel.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>, Wei Xu <xuwei5@hisilicon.com>, Thierry Reding <treding@nvidia.com>, devicetree@vger.kernel.org, suzhuangluan@hisilicon.com, kongfei@hisilicon.com, Rob Herring <robh+dt@kernel.org>, linux-scsi-owner@vger.kernel.org, Gregory CLEMENT <gregory.clement@free-electrons.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Thomas Petazzoni <thomas.petazzoni@free-electrons.com>, Guodong Xu <guodong.xu@linaro.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Riku Voipio <riku.voipio@l>
List-Id: linux-scsi@vger.kernel.org

CgrlnKggMjAxNy82LzIzIDk6MDUsIFN1Ymhhc2ggSmFkYXZhbmkg5YaZ6YGTOgo+IE9uIDIwMTct
MDYtMjIgMDQ6NTEsIEFybmQgQmVyZ21hbm4gd3JvdGU6Cj4+IE9uIFRodSwgSnVuIDIyLCAyMDE3
IGF0IDE6NDQgUE0sIEJ1IFRhbyA8YnV0YW9AaHVhd2VpLmNvbT4gd3JvdGU6Cj4+PiDlnKggMjAx
Ny82LzE3IDU6NTEsIEFybmQgQmVyZ21hbm4g5YaZ6YGTOgo+Pj4+IE9uIEZyaSwgSnVuIDE2LCAy
MDE3IGF0IDg6NTEgQU0sIEJ1IFRhbyA8YnV0YW9AaGlzaWxpY29uLmNvbT4gd3JvdGU6Cj4+Pj4+
ICtPcHRpb25hbCBwcm9wZXJ0aWVzIGZvciBib2FyZCBkZXZpY2U6Cj4+Pj4+ICstIHVmcy1oaTM2
NjAtdXNlLXJhdGUtQiAgICAgICAgICAgICAgICA6IHNwZWNpZmllcyBVRlMgcmF0ZS1CCj4+Pj4+
ICstIHVmcy1oaTM2NjAtYnJva2VuLWZhc3RhdXRvICAgOiBzcGVjaWZpZXMgbm8gZmFzdGF1dG8K
Pj4+Pj4gKy0gdWZzLWhpMzY2MC11c2UtSFMtR0VBUjMgICAgICA6IHNwZWNpZmllcyBVRlMgSFMt
R0VBUjMKPj4+Pj4gKy0gdWZzLWhpMzY2MC11c2UtSFMtR0VBUjIgICAgICA6IHNwZWNpZmllcyBV
RlMgSFMtR0VBUjIKPj4+Pj4gKy0gdWZzLWhpMzY2MC11c2UtSFMtR0VBUjEgICAgICA6IHNwZWNp
ZmllcyBVRlMgSFMtR0VBUjEKPj4+Pj4gKy0gdWZzLWhpMzY2MC1icm9rZW4tY2xrLWdhdGUtYnlw
YXNzICAgIDogc3BlY2lmaWVzIG5vIGNsay1nYXRlCj4+Pj4+ICstIHVmcy1oaTM2NjAtdXNlLW9u
ZS1saW5lICAgICAgOiBzcGVjaWZpZXMgVUZTIHVzZSBvbmUgbGluZSB3b3JrCj4+Pj4+ICstIHJl
c2V0LWdwaW8gICAgICAgICAgICAgICAgICAgOiBzcGVjaWZpZXMgdG8gcmVzZXQgZGV2aWNlcwo+
Pj4+Cj4+Pj4KPj4+PiBTb21lIG9mIHRoZXNlIHNvdW5kIHJhdGhlciBnZW5lcmljIGFuZCBtaWdo
dCBhcHBseSB0byBVRlMKPj4+PiBpbXBsZW1lbnRhdGlvbnMKPj4+PiBvdGhlciB0aGFuIGhpMzY2
MCwgc28gSSdkIHN1Z2dlc3QgYWRkaW5nIHRoZW0gdG8gdGhlIGJhc2UgdWZzCj4+Pj4gYmluZGlu
ZyB3aXRoCj4+Pj4gYSBnZW5lcmljIG5hbWUgaW5zdGVhZC4KPj4+Pgo+Pj4+IEFueSBEVCBwcm9w
ZXJ0aWVzIHRoYXQgbWlnaHQgYmUgdXNlZnVsIGFjcm9zcyBtdWx0aXBsZSBpbXBsZW1lbnRhdGlv
bnMKPj4+PiBzaG91bGQgYmUgcGFyc2VkIGluIGdlbmVyaWMgY29kZSB0aGF0IGdldHMgY2FsbGVk
IGJ5IHRoZSBpbmRpdmlkdWFsCj4+Pj4gZHJpdmVycywKPj4+PiBhbmQgdGhlbiB0aGUgcHJvcGVy
dGllcyB0aGF0IGFyZSBzcGVjaWZpYyB0byB0aGUgaW50ZWdyYXRpb24gd29yawo+Pj4+IGRvbmUg
YnkKPj4+PiBoaXNpbGljb24gc2hvdWxkIGJlIHByZWZpeGVkIHdpdGggImhpc2lsaWNvbiwiLCBi
dXQgbm90IG5vcm1hbGx5Cj4+Pj4gd2l0aCB0aGUKPj4+PiBTb0MgbmFtZTogaXQgaXMgcXVpdGUg
cG9zc2libGUgdGhhdCBhbm90aGVyIFNvQyB3aWxsIGJlIGRlcml2ZWQgZnJvbQo+Pj4+IHRoaXMK
Pj4+PiBjaGlwIGFuZCBpdCBzaG91bGQgcmV1c2UgdGhlIHByb3BlcnRpZXMuCj4+Pgo+Pj4KPj4+
IEkgZG8gbm90IGtub3cgd2hlaGVyIG90aGVyIFNvQyBuZWVkIHRvIHVzZSB0aGUgb3B0aW9uYWwg
cHJvcGVydGllcyBhcwo+Pj4gYWJvdmVyLiBTbyBoZXJlIHRoZSBuYW1lIG9mIHRoZSBvcHRpb25h
bCBwcm9wZXJ0aWVzIGhhcyAiaGkzNjYwIi4KPj4KPj4gVGhleSBzaG91bGQgbm90IGhhdmUgImhp
MzY2MCIgaW4gdGhlaXIgbmFtZXMgZWl0aGVyIHdheSwgaW5kZXBlbmRlbnQKPj4gb2Ygd2hlcmUg
dGhleSBhcmUgdXNlZC4KPgo+Cj4gWWVzLCBpIGFncmVlIHdpdGggQXJuZCB0aGF0IFNvQ3MgbWln
aHQgYWxzbyBuZWVkIHRoZXNlIHNvIHBsZWFzZSBtYWtlCj4gdGhlc2UgcHJvcGVydGllcyBnZW5l
cmljIChwdXQgdGhlbSB1bmRlcgo+IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy91
ZnMvdWZzaGNkLXBsdGZybS50eHQpIGFuZCBhbHNvIG1vdmUKPiB0aGVpciBwYXJzaW5nIGNvZGUg
aW4gZ2VuZXJpYyBkcml2ZXIgKHVmc2hjZC5jIG9yIHVmc2hjZC1wbHRmcm0uYykuCj4KVGhhbmtz
IGZvciB5b3VyIGNvbW1lbnRzLiBJIHdpbGwgbW9kaWZ5IHRoaXMgYW5kIHVwZGF0ZSBzb29uLgo+
Pgo+Pj4+IChub3RlOiB0aGlzIGlzIGRpZmZlcmVudCBmcm9tIHRoZSB2YWx1ZSBvZiB0aGUgImNv
bXBhdGlibGUiIHByb3BlcnR5Cj4+Pj4gdGhhdAo+Pj4+IGlzIG1lYW50IHRvIGJlIGFzIHNwZWNp
ZmljIGFzIHBvc3NpYmxlIi4KPj4+Pgo+Pj4+IEFsc28sIHBsZWFzZSBjbGFyaWZ5IGhvdyB5b3Vy
IGJpbmRpbmcgcmVsYXRlcyB0byB0aGUgdWZzaGNkIGJpbmRpbmcKPj4+PiBpbiBEb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdWZzL3Vmc2hjZC1wbHRmcm0udHh0OiBkb2VzCj4+Pj4g
aGkzNjYwIGltcGxlbWVudCBhbnkgcmVnaXN0ZXJzIHRoYXQgYXJlIHNoYXJlZCB3aXRoIHVmc2hj
ZCwgb3IgZG9lcwo+Pj4+IGl0IHVzZSB0aGUgc2FtZSBwaHlzaWNhbCBpbnRlcmZhY2Ugd2l0aCBh
IGRpZmZlcmVudCByZWdpc3RlciBzZXQ/Cj4+Pgo+Pj4gTm8sIG9ubHkgc2hvdyBob3cgdG8gdXNl
IHRoZSBkdC1iaW5kaW5nIGZvciBoaTM2NjAgU29DCj4+Cj4+IE15IHF1ZXN0aW9uIHdhcyBhYm91
dCB0aGUgaGFyZHdhcmU6IGRvZXMgaGkzNjYwIGltcGxlbWVudCB1ZnNoY2QKPj4gb3Igbm90Pwo+
Pgo+PiAgICAgICBBcm5kCj4KCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpsaW51eC1hcm0ta2VybmVsIG1haWxpbmcgbGlzdApsaW51eC1hcm0ta2VybmVs
QGxpc3RzLmluZnJhZGVhZC5vcmcKaHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9s
aXN0aW5mby9saW51eC1hcm0ta2VybmVsCg==
