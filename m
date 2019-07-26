From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH 1/7] docs: fix broken doc references due to renames
Date: Fri, 26 Jul 2019 16:24:50 +0200
Message-ID: <20190726142450.GJ15868@phenom.ffwll.local>
References: <cover.1564140865.git.mchehab+samsung@kernel.org>
 <430ed96cb234805d1deb216e8c8559da22cc6bac.1564140865.git.mchehab+samsung@kernel.org>
 <CAL_JsqK_rfHehrKW_NS89BOV0=dYoao0H=zOzG=D-724vKduKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <CAL_JsqK_rfHehrKW_NS89BOV0=dYoao0H=zOzG=D-724vKduKw@mail.gmail.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Andrea Parri <andrea.parri@amarulasolutions.com>, Ajay Gupta <ajayg@nvidia.com>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Akira Yokosawa <akiyks@gmail.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Jerry Hoemann <jerry.hoemann@hpe.com>, dri-devel <dri-devel@lists.freedesktop.org>, David Howells <dhowells@redhat.com>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Linux I2C <linux-i2c@vger.kernel.org>, Joel Fernandes <joel@joelfernandes.org>, "Paul E. McKenney" <paulmck@linux.ibm.com>, Will Deacon <will@kernel.org>, "open list:GENERIC INCLUDE/ASM HEADER FILES" <linux-arch@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Wolfram Sang <wsa@the-dreams.de>, esc.storagedev@microsemi.com, Maxime Ripard <maxime.ripard@bootlin.com>, Ingo Molnar <mingo@>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCBKdWwgMjYsIDIwMTkgYXQgMDc6NDE6MzVBTSAtMDYwMCwgUm9iIEhlcnJpbmcgd3Jv
dGU6Cj4gT24gRnJpLCBKdWwgMjYsIDIwMTkgYXQgNTo0NyBBTSBNYXVybyBDYXJ2YWxobyBDaGVo
YWIKPiA8bWNoZWhhYitzYW1zdW5nQGtlcm5lbC5vcmc+IHdyb3RlOgo+ID4KPiA+IFNvbWUgZmls
ZXMgZ290IHJlbmFtZWQgYnV0IHByb2JhYmx5IGR1ZSB0byBzb21lIG1lcmdlIGNvbmZsaWN0cywK
PiA+IGEgZmV3IHJlZmVyZW5jZXMgc3RpbGwgcG9pbnQgdG8gdGhlIG9sZCBsb2NhdGlvbnMuCj4g
Pgo+ID4gU2lnbmVkLW9mZi1ieTogTWF1cm8gQ2FydmFsaG8gQ2hlaGFiIDxtY2hlaGFiK3NhbXN1
bmdAa2VybmVsLm9yZz4KPiA+IEFja2VkLWJ5OiBXb2xmcmFtIFNhbmcgPHdzYUB0aGUtZHJlYW1z
LmRlPiAjIEkyQyBwYXJ0Cj4gPiBSZXZpZXdlZC1ieTogSmVycnkgSG9lbWFubiA8amVycnkuaG9l
bWFubkBocGUuY29tPiAjIGhwd2R0LnJzdAo+ID4gLS0tCj4gPiAgRG9jdW1lbnRhdGlvbi9SQ1Uv
cmN1bGlzdF9udWxscy50eHQgICAgICAgICAgICAgICAgICAgfCAgMiArLQo+ID4gIERvY3VtZW50
YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9hcm0vaWRsZS1zdGF0ZXMudHh0IHwgIDIgKy0KPiA+
ICBEb2N1bWVudGF0aW9uL2xvY2tpbmcvc3BpbmxvY2tzLnJzdCAgICAgICAgICAgICAgICAgICB8
ICA0ICsrLS0KPiA+ICBEb2N1bWVudGF0aW9uL21lbW9yeS1iYXJyaWVycy50eHQgICAgICAgICAg
ICAgICAgICAgICB8ICAyICstCj4gPiAgRG9jdW1lbnRhdGlvbi90cmFuc2xhdGlvbnMva29fS1Iv
bWVtb3J5LWJhcnJpZXJzLnR4dCAgfCAgMiArLQo+ID4gIERvY3VtZW50YXRpb24vd2F0Y2hkb2cv
aHB3ZHQucnN0ICAgICAgICAgICAgICAgICAgICAgIHwgIDIgKy0KPiA+ICBNQUlOVEFJTkVSUyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IDEwICsrKysrLS0tLS0K
PiA+ICBkcml2ZXJzL2dwdS9kcm0vZHJtX21vZGVzLmMgICAgICAgICAgICAgICAgICAgICAgICAg
ICB8ICAyICstCgpmb3IgdGhlIGRybSBwYXJ0OgoKQWNrZWQtYnk6IERhbmllbCBWZXR0ZXIgPGRh
bmllbC52ZXR0ZXJAZmZ3bGwuY2g+Cgo+ID4gIGRyaXZlcnMvaTJjL2J1c3Nlcy9pMmMtbnZpZGlh
LWdwdS5jICAgICAgICAgICAgICAgICAgIHwgIDIgKy0KPiA+ICBkcml2ZXJzL3Njc2kvaHBzYS5j
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICA0ICsrLS0KPiA+ICAxMCBmaWxl
cyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAxNiBkZWxldGlvbnMoLSkKPiAKPiBBY2tlZC1i
eTogUm9iIEhlcnJpbmcgPHJvYmhAa2VybmVsLm9yZz4KCi0tIApEYW5pZWwgVmV0dGVyClNvZnR3
YXJlIEVuZ2luZWVyLCBJbnRlbCBDb3Jwb3JhdGlvbgpodHRwOi8vYmxvZy5mZndsbC5jaApfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFp
bGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5m
cmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWw=
