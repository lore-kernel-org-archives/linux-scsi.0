From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: [RFC] qla4xxx: TODO for re-submission
Date: Mon, 12 Jun 2006 09:49:34 -0700
Message-ID: <20060612164934.GA7576@ranandlinuxbox.oc.cox.net>
References: <8889.1149988615@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:34428 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751316AbWFLQtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jun 2006 12:49:23 -0400
Content-Disposition: inline
In-Reply-To: <8889.1149988615@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@bebe.enoyolf.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, David Somayajulu <davidcs2005@gmail.com>, Duane Grigsby <duane.grigsby@qlogic.com>, linux-scsi@vger.kernel.org, dwm@austin.ibm.com

>On Sat, 10 Jun 2006, Doug Maxey wrote:
> 
> Subject: [RFC] qla4xxx: TODO for re-submission
> 
> Howdy!
> 
> The qla4xxx driver for the QLogic ISP4XXX chipset will be getting a
> little janitorial love along the lines of:
> 
> A) a rework of the 2006-06-06 Qlogic submitted qla4xxx code to get the
>    driver to be in line with the kernel coding style.
     
     Agreed. There are some cleanup's that still need to be done.
     If you have the patch please forward it over.
		
> B) being made more compliant with the scsi_mid_low_api.txt.
    
     OK. Whats the missing piece ? 
	
>    Being compiled for M$ does not count as an alternative OS. :)  In
>    particular, move all the code to single .c file.  If and when
>    another chipset comes along that can utilize some of the bits, look
>    into splitting it back up.
    
     Layout of the file is pretty intutive and we would like to it
     pretty much inline like the qla2xxx FC driver. 
     Anyway this is very low down the priroity. Getting the other
     items done which you have outlined below is more important.	

> C) removal of unreachable or unused code.
     Agreed.

> D) a rework of the function layout and size, including linewidth adjustments

     Patch would help to understand.

> E) fixups to printk formatting, and moving to dev_printk().  For the
>    first pass, just remove the debug printk()'s

     Agreed. 
> 
> This will not be a re-write of the driver per se, just a refactoring
> going on in parallel to the work of the QLogic folks and mike, in an
> effort to get this driver into mainline.
> 
> The plan is to:
> 1) submit the Documentation/LICENSE.qla4xxx.txt file and check
>    the provenance with the original submitters..
      
     We already submitted it. Will be updating it most probably.    

> 2) pull all the data structs into the file, swizzle the types to be
>    kernel compliant.
     OK.

> 3) pull the core driver initialization (module_init(), pci init et al)
>    into the file drivers/scsi/qla4xxx.c
     Same as outlined in  B.

> 4) add the iscsi transport code.
> 5) add the block layer code.

     In my mind item 4 & 5 are the important one's that we need to accomplish.
     Mike I believe has done some of the modifications in the latest patch
     set which he send out recently on open-iscsi reflector.
> 6) add the device firmware access.
     
     Not sure about this.

> 7) add the hooks for the Kconfig and Makefile
> 
    In one of the later patches we did update the top level Makefile and Kconfig.

> Does this appear to be a workable plan?  Should the struct cleanup
> wait and come in on an as needed basis?

  Yes, it is. Prioritising the work is important. Broadly speaking item 4 & 5 are the imporantant
  ones as well cleaning up the code to be more compliant with the linux style.

  Apart from what David Somayajulu is working on, there are other stuff which we need to do
  on the driver side. Important piece is the sysfs stuff which I am working on.

  If you can takeup the item 4 & 5 that would be great. Cleanup part let me know what part 
  want to do  and I can do the rest.
  
> 
> All comments will be appreciated.
> 

Thanx for putting it together.

Ravi
