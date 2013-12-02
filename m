From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V2 4/4] pm80xx: Tasklets synchronization fix.
Date: Mon, 02 Dec 2013 10:49:33 -0800
Message-ID: <1386010173.2018.30.camel@dabdike.int.hansenpartnership.com>
References: <52838071.8010002@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47967 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661Ab3LBStf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2013 13:49:35 -0500
In-Reply-To: <52838071.8010002@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, Sangeetha.Gnanasekaran@pmcs.com, Viswas.G@pmcs.com, Nikith.Ganigarakoppal@pmcs.com

On Wed, 2013-11-13 at 05:36 -0800, Anand wrote:
> >From 9dda7700201be93d4d2b83c2733be3d582859bc7 Mon Sep 17 00:00:00 2001
> From: Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
> Date: Mon, 11 Nov 2013 15:28:14 +0530
> Subject: [PATCH V2 4/4] pm80xx: Tasklets synchronization fix.
> 
> When multiple vectors are used, the vector variable is over written,
> resulting in unhandled operation for those vectors.
> This fix prevents the problem by maitaining HBA instance and
> vector values for each irq.

This has some checkpatch warnings which I fixed:

WARNING: space prohibited before semicolon
#107: FILE: drivers/scsi/pm8001/pm8001_init.c:485:
+               for (j = 0; j < PM8001_MAX_MSIX_VEC ; j++)

WARNING: space prohibited before semicolon
#163: FILE: drivers/scsi/pm8001/pm8001_init.c:934:
+               for (j = 0; j < PM8001_MAX_MSIX_VEC ; j++)

WARNING: space prohibited before semicolon
#193: FILE: drivers/scsi/pm8001/pm8001_init.c:982:
+               for (j = 0; j < PM8001_MAX_MSIX_VEC ; j++)

WARNING: space prohibited before semicolon
#220: FILE: drivers/scsi/pm8001/pm8001_init.c:1051:
+               for (j = 0; j < PM8001_MAX_MSIX_VEC ; j++)

total: 0 errors, 4 warnings, 220 lines checked

Please run the patch through checkpatch before sending it in.

Thanks,

James


