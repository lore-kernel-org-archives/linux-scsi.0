From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: merge megaraid 2.20.x in kernel 2.6?
Date: Thu, 26 Aug 2004 18:03:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC9B7@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62115 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S269713AbUHZWEE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 18:04:04 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>, Matt Domsch <Matt_Domsch@Dell.com>, "Mukker, Atul" <Atulm@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James,

I have released the 2.20.3.1 drive, which should fix this issue. Did you get
a chance to merge that driver?

Thanks
-Atul

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Tuesday, August 17, 2004 12:41 PM
> To: Matt Domsch; atulm@lsil.com
> Cc: SCSI Mailing List
> Subject: Re: merge megaraid 2.20.x in kernel 2.6?
> 
> 
> On Tue, 2004-08-17 at 12:01, Matt Domsch wrote:
> > James, is there anything you're still waiting on before merging the
> > LSI megaraid 2.20.x driver into your scsi-misc-2.6 tree?  I thought
> > the agreement by you, Christoph, and Atul was to get it merged, and
> > then fix up the few outstanding concerns post-merge.
> 
> OK, I forgot in the rush of conferences.
> 
> I did put it in, but it fails to compile on parisc:
> 
> In file included from drivers/scsi/megaraid/megaraid_mm.c:18:
> drivers/scsi/megaraid/megaraid_mm.h:51:25: asm/ioctl32.h: No such file
> or directory
> drivers/scsi/megaraid/megaraid_mm.c: In function `mraid_mm_init':
> drivers/scsi/megaraid/megaraid_mm.c:1069: warning: implicit 
> declaration
> of function `register_ioctl32_conversion'
> drivers/scsi/megaraid/megaraid_mm.c: In function `mraid_mm_exit':
> drivers/scsi/megaraid/megaraid_mm.c:1098: warning: implicit 
> declaration
> of function `unregister_ioctl32_conversion'
> make[3]: *** [drivers/scsi/megaraid/megaraid_mm.o] Error 1
> make[2]: *** [drivers/scsi/megaraid] Error 2
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2
> 
> It looks like the compat ioctl infrastructure is incorrect.
> 
> James
> 
> 
