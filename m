From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [PATCH 1/5] scsi: megaraid_sas - stop cmd processing if hw_crit_error is set
Date: Wed, 7 Feb 2007 19:59:36 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E82298ED5D7@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36421 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933346AbXBHC7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 21:59:46 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

I will correct the formatting and will resubmit.

Regards,
Sumant 

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Wednesday, February 07, 2007 1:18 PM
To: Patro, Sumant
Cc: James.Bottomley@SteelEye.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; Kolli, Neela; Yang, Bo; Patro, Sumant
Subject: Re: [PATCH 1/5] scsi: megaraid_sas - stop cmd processing if
hw_crit_error is set

On Tue, 06 Feb 2007 13:49:24 -0800
Sumant Patro <sumantp@lsil.com> wrote:

> +	/* Don't process if we have already declared adapter dead */
> +	if(instance->hw_crit_error)

Preferred kernel coding style is "if (".

> [p1-crit_err.patch  text/x-patch (1.3KB)]

argh.  Please don't send two copies of the patch in the email.  Because
the result applies happily with `patch --dry-run' and then creates a
great mess when you try to apply the patch for real.

