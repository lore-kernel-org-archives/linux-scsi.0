From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V3 02/12] pm80xx: Added SPCv/ve specific ids, variables
 and modify for SPC
Date: Wed, 10 Apr 2013 12:20:36 -0700
Message-ID: <1365621636.1942.5.camel@dabdike>
References: <5149F023.6060204@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39773 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932799Ab3DJTUi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Apr 2013 15:20:38 -0400
In-Reply-To: <5149F023.6060204@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, Harry.Yang@pmcs.com, rich.Bono@pmcs.com, sakthivel.sk@hcl.com, Sangeetha.Gnanasekaran@pmcs.com, xjtuwjp@gmail.com, Vishwanath.Maram@pmcs.com

On Wed, 2013-03-20 at 10:21 -0700, Anand wrote:
> >From ef678e2188866af926f2a089719c24ec99e4e88c Mon Sep 17 00:00:00 2001
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Wed, 27 Feb 2013 20:22:50 +0530
> Subject: [PATCH V3 02/12] pm80xx: Added SPCv/ve specific ids, variables and modify for SPC
> 
> Updated pci id table with device, vendor, subdevice and subvendor ids
> for 8081, 8088, 8089 SAS/SATA controllers. Added SPCv/ve related macros.
> Updated macros, hba info structure and other structures for SPCv/ve.
> Update of structure and variable names for SPC hardware functionalities.
> 
> Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
> Ack-by: Jack Wang <jack_wang@usish.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c  |   69 ++++++++++---
>  drivers/scsi/pm8001/pm8001_defs.h |   19 +++-
>  drivers/scsi/pm8001/pm8001_hwi.c  |  210 ++++++++++++++++++++++---------------

neither git nor diffstat on the patch agrees with this ... they both
think 212 lines changed.  Please fix the diff tool you're using.

Thanks,

James


