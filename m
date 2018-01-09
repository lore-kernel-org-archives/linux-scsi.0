From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [-next PATCH 3/4] treewide: Use DEVICE_ATTR_RO
Date: Tue, 9 Jan 2018 16:34:16 +0100
Message-ID: <20180109153416.GA7780@kroah.com>
References: <cover.1513706701.git.joe@perches.com>
 <2e64e7d278fa9e4e255221fb84717884a7bfb69c.1513706701.git.joe@perches.com>
 <20171221093410.ygvupz3azaccxgnb@valkosipuli.retiisi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20171221093410.ygvupz3azaccxgnb@valkosipuli.retiisi.org.uk>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Don Brace <don.brace@microsemi.com>, alsa-devel@alsa-project.org, Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org, David Airlie <airlied@linux.ie>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-nvme@lists.infradead.org, James Smart <james.smart@broadcom.com>, Keith Busch <keith.busch@intel.com>, Robert Jarzmik <robert.jarzmik@free.fr>, Christoph Hellwig <hch@lst.de>, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Sagi Grimberg <sagi@grimberg.me>, Yoshinori Sato <ysato@users.sourceforge.jp>, esc.storagedev@microsemi.com, Russell King <linux@armlinux.org.uk>, linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>, Dick Kennedy <dick.kennedy@broadcom.com>, Corey Minyard <minyard@acm.or>
List-Id: linux-scsi@vger.kernel.org

T24gVGh1LCBEZWMgMjEsIDIwMTcgYXQgMTE6MzQ6MTBBTSArMDIwMCwgU2FrYXJpIEFpbHVzIHdy
b3RlOgo+IEhpIEpvZSwKPiAKPiBPbiBUdWUsIERlYyAxOSwgMjAxNyBhdCAxMDoxNTowOEFNIC0w
ODAwLCBKb2UgUGVyY2hlcyB3cm90ZToKPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcv
bWVkaWEvYXRvbWlzcC9wY2kvYXRvbWlzcDIvaG1tL2htbS5jIGIvZHJpdmVycy9zdGFnaW5nL21l
ZGlhL2F0b21pc3AvcGNpL2F0b21pc3AyL2htbS9obW0uYwo+ID4gaW5kZXggYTFjODFjMTI3MThj
Li40MzM4YjhhMTMwOWYgMTAwNjQ0Cj4gPiAtLS0gYS9kcml2ZXJzL3N0YWdpbmcvbWVkaWEvYXRv
bWlzcC9wY2kvYXRvbWlzcDIvaG1tL2htbS5jCj4gPiArKysgYi9kcml2ZXJzL3N0YWdpbmcvbWVk
aWEvYXRvbWlzcC9wY2kvYXRvbWlzcDIvaG1tL2htbS5jCj4gPiBAQCAtMTU4LDEwICsxNTgsMTAg
QEAgc3RhdGljIHNzaXplX3QgZHluYW1pY19wb29sX3Nob3coc3RydWN0IGRldmljZSAqZGV2LAo+
ID4gIAlyZXR1cm4gcmV0Owo+ID4gIH07Cj4gPiAgCj4gPiAtc3RhdGljIERFVklDRV9BVFRSKGFj
dGl2ZV9ibywgMDQ0NCwgYWN0aXZlX2JvX3Nob3csIE5VTEwpOwo+ID4gLXN0YXRpYyBERVZJQ0Vf
QVRUUihmcmVlX2JvLCAwNDQ0LCBmcmVlX2JvX3Nob3csIE5VTEwpOwo+ID4gLXN0YXRpYyBERVZJ
Q0VfQVRUUihyZXNlcnZlZF9wb29sLCAwNDQ0LCByZXNlcnZlZF9wb29sX3Nob3csIE5VTEwpOwo+
ID4gLXN0YXRpYyBERVZJQ0VfQVRUUihkeW5hbWljX3Bvb2wsIDA0NDQsIGR5bmFtaWNfcG9vbF9z
aG93LCBOVUxMKTsKPiA+ICtzdGF0aWMgREVWSUNFX0FUVFJfUk8oYWN0aXZlX2JvKTsKPiA+ICtz
dGF0aWMgREVWSUNFX0FUVFJfUk8oZnJlZV9ibyk7Cj4gPiArc3RhdGljIERFVklDRV9BVFRSX1JP
KHJlc2VydmVkX3Bvb2wpOwo+ID4gK3N0YXRpYyBERVZJQ0VfQVRUUl9STyhkeW5hbWljX3Bvb2wp
Owo+ID4gIAo+ID4gIHN0YXRpYyBzdHJ1Y3QgYXR0cmlidXRlICpzeXNmc19hdHRyc19jdHJsW10g
PSB7Cj4gPiAgCSZkZXZfYXR0cl9hY3RpdmVfYm8uYXR0ciwKPiAKPiBJIGhhdmUgdGhlIGV4YWN0
IHNhbWUgY2hhbmdlcyBxdWV1ZWQgdXAgaW4gbXkgdHJlZS4gQXMgdGhlcmUgc2VlbSB0byBiZSBu
bwo+IGRlcGVuZGVuY2llcyB0byBvdGhlciBwYXRjaGVzIGluIHlvdXIgc2V0LCBob3cgYWJvdXQg
ZHJvcHBpbmcgdGhpcyBjaHVuaz8KCkkndmUgbm93IGRyb3BwZWQgaXQsIHRoYW5rcy4KCmdyZWcg
ay1oCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkludGVs
LWdmeCBtYWlsaW5nIGxpc3QKSW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczov
L2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ludGVsLWdmeAo=
