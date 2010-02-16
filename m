From: "Caspar Smit" <caspar@ketsers.dhs.org>
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
Date: Tue, 16 Feb 2010 14:43:14 +0100 (CET)
Message-ID: <19942.87.210.74.220.1266327794.squirrel@ketsers.dhs.org>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:38133 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab0BPNnX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Feb 2010 08:43:23 -0500
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.H
     CL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

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

