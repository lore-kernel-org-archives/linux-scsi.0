From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
	kmem_cache_create+0x1a9/0x330()
Date: Fri, 18 Jul 2014 16:17:47 +0200
Message-ID: <20140718141747.GA23272@lst.de>
References: <53C8DF7F.5060707@gmail.com> <53C8FD95.5020302@gmail.com>
	<20140718132104.GK27940@esperanza>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kernel-bounces-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140718132104.GK27940@esperanza>
List-Unsubscribe: <https://admin.fedoraproject.org/mailman/options/kernel>,
	<mailto:kernel-request-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.fedoraproject.org/pipermail/kernel/>
List-Post: <mailto:kernel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
List-Help: <mailto:kernel-request-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org?subject=help>
List-Subscribe: <https://admin.fedoraproject.org/mailman/listinfo/kernel>,
	<mailto:kernel-request-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org?subject=subscribe>
Sender: kernel-bounces-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org
Errors-To: kernel-bounces-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mailing-List fedora-kernel <kernel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>, poma <pomidorabelisima-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <JBottomley-MU7nAjRaF3makBO8gow8eQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCBKdWwgMTgsIDIwMTQgYXQgMDU6MjE6MDRQTSArMDQwMCwgVmxhZGltaXIgRGF2eWRv
diB3cm90ZToKPiBTbGFiIHdhcm5zLCBiZWNhdXNlIHRoZSBuYW1lIG9mIHRoZSBjYWNoZSBiZWlu
ZyBjcmVhdGVkIGNvbnRhaW5zIHNwYWNlcy4KPiBUaGUgImJhZCIgY2FjaGUgaXMgY3JlYXRlZCBi
eSBzY3NpX2dldF9ob3N0X2NtZF9wb29sLiBJdHMgbmFtZQo+IChwb29sLT5jbWRfbmFtZSkgaXMg
aW5pdGlhbGl6ZWQgYnkgc2NzaV9hbGxvY19ob3N0X2NtZF9wb29sIGFzIGZvbGxvd3M6Cj4gCj4g
CXBvb2wtPmNtZF9uYW1lID0ga2FzcHJpbnRmKEdGUF9LRVJORUwsICIlc19jbWQiLCBob3N0dC0+
bmFtZSk7Cj4gCj4gU28sIGlmIGhvc3R0LT5uYW1lIGNvbnRhaW5zIHNwYWNlcywgdGhlIGNhY2hl
IG5hbWUgd2lsbCBhbHNvIGNvbnRhaW4KPiBzcGFjZXMgYW5kIHdlJ2xsIGdldCB0aGUgd2Fybmlu
Zy4gQW5kIGhvc3R0LT5uYW1lIGNhbiBjb250YWluIHNwYWNlcywKPiBlLmcuIHZpcnRzY3NpX2hv
c3RfdGVtcGxhdGVfc2luZ2xlLm5hbWU9IlZpcnRpbyBTQ1NJIEhCQSIuCgpPciBtaWdodCBub3Qg
ZXZlbiBiZSBwcmVzZW50LiAgSSdsbCBzZW5kIGEgcGF0Y2ggdG8gcmVwbGFjZSBpdCB3aXRoCi0+
cHJvY19uYW1lLCB3aGljaCBtdXN0IG5vdCBjb250YWluIHNwYWNlcyBhbmQgaXMgZ2VuZXJhbGx5
IHNob3J0ZXIKYXMgd2VsbC4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmtlcm5lbCBtYWlsaW5nIGxpc3QKa2VybmVsQGxpc3RzLmZlZG9yYXByb2plY3Qu
b3JnCmh0dHBzOi8vYWRtaW4uZmVkb3JhcHJvamVjdC5vcmcvbWFpbG1hbi9saXN0aW5mby9rZXJu
ZWw=
