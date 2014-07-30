From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
	kmem_cache_create+0x1a9/0x330()
Date: Wed, 30 Jul 2014 08:21:35 -0400
Message-ID: <20140730122135.GE28613@hansolo.jdub.homelinux.org>
References: <53C8FD95.5020302@gmail.com> <20140718132104.GK27940@esperanza>
	<20140718141747.GA23272@lst.de> <53C97D34.5040707@gmail.com>
	<1405714046.30262.10.camel@dabdike.int.hansenpartnership.com>
	<20140719164454.GA24530@lst.de> <53CCDFC3.5010802@gmail.com>
	<20140726162102.GA7126@lst.de> <1406533762.2003.13.camel@jarvis>
	<20140729122611.GA25980@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kernel-bounces-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140729122611.GA25980-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://admin.fedoraproject.org/mailman/options/kernel>,
	<mailto:kernel-request-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.fedoraproject.org/pipermail/kernel/>
List-Post: <mailto:kernel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
List-Help: <mailto:kernel-request-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org?subject=help>
List-Subscribe: <https://admin.fedoraproject.org/mailman/listinfo/kernel>,
	<mailto:kernel-request-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org?subject=subscribe>
Sender: kernel-bounces-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org
Errors-To: kernel-bounces-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mailing-List fedora-kernel <kernel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>, poma <pomidorabelisima-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCBKdWwgMjksIDIwMTQgYXQgMDI6MjY6MTFQTSArMDIwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gT24gTW9uLCBKdWwgMjgsIDIwMTQgYXQgMTE6NDk6MjJBTSArMDQwMCwgSmFt
ZXMgQm90dG9tbGV5IHdyb3RlOgo+ID4gVGhhdCBuZWVkcyB0byBiZQo+ID4gCj4gPiBGcm9tOiBK
YW1lcyBCb3R0b21sZXkgPEpCb3R0b21sZXlAUGFyYWxsZWxzLmNvbT4KPiA+IAo+ID4gQXMgd2Vs
bC4gIEkgZG8gbGlzdCBoYW5kbGluZyBvbiBoYW5zZW5wYXJ0bmVyc2hpcC5jb20gdG8gbWluaW1p
c2UKPiA+IGV4Y2hhbmdlIHdyZWNrYWdlIG9uIG1haWxpbmdsaXN0cywgYnV0IEkgc2hvdWxkIGFj
a25vd2xlZGdlIFBhcmFsbGVscyBhcwo+ID4gc3VwcG9ydGluZyB0aGUgd29yayBJIGRvLgo+IAo+
IFRoYW5rcywgSSd2ZSB1cGRhdGUgdGhlIGF1dGhvciwgYWRkZWQgYSBDYyB0byDRm3RhYmxlIGFu
ZCBwdXNoZWQgaXQgb3V0IHRvCj4gdGhlIGNvcmUtZm9yLTMuMTcgYnJhbmNoLgoKVGhpcyBmaXhl
cyBhIGJ1ZyBpbiB0aGUgMy4xNiBrZXJuZWwuICBXaHkgd291bGRuJ3QgaXQgYmUgc2VudCB0byBM
aW51cwpmb3IgaW5jbHVzaW9uIGluIHRoZSBmaW5hbCByZWxlYXNlIHRoZXJlPwoKam9zaApfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprZXJuZWwgbWFpbGlu
ZyBsaXN0Cmtlcm5lbEBsaXN0cy5mZWRvcmFwcm9qZWN0Lm9yZwpodHRwczovL2FkbWluLmZlZG9y
YXByb2plY3Qub3JnL21haWxtYW4vbGlzdGluZm8va2VybmVs
