From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
	kmem_cache_create+0x1a9/0x330()
Date: Sat, 26 Jul 2014 18:21:02 +0200
Message-ID: <20140726162102.GA7126@lst.de>
References: <53C8DF7F.5060707@gmail.com> <53C8FD95.5020302@gmail.com>
	<20140718132104.GK27940@esperanza>
	<20140718141747.GA23272@lst.de> <53C97D34.5040707@gmail.com>
	<1405714046.30262.10.camel@dabdike.int.hansenpartnership.com>
	<20140719164454.GA24530@lst.de> <53CCDFC3.5010802@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kernel-bounces-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53CCDFC3.5010802-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://admin.fedoraproject.org/mailman/options/kernel>,
	<mailto:kernel-request-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.fedoraproject.org/pipermail/kernel/>
List-Post: <mailto:kernel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>
List-Help: <mailto:kernel-request-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org?subject=help>
List-Subscribe: <https://admin.fedoraproject.org/mailman/listinfo/kernel>,
	<mailto:kernel-request-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org?subject=subscribe>
Sender: kernel-bounces-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org
Errors-To: kernel-bounces-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org
To: poma <pomidorabelisima-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mailing-List fedora-kernel <kernel-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org>, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

SGVyZSdzIGEgZm9ybWFsIG9uZS4KCkphbWVzLCBjYW4gSSBnZXQgeW91ciBzaWdub2ZmIGZvciBp
dD8KClZsYWRpbWlyLCBjYW4gSSBnZXQgYSByZXZpZXdlZC1ieSBmcm9tIHlvdSAob3IgYW55b25l
IGVsc2UpPwoKLS0tCkZyb20gNzNiMTAzNGFiMTQxOGUyZGVhNzVjY2Y2NDJiYzg1YzcyOGI1NzMx
MyBNb24gU2VwIDE3IDAwOjAwOjAwIDIwMDEKRnJvbTogSmFtZXMgQm90dG9tbGV5IDxKYW1lcy5C
b3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAuY29tPgpEYXRlOiBTYXQsIDI2IEp1bCAyMDE0IDEy
OjIxOjI2IC0wNDAwClN1YmplY3Q6IHNjc2k6IHVzZSBzaG9ydCBkcml2ZXIgbmFtZSBmb3IgcGVy
LWRyaXZlciBjbWQgc2xhYiBjYWNoZXMKCmhvc3R0LT5uYW1lIG1pZ2h0IGNvbnRhaW4gc3BhY2Us
IHNvIHVzZSB0aGUgLT5wcm9jX25hbWUgc2hvcnQgbmFtZSBpbnN0ZWFkCndoZW4gY3JlYXRpbmcg
cGVyLWRyaXZlciBjb21tYW5kIHNsYWJzLgoKUmVwb3J0ZWQtYnk6IFZsYWRpbWlyIERhdnlkb3Yg
PHZkYXZ5ZG92QHBhcmFsbGVscy5jb20+ClRlc3RlZC1ieTogVmxhZGltaXIgRGF2eWRvdiA8dmRh
dnlkb3ZAcGFyYWxsZWxzLmNvbT4KLS0tCiBkcml2ZXJzL3Njc2kvc2NzaS5jIHwgNCArKy0tCiAx
IGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS9zY3NpLmMgYi9kcml2ZXJzL3Njc2kvc2NzaS5jCmluZGV4IDMzMzE4
ZjUuLmRmMzMwNjAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpLmMKKysrIGIvZHJpdmVy
cy9zY3NpL3Njc2kuYwpAQCAtMzY1LDggKzM2NSw4IEBAIHNjc2lfYWxsb2NfaG9zdF9jbWRfcG9v
bChzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCkKIAlpZiAoIXBvb2wpCiAJCXJldHVybiBOVUxMOwog
Ci0JcG9vbC0+Y21kX25hbWUgPSBrYXNwcmludGYoR0ZQX0tFUk5FTCwgIiVzX2NtZCIsIGhvc3R0
LT5uYW1lKTsKLQlwb29sLT5zZW5zZV9uYW1lID0ga2FzcHJpbnRmKEdGUF9LRVJORUwsICIlc19z
ZW5zZSIsIGhvc3R0LT5uYW1lKTsKKwlwb29sLT5jbWRfbmFtZSA9IGthc3ByaW50ZihHRlBfS0VS
TkVMLCAiJXNfY21kIiwgaG9zdHQtPnByb2NfbmFtZSk7CisJcG9vbC0+c2Vuc2VfbmFtZSA9IGth
c3ByaW50ZihHRlBfS0VSTkVMLCAiJXNfc2Vuc2UiLCBob3N0dC0+cHJvY19uYW1lKTsKIAlpZiAo
IXBvb2wtPmNtZF9uYW1lIHx8ICFwb29sLT5zZW5zZV9uYW1lKSB7CiAJCXNjc2lfZnJlZV9ob3N0
X2NtZF9wb29sKHBvb2wpOwogCQlyZXR1cm4gTlVMTDsKLS0gCjEuOS4xCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprZXJuZWwgbWFpbGluZyBsaXN0Cmtl
cm5lbEBsaXN0cy5mZWRvcmFwcm9qZWN0Lm9yZwpodHRwczovL2FkbWluLmZlZG9yYXByb2plY3Qu
b3JnL21haWxtYW4vbGlzdGluZm8va2VybmVs
