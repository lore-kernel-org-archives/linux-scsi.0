From: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [-next PATCH 3/4] treewide: Use DEVICE_ATTR_RO
Date: Thu, 21 Dec 2017 11:34:10 +0200
Message-ID: <20171221093410.ygvupz3azaccxgnb@valkosipuli.retiisi.org.uk>
References: <cover.1513706701.git.joe@perches.com>
 <2e64e7d278fa9e4e255221fb84717884a7bfb69c.1513706701.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <2e64e7d278fa9e4e255221fb84717884a7bfb69c.1513706701.git.joe@perches.com>
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
Cc: Don Brace <don.brace@microsemi.com>, linux-nvme@lists.infradead.org, Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org, David Airlie <airlied@linux.ie>, esc.storagedev@microsemi.com, Heiko Carstens <heiko.carstens@de.ibm.com>, alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org, Russell King <linux@armlinux.org.uk>, Keith Busch <keith.busch@intel.com>, Robert Jarzmik <robert.jarzmik@free.fr>, Christoph Hellwig <hch@lst.de>, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Sagi Grimberg <sagi@grimberg.me>, Yoshinori Sato <ysato@users.sourceforge.jp>, Takashi Iwai <tiwai@suse.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, James Smart <james.smart@broadcom.com>, linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>, Dick Kennedy <dick.kennedy@broadcom.com>, Corey
List-Id: linux-scsi@vger.kernel.org

SGkgSm9lLAoKT24gVHVlLCBEZWMgMTksIDIwMTcgYXQgMTA6MTU6MDhBTSAtMDgwMCwgSm9lIFBl
cmNoZXMgd3JvdGU6Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9tZWRpYS9hdG9taXNw
L3BjaS9hdG9taXNwMi9obW0vaG1tLmMgYi9kcml2ZXJzL3N0YWdpbmcvbWVkaWEvYXRvbWlzcC9w
Y2kvYXRvbWlzcDIvaG1tL2htbS5jCj4gaW5kZXggYTFjODFjMTI3MThjLi40MzM4YjhhMTMwOWYg
MTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9zdGFnaW5nL21lZGlhL2F0b21pc3AvcGNpL2F0b21pc3Ay
L2htbS9obW0uYwo+ICsrKyBiL2RyaXZlcnMvc3RhZ2luZy9tZWRpYS9hdG9taXNwL3BjaS9hdG9t
aXNwMi9obW0vaG1tLmMKPiBAQCAtMTU4LDEwICsxNTgsMTAgQEAgc3RhdGljIHNzaXplX3QgZHlu
YW1pY19wb29sX3Nob3coc3RydWN0IGRldmljZSAqZGV2LAo+ICAJcmV0dXJuIHJldDsKPiAgfTsK
PiAgCj4gLXN0YXRpYyBERVZJQ0VfQVRUUihhY3RpdmVfYm8sIDA0NDQsIGFjdGl2ZV9ib19zaG93
LCBOVUxMKTsKPiAtc3RhdGljIERFVklDRV9BVFRSKGZyZWVfYm8sIDA0NDQsIGZyZWVfYm9fc2hv
dywgTlVMTCk7Cj4gLXN0YXRpYyBERVZJQ0VfQVRUUihyZXNlcnZlZF9wb29sLCAwNDQ0LCByZXNl
cnZlZF9wb29sX3Nob3csIE5VTEwpOwo+IC1zdGF0aWMgREVWSUNFX0FUVFIoZHluYW1pY19wb29s
LCAwNDQ0LCBkeW5hbWljX3Bvb2xfc2hvdywgTlVMTCk7Cj4gK3N0YXRpYyBERVZJQ0VfQVRUUl9S
TyhhY3RpdmVfYm8pOwo+ICtzdGF0aWMgREVWSUNFX0FUVFJfUk8oZnJlZV9ibyk7Cj4gK3N0YXRp
YyBERVZJQ0VfQVRUUl9STyhyZXNlcnZlZF9wb29sKTsKPiArc3RhdGljIERFVklDRV9BVFRSX1JP
KGR5bmFtaWNfcG9vbCk7Cj4gIAo+ICBzdGF0aWMgc3RydWN0IGF0dHJpYnV0ZSAqc3lzZnNfYXR0
cnNfY3RybFtdID0gewo+ICAJJmRldl9hdHRyX2FjdGl2ZV9iby5hdHRyLAoKSSBoYXZlIHRoZSBl
eGFjdCBzYW1lIGNoYW5nZXMgcXVldWVkIHVwIGluIG15IHRyZWUuIEFzIHRoZXJlIHNlZW0gdG8g
YmUgbm8KZGVwZW5kZW5jaWVzIHRvIG90aGVyIHBhdGNoZXMgaW4geW91ciBzZXQsIGhvdyBhYm91
dCBkcm9wcGluZyB0aGlzIGNodW5rPwoKVGhhbmtzLgoKLS0gClNha2FyaSBBaWx1cwplLW1haWw6
IHNha2FyaS5haWx1c0Bpa2kuZmkKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KSW50ZWwtZ2Z4IG1haWxpbmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJlZWRl
c2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8v
aW50ZWwtZ2Z4Cg==
