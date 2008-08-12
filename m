From: "Grant Grundler" <grundler@google.com>
Subject: [PATCH] 2.6.27-rc2 SCSI Rewrite help text for SCSI_SAS_HOST_SMP
Date: Tue, 12 Aug 2008 14:35:51 -0700
Message-ID: <da824cf30808121435x7782a440v65f919010372e7a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_84641_9746229.1218576951927"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:47772 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbYHLVf7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Aug 2008 17:35:59 -0400
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id m7CLZs4u010735
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 22:35:54 +0100
Received: from rv-out-0506.google.com (rvbf6.prod.google.com [10.140.82.6])
	by zps77.corp.google.com with ESMTP id m7CLZqh3015470
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 14:35:53 -0700
Received: by rv-out-0506.google.com with SMTP id f6so2792743rvb.53
        for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 14:35:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

------=_Part_84641_9746229.1218576951927
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Rewrite libsas/Kconfig help text for SCSI_SAS_HOST_SMP option.
Previous text is useless. Thanks for Martin Petersen (mkp) for pointing
me in the right direction.

Signed-off-By: Grant Grundler <grundler@google.com>

(sorry - patch attached instead of inline because, uhm, gmail white
space mangles patches. Yes, we've complained about it).

New text reads:
+               Allows SAS hosts to receive SAS Management Protocol (SMP)
+               frames.  Selecting this option builds an SMP interpreter
+               into libsas. SMP frames are used to manage SAS expanders
+               and routing of SAS frames.
+
+               For more details see:
+                       http://www.scsita.org/aboutscsi/sas/tutorials.html
+                       http://www.t11.org/ftp/t11/pub/sm/hba/04-373v0.pdf
+
+               Say N here if you want to save the few kb this consumes.

------=_Part_84641_9746229.1218576951927
Content-Type: application/octet-stream;
 name=diff-2.6.27-rc2-libsas_kconfig-01
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjt10kko0
Content-Disposition: attachment; filename=diff-2.6.27-rc2-libsas_kconfig-01

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9saWJzYXMvS2NvbmZpZyBiL2RyaXZlcnMvc2NzaS9s
aWJzYXMvS2NvbmZpZwppbmRleCAxOGYzM2NkLi4wNmZiM2VhIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3Njc2kvbGlic2FzL0tjb25maWcKKysrIGIvZHJpdmVycy9zY3NpL2xpYnNhcy9LY29uZmlnCkBA
IC00Myw5ICs0MywxNiBAQCBjb25maWcgU0NTSV9TQVNfSE9TVF9TTVAKIAlkZWZhdWx0IHkKIAlk
ZXBlbmRzIG9uIFNDU0lfU0FTX0xJQlNBUwogCWhlbHAKLQkJQWxsb3dzIHNhcyBob3N0cyB0byBy
ZWNlaXZlIFNNUCBmcmFtZXMuICBTZWxlY3RpbmcgdGhpcwotCQlvcHRpb24gYnVpbGRzIGFuIFNN
UCBpbnRlcnByZXRlciBpbnRvIGxpYnNhcy4gIFNheQotCQlOIGhlcmUgaWYgeW91IHdhbnQgdG8g
c2F2ZSB0aGUgZmV3IGtiIHRoaXMgY29uc3VtZXMuCisJCUFsbG93cyBTQVMgaG9zdHMgdG8gcmVj
ZWl2ZSBTQVMgTWFuYWdlbWVudCBQcm90b2NvbCAoU01QKQorCQlmcmFtZXMuICBTZWxlY3Rpbmcg
dGhpcyBvcHRpb24gYnVpbGRzIGFuIFNNUCBpbnRlcnByZXRlcgorCQlpbnRvIGxpYnNhcy4gU01Q
IGZyYW1lcyBhcmUgdXNlZCB0byBtYW5hZ2UgU0FTIGV4cGFuZGVycworCQlhbmQgcm91dGluZyBv
ZiBTQVMgZnJhbWVzLgorCisJCUZvciBtb3JlIGRldGFpbHMgc2VlOgorCQkJaHR0cDovL3d3dy5z
Y3NpdGEub3JnL2Fib3V0c2NzaS9zYXMvdHV0b3JpYWxzLmh0bWwKKwkJCWh0dHA6Ly93d3cudDEx
Lm9yZy9mdHAvdDExL3B1Yi9zbS9oYmEvMDQtMzczdjAucGRmCisKKwkJU2F5IE4gaGVyZSBpZiB5
b3Ugd2FudCB0byBzYXZlIHRoZSBmZXcga2IgdGhpcyBjb25zdW1lcy4KIAogY29uZmlnIFNDU0lf
U0FTX0xJQlNBU19ERUJVRwogCWJvb2wgIkNvbXBpbGUgdGhlIFNBUyBEb21haW4gVHJhbnNwb3J0
IEF0dHJpYnV0ZXMgaW4gZGVidWcgbW9kZSIK
------=_Part_84641_9746229.1218576951927--
