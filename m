From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [-next PATCH 2/4] treewide: Use DEVICE_ATTR_RW
Date: Wed, 03 Jan 2018 16:16:08 +0100
Message-ID: <4624388.pPJCIclP0U@amdc3058>
References: <cover.1513706701.git.joe@perches.com>
 <CGME20171219181536epcas2p18d023209dc13ac504457c07b8b2b8965@epcas2p1.samsung.com>
 <cd38f14f06e1f447b3159ffe8c69c0df8241bb6e.1513706701.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-reply-to: <cd38f14f06e1f447b3159ffe8c69c0df8241bb6e.1513706701.git.joe@perches.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Joe Perches <joe@perches.com>
Cc: linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>, Heiko Carstens <heiko.carstens@de.ibm.com>, alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org, Jaroslav Kysela <perex@perex.cz>, Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-s390@vger.kernel.org, linux-omap@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, James Smart <james.smart@broadcom.com>, Cezary Jackiewicz <cezary.jackiewicz@gmail.com>, linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, Darren Hart <dvhart@infradead.org>, Zhang Rui <rui.zhang@intel.com>, Dick Kennedy <dick.kennedy@broadcom.com>, Mathias Nyman <mathias.nyman@intel.com>, linux-pm@vger.kernel.org, Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, intel-gfx@lists.freedesktop.org, Eduardo Valentin <edube>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlc2RheSwgRGVjZW1iZXIgMTksIDIwMTcgMTA6MTU6MDcgQU0gSm9lIFBlcmNoZXMgd3Jv
dGU6Cj4gQ29udmVydCBERVZJQ0VfQVRUUiB1c2VzIHRvIERFVklDRV9BVFRSX1JXIHdoZXJlIHBv
c3NpYmxlLgo+IAo+IERvbmUgd2l0aCBwZXJsIHNjcmlwdDoKPiAKPiAkIGdpdCBncmVwIC13IC0t
bmFtZS1vbmx5IERFVklDRV9BVFRSIHwgXAo+ICAgeGFyZ3MgcGVybCAtaSAtZSAnbG9jYWwgJC87
IHdoaWxlICg8PikgeyBzL1xiREVWSUNFX0FUVFJccypcKFxzKihcdyspXHMqLFxzKlwoPyhccypT
X0lSVUdPXHMqXHxccypTX0lXVVNSfFxzKlNfSVdVU1JccypcfFxzKlNfSVJVR09ccyp8XHMqMDY0
NFxzKilcKT9ccyosXHMqXDFfc2hvd1xzKixccypcMV9zdG9yZVxzKlwpL0RFVklDRV9BVFRSX1JX
KFwxKS9nOyBwcmludDt9Jwo+IAo+IFNpZ25lZC1vZmYtYnk6IEpvZSBQZXJjaGVzIDxqb2VAcGVy
Y2hlcy5jb20+Cj4gLS0tCj4gIGFyY2gvczM5MC9rZXJuZWwvdG9wb2xvZ3kuYyAgICAgICAgICB8
ICAzICstLQo+ICBhcmNoL3RpbGUva2VybmVsL3N5c2ZzLmMgICAgICAgICAgICAgfCAgMiArLQo+
ICBkcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X3N5c2ZzLmMgICAgfCAgNiArKy0tLQo+ICBkcml2
ZXJzL3BsYXRmb3JtL3g4Ni9jb21wYWwtbGFwdG9wLmMgfCAxOCArKysrKy0tLS0tLS0tLS0KPiAg
ZHJpdmVycy9zMzkwL2Npby9kZXZpY2UuYyAgICAgICAgICAgIHwgIDIgKy0KPiAgZHJpdmVycy9z
Y3NpL2xwZmMvbHBmY19hdHRyLmMgICAgICAgIHwgNDMgKysrKysrKysrKysrLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tCj4gIGRyaXZlcnMvdGhlcm1hbC90aGVybWFsX3N5c2ZzLmMgICAgICB8ICA5
ICsrKystLS0tCj4gIGRyaXZlcnMvdHR5L3NlcmlhbC9zaC1zY2kuYyAgICAgICAgICB8ICAyICst
Cj4gIGRyaXZlcnMvdXNiL2hvc3QveGhjaS1kYmdjYXAuYyAgICAgICB8ICAyICstCj4gIGRyaXZl
cnMvdXNiL3BoeS9waHktdGFodm8uYyAgICAgICAgICB8ICAyICstCj4gIGRyaXZlcnMvdmlkZW8v
ZmJkZXYvYXVvX2sxOTB4LmMgICAgICB8ICA0ICsrLS0KPiAgZHJpdmVycy92aWRlby9mYmRldi93
MTAwZmIuYyAgICAgICAgIHwgIDQgKystLQo+ICBsaWIvdGVzdF9maXJtd2FyZS5jICAgICAgICAg
ICAgICAgICAgfCAxNCArKysrKy0tLS0tLS0KPiAgbGliL3Rlc3Rfa21vZC5jICAgICAgICAgICAg
ICAgICAgICAgIHwgMTQgKysrKystLS0tLS0tCj4gIHNvdW5kL3NvYy9vbWFwL21jYnNwLmMgICAg
ICAgICAgICAgICB8ICA0ICsrLS0KPiAgMTUgZmlsZXMgY2hhbmdlZCwgNDkgaW5zZXJ0aW9ucygr
KSwgODAgZGVsZXRpb25zKC0pCgpGb3IgZmJkZXYgY2hhbmdlczoKCkFja2VkLWJ5OiBCYXJ0bG9t
aWVqIFpvbG5pZXJraWV3aWN6IDxiLnpvbG5pZXJraWVAc2Ftc3VuZy5jb20+CgpCZXN0IHJlZ2Fy
ZHMsCi0tCkJhcnRsb21pZWogWm9sbmllcmtpZXdpY3oKU2Ftc3VuZyBSJkQgSW5zdGl0dXRlIFBv
bGFuZApTYW1zdW5nIEVsZWN0cm9uaWNzCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0cy5m
cmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0
aW5mby9pbnRlbC1nZngK
