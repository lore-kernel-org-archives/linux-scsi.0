From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [Bug 3244] New: megaraid_mbox.c broken: unimplemented parts
Date: Thu, 19 Aug 2004 17:09:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC97E@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:25794 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S267401AbUHSVJz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 17:09:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Morton' <akpm@osdl.org>, linux-scsi@vger.kernel.org

Is this something specific to gcc 3.4.1. I do not see any such issue with
3.3.3 (this driver was tested on IA32, x86-64, and Itenium). Would, what
Matt Domsch mentioned in his post on 7/27 "Re: [ANNOUNCE]: megaraid driver
version 2.20.0.1, now 2.20.2.0" help. He talked about defining the inline
function before they are actually used.

Thanks
-Atul Mukker

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@osdl.org]
> Sent: Thursday, August 19, 2004 12:22 PM
> To: linux-scsi@vger.kernel.org
> Subject: Fw: [Bug 3244] New: megaraid_mbox.c broken: 
> unimplemented parts
> 
> 
> 
> 
> Begin forwarded message:
> 
> Date: Thu, 19 Aug 2004 05:11:37 -0700
> From: bugme-daemon@osdl.org
> To: akpm@digeo.com
> Subject: [Bug 3244] New: megaraid_mbox.c broken: unimplemented parts
> 
> 
> http://bugme.osdl.org/show_bug.cgi?id=3244
> 
>            Summary: megaraid_mbox.c broken: unimplemented parts
>     Kernel Version: 2.6.8.1-mm2
>             Status: NEW
>           Severity: high
>              Owner: akpm@digeo.com
>          Submitter: damir.perisa@bluewin.ch
> 
> 
> Distribution: ArchLinux CURRENT 
> (i'm the pkg maintainer of kernel26mm) 
>  
> Hardware Environment: P4 
>  
> Software Environment: gcc 3.4.1 
>  
> Problem Description:  
>  
>   LD      drivers/scsi/megaraid/built-in.o 
>   CC [M]  drivers/scsi/megaraid/megaraid_mbox.o 
> drivers/scsi/megaraid/megaraid_mbox.c: In function 
> `megaraid_queue_command': 
> drivers/scsi/megaraid/megaraid_mbox.c:112: sorry, 
> unimplemented: inlining 
> failed in call to 'megaraid_mbox_build_cmd': function body 
> not available 
> drivers/scsi/megaraid/megaraid_mbox.c:1455: sorry, 
> unimplemented: called from 
> here 
> drivers/scsi/megaraid/megaraid_mbox.c:121: sorry, 
> unimplemented: inlining 
> failed in call to 'megaraid_mbox_runpendq': function body not 
> available 
> drivers/scsi/megaraid/megaraid_mbox.c:1458: sorry, 
> unimplemented: called from 
> here 
> make[3]: *** [drivers/scsi/megaraid/megaraid_mbox.o] Error 1 
> make[2]: *** [drivers/scsi/megaraid] Error 2 
> make[1]: *** [drivers/scsi] Error 2 
> make: *** [drivers] Error 2 
> ==> ERROR: Build Failed.  Aborting... 
>  
> Steps to reproduce: 
> 1) try to compile this as module 
> 2) watch it failing
> 
> ------- You are receiving this mail because: -------
> You are the assignee for the bug, or are watching the assignee.
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
