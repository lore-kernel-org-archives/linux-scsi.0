From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [patch 07/10] scsi: replace __inline with inline
Date: Fri, 18 Apr 2008 14:24:06 -0700
Message-ID: <1208553846.10414.4.camel@brick>
References: <200804182057.m3IKvP6Q015391@imap1.linux-foundation.org>
	 <48090DDA.9080600@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.230]:6760 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYDRVXy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Apr 2008 17:23:54 -0400
Received: by wx-out-0506.google.com with SMTP id h31so655793wxd.4
        for <linux-scsi@vger.kernel.org>; Fri, 18 Apr 2008 14:23:53 -0700 (PDT)
In-Reply-To: <48090DDA.9080600@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Fri, 2008-04-18 at 17:08 -0400, Jeff Garzik wrote:
> akpm@linux-foundation.org wrote:
> > From: Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/scsi/aic7xxx/aic79xx_core.c   |   14 -
> >  drivers/scsi/aic7xxx/aic79xx_inline.h |  218 ++++++++++++------------
> >  drivers/scsi/aic7xxx/aic79xx_osm.c    |    4 
> >  drivers/scsi/aic7xxx/aic79xx_osm.h    |  110 ++++++------
> >  drivers/scsi/aic7xxx/aic79xx_pci.c    |    2 
> >  drivers/scsi/aic7xxx/aic7xxx_inline.h |  126 ++++++-------
> >  drivers/scsi/aic7xxx/aic7xxx_osm.c    |    8 
> >  drivers/scsi/aic7xxx/aic7xxx_osm.h    |  100 +++++------
> >  drivers/scsi/aic7xxx/aic7xxx_pci.c    |    2 
> >  drivers/scsi/aic7xxx/aiclib.h         |    4 
> >  drivers/scsi/sym53c8xx_2/sym_glue.h   |    6 
> >  drivers/scsi/sym53c8xx_2/sym_hipd.c   |    2 
> >  drivers/scsi/sym53c8xx_2/sym_hipd.h   |    6 
> >  drivers/scsi/sym53c8xx_2/sym_malloc.c |    2 
> >  drivers/scsi/sym53c8xx_2/sym_misc.h   |   18 -
> >  15 files changed, 311 insertions(+), 311 deletions(-)
> 
> Acked-by: Jeff Garzik <jgarzik@redhat.com>
> 
> 
> However...   I would strongly prefer the Denis Valesko(sp?) patch that 
> shrinks the aic* drivers by removing many unneeded markers.
> 
> 	Jeff
> 

Agreed, that should go first, then apply whatever still remains or run a
quick sed -i s/__inline /inline / afterwards.

Harvey

