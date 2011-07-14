From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/3] qla2xxx: Updates for scsi misc 3.0.
Date: Thu, 14 Jul 2011 12:37:36 -0500
Message-ID: <1310665056.15805.2.camel@mulgrave>
References: <CA4476B1.21CBD%giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51056 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932169Ab1GNRhj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2011 13:37:39 -0400
In-Reply-To: <CA4476B1.21CBD%giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2011-07-14 at 10:36 -0700, Giridhar Malavali wrote:
> 
> >>
> 
> >On Thu, 2011-07-14 at 10:07 -0700, giridhar.malavali@qlogic.com wrote:
> >> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
> >> 
> >> James,
> >> 
> >> Please apply these patches.
> >> 
> >> The patch 1/3 has couple of warnings w.r.t KERN_facility level with
> >>printk.
> >> 
> >> WARNING: printk() should include KERN_ facility level
> >> 
> >> Using KERN facility in printk will print each buffer information in new
> >>line causing
> >> unreadable log messages.
> >> 
> >> Here is an example
> >> 
> >> With KERN facility
> >> Mar 23 10:05:37 linux-dcaw kernel: qla2xxx [0000:18:00.6]4:1102:
> >> Mar 23 10:05:37 linux-dcaw kernel: 42
> >> Mar 23 10:05:37 linux-dcaw kernel:
> >> Mar 23 10:05:37 linux-dcaw kernel: 00
> >> 
> >> Without KERN facility
> >> Mar 21 13:07:35 linux-dcaw kernel: qla2xxx [0000:18:00.7]37:1102: 48
> >>00  00  00  5b  f2  00
> >> 
> >> Hope this should be fine since this is not an error.
> >> 
> >> -- Giridhar
> >> Saurav Kashyap (3):
> >>   qla2xxx: Basic infrastructure for dynamic logging.
> >>   qla2xxx: Code changes to support new dynamic logging infrastructure.
> >
> >This patch is missing (for the second time).  It's either too big or is
> >getting caught in vger's spam filters somehow.
> 
> Thanks for the information. I will resubmit the patches breaking them
> further. I think the patch is too big.

OK, our limit is somewhere around 200k I think.  Just split it into
2a,2b etc ... don't worry about bisectability, I'll recombine them all
on import.

James


