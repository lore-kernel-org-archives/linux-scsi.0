From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: Assistance with an upgraded scsi driver
Date: Thu, 1 Jul 2004 12:47:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC805@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:45977 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266079AbUGAQrl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2004 12:47:41 -0400
List-Id: linux-scsi@vger.kernel.org
To: "'cgg007@yahoo.com'" <cgg007@yahoo.com>, linux-scsi@vger.kernel.org

> New tarball:
> Makefile     mega_common.h  megaraid_mbox.c  megaraid_mm.c
> Kconfig.megaraid    mbox_defs.h  megaraid_ioctl.h     
> megaraid_mbox.h  megaraid_mm.h
> 
> ...
> 
> I've created a megaraid directory under /usr/src/linux/drivers/scsi
> 
> I modified the Makefile and Kconfig in /usr/src/linux/drivers/scsi
> 
> I cleaned out the old files
> 
> I re-configured to include the new options for compiling the 
> MEGARAID_NEWGEN as
> a module
> 
> I ran make all
> 
> ... ... ...
> 
> No new module code was generated. :(
> 
Try
# make drivers/scsi/megaraid/

or
# cd drivers/scsi/megaraid
# make -C /usr/src/linux-.../ SUBDIRS=`pwd` clean
# make -C /usr/src/linux-.../ SUBDIRS=`pwd` modules

Modules megaraid_mm.ko and megaraid_mbox.ko should now be available. Load
megaraid_mm before loading megaraid_mbox

-Atul Mukker
LSI Logic
