From: "Anand Kumar Santhanam" <AnandKumar.Santhanam@pmcs.com>
Subject: RE: [PATCH V3 02/12] pm80xx: Added SPCv/ve specific ids, variables and modify for SPC
Date: Wed, 10 Apr 2013 23:36:40 -0700
Message-ID: <E5DEE6F468524847995699AD11E8088501700991@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <5149F023.6060204@pmc-sierra.com> <1365621636.1942.5.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:53312 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870Ab3DKGgs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Apr 2013 02:36:48 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1365621636.1942.5.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, sakthivel.sk@hcl.com, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>, xjtuwjp@gmail.com, Vishwanath Maram <Vishwanath.Maram@pmcs.com>

Hi James,

Did you take the patch attachment from the email? Pls let us know as to
which version of diff tool you are using.
I used the patch command to apply this patch against 3.8-rc6 tree to
check whether the patch is applying properly.

Regards
Anand

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Thursday, April 11, 2013 12:51 AM
To: Anand Kumar Santhanam
Cc: linux-scsi@vger.kernel.org; Harry Yang; Rich Bono;
sakthivel.sk@hcl.com; Sangeetha Gnanasekaran; xjtuwjp@gmail.com;
Vishwanath Maram
Subject: Re: [PATCH V3 02/12] pm80xx: Added SPCv/ve specific ids,
variables and modify for SPC

On Wed, 2013-03-20 at 10:21 -0700, Anand wrote:
> >From ef678e2188866af926f2a089719c24ec99e4e88c Mon Sep 17 00:00:00 
> >2001
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Wed, 27 Feb 2013 20:22:50 +0530
> Subject: [PATCH V3 02/12] pm80xx: Added SPCv/ve specific ids, 
> variables and modify for SPC
> 
> Updated pci id table with device, vendor, subdevice and subvendor ids 
> for 8081, 8088, 8089 SAS/SATA controllers. Added SPCv/ve related
macros.
> Updated macros, hba info structure and other structures for SPCv/ve.
> Update of structure and variable names for SPC hardware
functionalities.
> 
> Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
> Ack-by: Jack Wang <jack_wang@usish.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c  |   69 ++++++++++---
>  drivers/scsi/pm8001/pm8001_defs.h |   19 +++-
>  drivers/scsi/pm8001/pm8001_hwi.c  |  210 
> ++++++++++++++++++++++---------------

neither git nor diffstat on the patch agrees with this ... they both
think 212 lines changed.  Please fix the diff tool you're using.

Thanks,

James


