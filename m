From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
	kmem_cache_create+0x1a9/0x330()
Date: Wed, 30 Jul 2014 16:52:25 +0200
Message-ID: <20140730145225.GA15757@lst.de>
References: <20140718132104.GK27940@esperanza> <20140718141747.GA23272@lst.de>
	<53C97D34.5040707@gmail.com>
	<1405714046.30262.10.camel@dabdike.int.hansenpartnership.com>
	<20140719164454.GA24530@lst.de> <53CCDFC3.5010802@gmail.com>
	<20140726162102.GA7126@lst.de> <1406533762.2003.13.camel@jarvis>
	<20140729122611.GA25980@lst.de>
	<20140730122135.GE28613@hansolo.jdub.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kernel-bounces-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140730122135.GE28613-dHPIJuKSOV01V+h/cAXI7w8O6CCKKCg3HZ5vskTnxNA@public.gmane.org>
List-Unsubscribe: <https://admin.fedoraproject.org/mailman/options/kernel>,
	<mailto:kernel-request-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.fedoraproject.org/pipermail/kernel/>
List-Post: <mailto:kernel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
List-Help: <mailto:kernel-request-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org?subject=help>
List-Subscribe: <https://admin.fedoraproject.org/mailman/listinfo/kernel>,
	<mailto:kernel-request-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org?subject=subscribe>
Sender: kernel-bounces-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org
Errors-To: kernel-bounces-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org
To: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mailing-List fedora-kernel <kernel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>, poma <pomidorabelisima-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCBKdWwgMzAsIDIwMTQgYXQgMDg6MjE6MzVBTSAtMDQwMCwgSm9zaCBCb3llciB3cm90
ZToKPiA+IFRoYW5rcywgSSd2ZSB1cGRhdGUgdGhlIGF1dGhvciwgYWRkZWQgYSBDYyB0byDRm3Rh
YmxlIGFuZCBwdXNoZWQgaXQgb3V0IHRvCj4gPiB0aGUgY29yZS1mb3ItMy4xNyBicmFuY2guCj4g
Cj4gVGhpcyBmaXhlcyBhIGJ1ZyBpbiB0aGUgMy4xNiBrZXJuZWwuICBXaHkgd291bGRuJ3QgaXQg
YmUgc2VudCB0byBMaW51cwo+IGZvciBpbmNsdXNpb24gaW4gdGhlIGZpbmFsIHJlbGVhc2UgdGhl
cmU/CgpJJ20gb25seSBjb2xsZWN0aW5nIHBhdGNoZXMgZm9yIHNjc2ksIGJ1dCBKYW1lcyByZW1h
aW5zIGZvcm1hbCBtYWludGFpbmVyLCBzbwpJIGRvbid0IHNlbmQgYW55dGhpbmcgdG8gTGludXMu
ICBHaXZlbiB0aGF0IGRlbGF5cyBiZXR3ZWVuIG1lIGNvbW1pdHRpbmcKdGhpbmdzLCB0aGVtIGdl
dHRpbmcgcGlja2VkIHVwIGJ5IEphbWVzIGFuZCBmaW5hbGx5IG1ha2luZyBpdCB0byBMaW51eC1u
ZXh0IEkKZG9uJ3QgZmVlbCBsaWtlIGFub3RoZXIgZm9yLTMuMTYgYnJhbmNoIGF0IHRoaXMgcG9p
bnQgaXMgZWFzaWx5IHdvcmthYmxlLgoKSWYgSmFtZXMgd2FudHMgdG8gY2hlcnJ5IHBpY2sgaXQg
YW5kIHNlbmQgaXQgb24gYXQgdGhpcyB0aW1lIHRoYXQgbWlnaHQKc3RpbGwgd29yayBmaW5lLCBi
dXQgaGUgc2VlbXMgZmFpcmx5IGJ1c3kuCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprZXJuZWwgbWFpbGluZyBsaXN0Cmtlcm5lbEBsaXN0cy5mZWRvcmFw
cm9qZWN0Lm9yZwpodHRwczovL2FkbWluLmZlZG9yYXByb2plY3Qub3JnL21haWxtYW4vbGlzdGlu
Zm8va2VybmVs
