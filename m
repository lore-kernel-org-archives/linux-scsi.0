From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH 6/10][RFC] linux-iscsi driver
Date: Wed, 12 Jan 2005 15:59:20 -0800
Message-ID: <1105574360.21043.8.camel@markh1.pdx.osdl.net>
References: <41E30958.5060309@cs.wisc.edu>
	 <1105569717.21043.3.camel@markh1.pdx.osdl.net>
	 <41E5AB40.2050904@us.ibm.com>
	 <1105570966.21043.6.camel@markh1.pdx.osdl.net>
	 <41E5B12C.2030802@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:22249 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S261310AbVALX71 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 18:59:27 -0500
In-Reply-To: <41E5B12C.2030802@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2005-01-12 at 15:22 -0800, Mike Christie wrote:
> Mark Haverkamp wrote:
> > On Wed, 2005-01-12 at 14:57 -0800, Mike Christie wrote:
> > 
> >>Mark Haverkamp wrote:
> >>
> >>>On Mon, 2005-01-10 at 15:01 -0800, Mike Christie wrote:
> >>>
> >>>
> >>>>The attached patch implememts the IO functions for
> >>>>the driver. They are built upon the network
> >>>>subsystem's socket functions, so any ideas about
> >>>>how to handle OOM situations when using that
> >>>>layer would be greatly appreciated.
> >>>
> >>>
> >>>I get:
> >>>
> >>>  BUILD   arch/i386/boot/bzImage
> >>>Root device is (3, 3)
> >>>Boot sector 512 bytes.
> >>>Setup is 5215 bytes.
> >>>System is 2530 kB
> >>>Kernel: arch/i386/boot/bzImage is ready
> >>>  Building modules, stage 2.
> >>>  MODPOST
> >>>*** Warning: "__scsi_print_sense" [drivers/scsi/iscsi-sfnet/iscsi_sfnet.ko] undefined!
> >>>
> >>>
> >>>when building the iscsi module in the latest kernel BK view.
> >>>
> >>>
> >>
> >>just to make sure, when you open drivers/scsi/constants.c
> >>you see
> >>EXPORT_SYMBOL(__scsi_print_sense);
> >>right?
> > 
> > 
> > I don't see __scsi_print_sense in constants.c, just scsi_print_sense and
> > it has a different arg list than your usage of __scsi_print_sense.
> > 
>   > Mark.
> > 
> 
> In the newest constants.c in scsi-misc it looks like it is there
> http://linux-scsi.bkbits.net:8080/scsi-misc-2.6/anno/drivers/scsi/constants.c@1.22?nav=index.html|src/|src/drivers|src/drivers/scsi
> 
> Same for http://linux.bkbits.net:8080/linux-2.5
> http://linux.bkbits.net:8080/linux-2.5/anno/drivers/scsi/constants.c@1.22?nav=index.html|src/|src/drivers|src/drivers/scsi
> 

Sorry, for the trouble, I was one rev back on constants.c.

Mark.

-- 
Mark Haverkamp <markh@osdl.org>

