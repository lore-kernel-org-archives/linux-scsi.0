From: "Grant Grundler" <grundler@google.com>
Subject: Re: [PATCH] 2.6.27-rc2 SCSI Rewrite help text for SCSI_SAS_HOST_SMP
Date: Tue, 12 Aug 2008 15:34:38 -0700
Message-ID: <da824cf30808121534x14cf667p6fc3761fe0b7f13f@mail.gmail.com>
References: <da824cf30808121435x7782a440v65f919010372e7a8@mail.gmail.com>
	 <1218577607.3549.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_85657_864245.1218580478734"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:58485 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbYHLWes (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Aug 2008 18:34:48 -0400
Received: from zps36.corp.google.com (zps36.corp.google.com [172.25.146.36])
	by smtp-out.google.com with ESMTP id m7CMYdeq013165
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 23:34:40 +0100
Received: from rv-out-0708.google.com (rvbf25.prod.google.com [10.140.82.25])
	by zps36.corp.google.com with ESMTP id m7CMYQ15005878
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 15:34:39 -0700
Received: by rv-out-0708.google.com with SMTP id f25so2772672rvb.26
        for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 15:34:39 -0700 (PDT)
In-Reply-To: <1218577607.3549.57.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

------=_Part_85657_864245.1218580478734
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Aug 12, 2008 at 2:46 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
...
> Actually, you're making it less clear.

Sorry - I've rewritten it to reflect your take on it.

>
> What this option is doing is allowing the smp utilities to send SMP
> frames to interrogate the HBA.  Setting (or not setting) this option has
> no effect on the SAS expanders.  Essentially, it allows the HBA ports to
> be treated the same as the expander ports from the point of view of a
> software management tool.

Word smithed so it N=now reads:
+               Selecting this option builds an SMP interpreter into libsas.
+               This allows SAS Management Protocol (SMP) utilities to send
+               SMP frames to interrogate the HBA. Essentially, this allows
+               SMP utilities to treat HBA ports the same as SAS Expander
+               Ports.
+
+               For more details on the Management Upper Layer see:
+                       http://www.scsita.org/aboutscsi/sas/tutorials.html
+
+               Say N here if you want to save the few kb this consumes.

Attached as a patch file again but I can re-send in proper format if you prefer.

>
>> +               For more details see:
>> +                       http://www.scsita.org/aboutscsi/sas/tutorials.html
>
> It's not the whole of this, just the Management upper layer.
>
>> +                       http://www.t11.org/ftp/t11/pub/sm/hba/04-373v0.pdf
>
> This latter one is the HBA API ... it's not really anything to do with
> SMP.

*nod* dropped the second URL.

thanks,
grant

------=_Part_85657_864245.1218580478734
Content-Type: application/octet-stream;
 name=diff-2.6.27-rc2-libsas_kconfig-02
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjt2z66p0
Content-Disposition: attachment; filename=diff-2.6.27-rc2-libsas_kconfig-02

LS0tIGEvZHJpdmVycy9zY3NpL2xpYnNhcy9LY29uZmlnCisrKyBiL2RyaXZlcnMvc2NzaS9saWJz
YXMvS2NvbmZpZwpAQCAtNDMsOSArNDMsMTYgQEAgY29uZmlnIFNDU0lfU0FTX0hPU1RfU01QCiAJ
ZGVmYXVsdCB5CiAJZGVwZW5kcyBvbiBTQ1NJX1NBU19MSUJTQVMKIAloZWxwCi0JCUFsbG93cyBz
YXMgaG9zdHMgdG8gcmVjZWl2ZSBTTVAgZnJhbWVzLiAgU2VsZWN0aW5nIHRoaXMKLQkJb3B0aW9u
IGJ1aWxkcyBhbiBTTVAgaW50ZXJwcmV0ZXIgaW50byBsaWJzYXMuICBTYXkKLQkJTiBoZXJlIGlm
IHlvdSB3YW50IHRvIHNhdmUgdGhlIGZldyBrYiB0aGlzIGNvbnN1bWVzLgorCQlTZWxlY3Rpbmcg
dGhpcyBvcHRpb24gYnVpbGRzIGFuIFNNUCBpbnRlcnByZXRlciBpbnRvIGxpYnNhcy4KKwkJVGhp
cyBhbGxvd3MgU0FTIE1hbmFnZW1lbnQgUHJvdG9jb2wgKFNNUCkgdXRpbGl0aWVzIHRvIHNlbmQK
KwkJU01QIGZyYW1lcyB0byBpbnRlcnJvZ2F0ZSB0aGUgSEJBLiBFc3NlbnRpYWxseSwgdGhpcyBh
bGxvd3MKKwkJU01QIHV0aWxpdGllcyB0byB0cmVhdCBIQkEgcG9ydHMgdGhlIHNhbWUgYXMgU0FT
IEV4cGFuZGVyCisJCVBvcnRzLgorCisJCUZvciBtb3JlIGRldGFpbHMgb24gdGhlIE1hbmFnZW1l
bnQgVXBwZXIgTGF5ZXIgc2VlOgorCQkJaHR0cDovL3d3dy5zY3NpdGEub3JnL2Fib3V0c2NzaS9z
YXMvdHV0b3JpYWxzLmh0bWwKKworCQlTYXkgTiBoZXJlIGlmIHlvdSB3YW50IHRvIHNhdmUgdGhl
IGZldyBrYiB0aGlzIGNvbnN1bWVzLgogCiBjb25maWcgU0NTSV9TQVNfTElCU0FTX0RFQlVHCiAJ
Ym9vbCAiQ29tcGlsZSB0aGUgU0FTIERvbWFpbiBUcmFuc3BvcnQgQXR0cmlidXRlcyBpbiBkZWJ1
ZyBtb2RlIgo=
------=_Part_85657_864245.1218580478734--
