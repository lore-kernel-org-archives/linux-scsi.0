From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 5/5] scsi: megaraid_sas - Version and documentation update
Date: Wed, 27 Oct 2010 13:54:05 +0200
Message-ID: <4CC812DD.9050608@redhat.com>
References: <AANLkTi=praySm1B3dhU+LxhWK2yUccZkzWpd6-6UERYa@mail.gmail.com>	 <4B6A08C587958942AA3002690DD4F8C30100FF9FBB@cosmail02.lsi.com> <1288109543.8283.139.camel@mulgrave.site> <4B6A08C587958942AA3002690DD4F8C3010119E798@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757702Ab0J0Lyy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2010 07:54:54 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3010119E798@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: James Bottomley <James.Bottomley@suse.de>, bo yang <boyang1288@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 10/26/2010 07:15 PM, Yang, Bo wrote:
> James,
>
> Thanks for correcting that. Did you also applied 2/5, 3/5 and 4/5 pat=
ches?
>
> By the way, I always use checkpatch.pl to check the patch before I at=
tach the patch to the e-mail.  Also I just went to the 5/5 patch to ver=
ify the patch: the steps:
>
> 1. go to  http://marc.info/?l=3Dlinux-scsi&m=3D128688974201201&w=3D2
>  =20
Looking carefully at the above page (select the text) you can see the t=
railing whitespaces
directly on that page.=20

> 2. click: ["megasas-version.patch" (application/octet-stream)] to dow=
nload this patch. =20
> 3. Used the checkpatch.pl to check (I used the cmd: "checkpatch.pl --=
no-tree megasas-version.patch")=20
>  =20

> It looks OK for me (no errors).  It is maybe the checkpatch.pl I used=
 does not get updated or some steps are not correct.  I will find out t=
he updated one to try and find out the reasons.  =20
>  =20
Use the checkpatch.pl from the scripts directory


>
> Thanks,
>
> Bo Yang
>
>
> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@suse.de]=20
> Sent: Tuesday, October 26, 2010 12:12 PM
> To: Yang, Bo
> Cc: bo yang; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@=
vger.kernel.org
> Subject: Re: [PATCH 5/5] scsi: megaraid_sas - Version and documentati=
on update
>
> On Tue, 2010-10-12 at 07:21 -0600, Yang, Bo wrote:
>  =20
>> Re-Submit:
>>
>> Update the version and documentation.
>>    =20
> This has an impressive set of checkpatch failures:
>
> ERROR: trailing whitespace
> #26: FILE: Documentation/scsi/ChangeLog.megaraid_sas:13:
> +^ITo add the OCR support, driver need to do: $
>
> ERROR: trailing whitespace
> #30: FILE: Documentation/scsi/ChangeLog.megaraid_sas:17:
> +^I^I$
>
> ERROR: trailing whitespace
> #35: FILE: Documentation/scsi/ChangeLog.megaraid_sas:22:
> +^I^I$
>
> ERROR: trailing whitespace
> #39: FILE: Documentation/scsi/ChangeLog.megaraid_sas:26:
> +^I^I$
>
> ERROR: trailing whitespace
> #43: FILE: Documentation/scsi/ChangeLog.megaraid_sas:30:
> +^I^I$
>
> ERROR: trailing whitespace
> #46: FILE: Documentation/scsi/ChangeLog.megaraid_sas:33:
> +^I^I $
>
> ERROR: trailing whitespace
> #48: FILE: Documentation/scsi/ChangeLog.megaraid_sas:35:
> +^I^IOCR to see if driver can bring back the FW.      $
>
> ERROR: trailing whitespace
> #54: FILE: Documentation/scsi/ChangeLog.megaraid_sas:41:
> +3.^IIn driver's timeout routine, driver will do three time reset if =
fw
> is in $
>
> total: 8 errors, 0 warnings, 70 lines checked
>
> I've fixed it up this time, but could you run it through checkpatch.p=
l
> next time?
>
> Thanks,
>
> James
>
>
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD"=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=
=BF=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD=
z=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=BF=BD=
=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=
=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
