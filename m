From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: RE: [PATCH] 2.5 ips.c pci_module_init
Date: Fri, 17 Jan 2003 12:45:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B03772C@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "'andmike@us.ibm.com'" <andmike@us.ibm.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

I have no problem with Mike's patch.  I'm working on a different fix
so that we don't have to have multiple tables.  I should be done testing
it and other changes some time next week.

Mike, I'm also integrating your patch for 2.5 64bit addressing support.
I should have done it sooner, but better late than never.

David Jeffery

> -----Original Message-----
> From: Mike Anderson [mailto:andmike@us.ibm.com]
> Sent: Thursday, January 16, 2003 6:10 PM
> To: linux-scsi@vger.kernel.org
> Cc: David_Jeffery@adaptec.com
> Subject: [PATCH] 2.5 ips.c pci_module_init
> 
> 
> This patch is against 2.5.58 but also applies to scsi-misc-2.5 with a
> offset 1 line warning.
> 
> This error started near 2.5.56 with badness warnings when the driver
> loaded and has progressed to the driver probe routine not being called
> at all as sysfs error propagation patches have been added. Since my
> ServeRAID card is old it is the last pci_module_init to be called.
> 
> The patch just changes the name field in the ips pci_driver struct as
> the three pci_driver names where not unique and cause EEXIST errors.
> 
> I have cc'd David Jeffery the driver maintainer.
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
>  ips.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> ------
