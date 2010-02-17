From: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech"
	<satyasrinivasp@hcl.in>
Subject: RE: [PATCH] MVSAS: hot plug handling and IO issues
Date: Wed, 17 Feb 2010 12:07:47 +0530
Message-ID: <6B62480106F2B34D8404CF2FDAA4D9EF71F646C0C3@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
 <19942.87.210.74.220.1266327794.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.hcl.in ([203.105.186.28]:41422 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab0BQGiT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 01:38:19 -0500
In-Reply-To: <19942.87.210.74.220.1266327794.squirrel@ketsers.dhs.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <caspar@ketsers.dhs.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, "swmike@swm.pp.se" <swmike@swm.pp.se>, "c.smit@truebit.nl" <c.smit@truebit.nl>


Hi Smit,

This patch can't be combined with the November patch. This patch is based on kernel-2.6.32.7. Yes you need to unpatch all of them and you have to apply freshly.
This is not the combined patch including November patches. My patch addresses the IO issues and tape issues and RAID issues also. 

I can't create a combined patch because after applying the November patches I have faced so many issues. I guess PATCH [6/7] is giving problem with November patches.

--Srini.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Caspar Smit
Sent: Tuesday, February 16, 2010 7:13 PM
To: Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues

Hi Srinivas,

Can this patch be combined with the november patches by Andy Yan?

I patched the 2.6.32.2 kernel with patch 1,2,3,4,5,6 (NOT 7) from the
november patches and now if I try to apply this patch it gives numerous
errors.

Do I need to unpatch any of them or can you create a combined patch or is
this already a combined patch including the november patches?

Kind regards,
Caspar Smit

> From: Srinivas <satyasrinivasp@hcl.in>
> Date: Mon, 15 Feb 2010
> Subject: [PATCH]: Fix for hot plug handling and IO issues.
> 	Added code for handling of hot-plugging drives and tape issues.
>
> Signed-off-by: Srinivas <satyasrinivasp@hcl.in>
> ---
> Thanks
> Srini
>
>
> DISCLAIMER:
> -----------------------------------------------------------------------------------------------------------------------
>
> The contents of this e-mail and any attachment(s) are confidential and
> intended for the named recipient(s) only.
> It shall not attach any liability on the originator or HCL or its
> affiliates. Any views or opinions presented in
> this email are solely those of the author and may not necessarily reflect
> the opinions of HCL or its affiliates.
> Any form of reproduction, dissemination, copying, disclosure,
> modification, distribution and / or publication of
> this message without the prior written consent of the author of this
> e-mail is strictly prohibited. If you have
> received this email in error please delete it and notify the sender
> immediately. Before opening any mail and
> attachments please check them for viruses and defect.
>
> -----------------------------------------------------------------------------------------------------------------------
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

