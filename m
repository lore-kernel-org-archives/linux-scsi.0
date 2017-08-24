From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 03/15] [media] i2c: make device_type const
Date: Thu, 24 Aug 2017 18:31:19 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1708241830240.3709@axis700.grange>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
 <1503130946-2854-4-git-send-email-bhumirks@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1503130946-2854-4-git-send-email-bhumirks@gmail.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: heikki.krogerus@linux.intel.com, linux-pci@vger.kernel.org, heiko.carstens@de.ibm.com, dri-devel@lists.freedesktop.org, bjorn.andersson@linaro.org, linux-tegra@vger.kernel.org, thierry.reding@gmail.com, linux-mtd@lists.infradead.org, daniel.vetter@intel.com, kishon@ti.com, freude@de.ibm.com, boris.brezillon@free-electrons.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, richard@nod.at, jonathanh@nvidia.com, marek.vasut@gmail.com, fcoe-devel@open-fcoe.org, dvhart@infradead.org, tomas.winkler@intel.com, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, ohad@wizery.com, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, linux-remoteproc@vger.kernel.org, johan@kernel.org, julia.lawall@lip6.fr, elder@kernel.org, bhelgaas@google.com, mchehab@kernel.org, linux-edac@vger.kernel.org, cleech@redhat.com, jth@kernel.org, martin.petersen@oracle.com, greybus-dev@
List-Id: linux-scsi@vger.kernel.org

T24gU2F0LCAxOSBBdWcgMjAxNywgQmh1bWlrYSBHb3lhbCB3cm90ZToKCj4gTWFrZSB0aGlzIGNv
bnN0IGFzIGl0IGlzIG9ubHkgc3RvcmVkIGluIHRoZSB0eXBlIGZpZWxkIG9mIGEgZGV2aWNlCj4g
c3RydWN0dXJlLCB3aGljaCBpcyBjb25zdC4KPiBEb25lIHVzaW5nIENvY2NpbmVsbGUuCj4gCj4g
U2lnbmVkLW9mZi1ieTogQmh1bWlrYSBHb3lhbCA8Ymh1bWlya3NAZ21haWwuY29tPgoKQWNrZWQt
Ynk6IEd1ZW5uYWRpIExpYWtob3ZldHNraSA8Zy5saWFraG92ZXRza2lAZ214LmRlPgoKVGhhbmtz
Ckd1ZW5uYWRpCgo+IC0tLQo+ICBkcml2ZXJzL21lZGlhL2kyYy9zb2NfY2FtZXJhL210OXQwMzEu
YyB8IDIgKy0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0p
Cj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvaTJjL3NvY19jYW1lcmEvbXQ5dDAzMS5j
IGIvZHJpdmVycy9tZWRpYS9pMmMvc29jX2NhbWVyYS9tdDl0MDMxLmMKPiBpbmRleCA3MTRmYjM1
Li40ODAyZDMwIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbWVkaWEvaTJjL3NvY19jYW1lcmEvbXQ5
dDAzMS5jCj4gKysrIGIvZHJpdmVycy9tZWRpYS9pMmMvc29jX2NhbWVyYS9tdDl0MDMxLmMKPiBA
QCAtNTkyLDcgKzU5Miw3IEBAIHN0YXRpYyBpbnQgbXQ5dDAzMV9ydW50aW1lX3Jlc3VtZShzdHJ1
Y3QgZGV2aWNlICpkZXYpCj4gIAkucnVudGltZV9yZXN1bWUJCT0gbXQ5dDAzMV9ydW50aW1lX3Jl
c3VtZSwKPiAgfTsKPiAgCj4gLXN0YXRpYyBzdHJ1Y3QgZGV2aWNlX3R5cGUgbXQ5dDAzMV9kZXZf
dHlwZSA9IHsKPiArc3RhdGljIGNvbnN0IHN0cnVjdCBkZXZpY2VfdHlwZSBtdDl0MDMxX2Rldl90
eXBlID0gewo+ICAJLm5hbWUJPSAiTVQ5VDAzMSIsCj4gIAkucG0JPSAmbXQ5dDAzMV9kZXZfcG1f
b3BzLAo+ICB9Owo+IC0tIAo+IDEuOS4xCj4gCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3Rz
LmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xp
c3RpbmZvL2RyaS1kZXZlbAo=
