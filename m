From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 0/3] xen-scsiback: Fine-tuning for
	scsiback_device_action()
Date: Wed, 20 Jul 2016 13:27:01 +0200
Message-ID: <6863b12b-9095-aaf3-6140-80968e0071e2@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <59e51c7d-f7bb-c55f-d2fe-06dccfef6a99@users.sourceforge.net>
 <87e55a72-71ad-d0a1-b936-12565bbc6508@users.sourceforge.net>
 <fb5824ad-fb09-e471-7dc4-3e32564cc334@suse.com>
 <8806e9cb-4200-8154-7914-6735805dfbe0@users.sourceforge.net>
 <83b0b1e2-900b-eefc-160b-7d837730571c@suse.com>
 <18256bfc-c6f9-8802-8d7d-55766f0b3624@users.sourceforge.net>
 <85b948e0-bf37-dff0-6792-77b5dacef9a0@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <85b948e0-bf37-dff0-6792-77b5dacef9a0@suse.com>
List-Unsubscribe: <https://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <https://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xen.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xen.org>
To: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>, David Vrabel <david.vrabel@citrix.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

RnJvbTogTWFya3VzIEVsZnJpbmcgPGVsZnJpbmdAdXNlcnMuc291cmNlZm9yZ2UubmV0PgpEYXRl
OiBXZWQsIDIwIEp1bCAyMDE2IDEzOjIwOjA0ICswMjAwCgpGdXJ0aGVyIHVwZGF0ZSBzdWdnZXN0
aW9ucyB3ZXJlIHRha2VuIGludG8gYWNjb3VudAphZnRlciBhIHBhdGNoIHdhcyBhcHBsaWVkIGZy
b20gc3RhdGljIHNvdXJjZSBjb2RlIGFuYWx5c2lzLgoKTWFya3VzIEVsZnJpbmcgKDMpOgogIERl
bGV0ZSBhbiB1bm5lY2Vzc2FyeSBjaGVjayBiZWZvcmUgdGhlIGZ1bmN0aW9uIGNhbGwgImtmcmVl
IgogIFJlbmFtZSBqdW1wIGxhYmVscyBpbiBzY3NpYmFja19kZXZpY2VfYWN0aW9uKCkKICBQYXNz
IGEgZmFpbHVyZSBpbmRpY2F0aW9uIGFzIGEgY29uc3RhbnQKCiBkcml2ZXJzL3hlbi94ZW4tc2Nz
aWJhY2suYyB8IDE5ICsrKysrKysrKy0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2Vy
dGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQoKLS0gCjIuOS4yCgoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVsIG1haWxpbmcgbGlzdApYZW4t
ZGV2ZWxAbGlzdHMueGVuLm9yZwpodHRwczovL2xpc3RzLnhlbi5vcmcveGVuLWRldmVsCg==
