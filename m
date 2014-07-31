From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
	kmem_cache_create+0x1a9/0x330()
Date: Thu, 31 Jul 2014 17:02:19 +0400
Message-ID: <1406811739.6957.20.camel@jarvis>
References: <53C8DF7F.5060707@gmail.com> <53C8FD95.5020302@gmail.com>
	<20140718132104.GK27940@esperanza> <20140718141747.GA23272@lst.de>
	<53C97D34.5040707@gmail.com>
	<1405714046.30262.10.camel@dabdike.int.hansenpartnership.com>
	<20140719164454.GA24530@lst.de> <53CCDFC3.5010802@gmail.com>
	<20140726162102.GA7126@lst.de> <53D929C3.3040709@cs.wisc.edu>
	<20140730175958.GA30976@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kernel-bounces-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
In-Reply-To: <20140730175958.GA30976-jcswGhMUV9g@public.gmane.org>
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
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mailing-List fedora-kernel <kernel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>, poma <pomidorabelisima-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE0LTA3LTMwIGF0IDE5OjU5ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToKPiBPbiBXZWQsIEp1bCAzMCwgMjAxNCBhdCAxMjoyMjoxMVBNIC0wNTAwLCBNaWtlIENocmlz
dGllIHdyb3RlOgo+ID4gU29tZSBkcml2ZXJzIGxpa2UgcWxhMnh4eCBkbyBub3Qgc2V0IHByb2Nf
bmFtZS4gSSB0aGluayBpZiAyIGRyaXZlcnMKPiA+IGxpa2UgdGhhdCBhcmUgbG9hZGVkIHRoZW4g
eW91IHdpbGwgaGl0IHNvbWUgb3RoZXIgd2FybnMvYnVncyBpbiB0aGUga21lbQo+ID4gY2FjaGUg
c2V0dXAgY29kZSByaWdodD8KPiAKPiBEcml2ZXJzIGhhdmUgdG8gb3B0IGludG8gdXNpbmcgdGhl
aXIgb3duIGNhY2hlcyBieSBzZXR0aW5nIC5jbWRfc2l6ZQo+IGluIHRoZSBob3N0IHRlbXBsYXRl
LiAgV2UgY291bGQgZW5mb3JjZSB0aGV5IHNldCAtPnByb2NfbmFtZSBmb3IgdGhlbSwKPiBidXQg
SSdkIHJhdGhlciBrZWVwIHRoZSBhbW91bnQgb2Ygc2FuaXR5IGNoZWNrcyBsb3cgdW5sZXNzIHRo
ZXJlJ3MgYSByZWFsCj4gbmVlZC4KCk9LLCBzbyBsZXRzIHNlbmQgdGhpcyB0aHJvdWdoIG5vcm1h
bCBtZXJnZSB3aW5kb3cgdGhlbiB3ZSBnZXQgdGltZSB0bwpzZWUgaWYgdGhlcmUncyBhIHByb2Js
ZW0gYmVmb3JlIHRoZSBiYWNrcG9ydCB0byBzdGFibGUgaGFwcGVucy4KCkphbWVzCgoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka2VybmVsIG1haWxpbmcg
bGlzdAprZXJuZWxAbGlzdHMuZmVkb3JhcHJvamVjdC5vcmcKaHR0cHM6Ly9hZG1pbi5mZWRvcmFw
cm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL2tlcm5lbA==
