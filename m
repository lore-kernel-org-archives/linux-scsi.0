From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: [PATCH] 2.4.27 add device to scsi_scan.c's blacklist
Date: Wed, 11 Aug 2004 18:40:04 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040811214004.GA4856@dmt.cyclades>
References: <47F3C2BE74738E4683574107469DFA204CCC5F@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:39366 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268244AbUHKVg6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 17:36:58 -0400
Content-Disposition: inline
In-Reply-To: <47F3C2BE74738E4683574107469DFA204CCC5F@XYUSEX01.xyus.xyratex.com>
List-Id: linux-scsi@vger.kernel.org
To: Frank Borich <Frank_Borich@us.xyratex.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, David Lethe <David_Lethe@us.xyratex.com>

Frank,

This patch has never reached me -- I've seen it on 
linux-scsi yesterday, and I was going to apply. 

If you need to get patches accepted in v2.4, please mail them to me 
directly.

To make sure 2.6.x patches get accepted, mail them directly
to James (the current SCSI maintainer on v2.6).

Thanks for the patch - I'll apply it later today!

On Wed, Aug 11, 2004 at 12:57:07PM -0700, Frank Borich wrote:
> 
> Hi,
> 
> I have submitted this patch several times to the 2.4.x tree.  It keeps
> getting dropped silently.  This is my first time submitting a patch,
> so can someone kindly let me know if I am doing something wrong? I have
> followed the instructions at
> http://www.kernel.org/pub/linux/docs/lkml/#s4-1.  
> Any advice would be greatly appreciated.  The patch simply adds our
> FC-SATA 
> RAID to scsi_scan.c's blacklist.  
> 
> 
> --- linux-2.4.27/drivers/scsi/scsi_scan.c       2004-08-11
> 14:42:12.000000000 -0500
> +++ linux-2.4.27.changed/drivers/scsi/scsi_scan.c       2004-08-11
> 14:43:34.000000000 -0500
> @@ -208,6 +208,7 @@
>         {"SMSC", "USB 2 HS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
>         {"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
>         {"NEC", "iStorage", "*", BLIST_SPARSELUN | BLIST_LARGELUN |
> BLIST_FORCELUN},
> +       {"Xyratex", "4200", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> 
>         /*
>          * Must be at end of list...
> 
> 
> Thanks in Advance,
> 
> Frank Borich
> ------------------------------------------------------------------
> Xyratex Inc.
> Systems Engineer
> Direct 630 654 6089
> Fax 630 325 2513
> e-mail frank_borich@us.xyratex.com
>  
