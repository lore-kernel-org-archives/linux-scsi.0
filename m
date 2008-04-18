From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 07/10] scsi: replace __inline with inline
Date: Fri, 18 Apr 2008 17:08:42 -0400
Message-ID: <48090DDA.9080600@garzik.org>
References: <200804182057.m3IKvP6Q015391@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40925 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933419AbYDRVIr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 17:08:47 -0400
In-Reply-To: <200804182057.m3IKvP6Q015391@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, harvey.harrison@gmail.com

akpm@linux-foundation.org wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/aic7xxx/aic79xx_core.c   |   14 -
>  drivers/scsi/aic7xxx/aic79xx_inline.h |  218 ++++++++++++------------
>  drivers/scsi/aic7xxx/aic79xx_osm.c    |    4 
>  drivers/scsi/aic7xxx/aic79xx_osm.h    |  110 ++++++------
>  drivers/scsi/aic7xxx/aic79xx_pci.c    |    2 
>  drivers/scsi/aic7xxx/aic7xxx_inline.h |  126 ++++++-------
>  drivers/scsi/aic7xxx/aic7xxx_osm.c    |    8 
>  drivers/scsi/aic7xxx/aic7xxx_osm.h    |  100 +++++------
>  drivers/scsi/aic7xxx/aic7xxx_pci.c    |    2 
>  drivers/scsi/aic7xxx/aiclib.h         |    4 
>  drivers/scsi/sym53c8xx_2/sym_glue.h   |    6 
>  drivers/scsi/sym53c8xx_2/sym_hipd.c   |    2 
>  drivers/scsi/sym53c8xx_2/sym_hipd.h   |    6 
>  drivers/scsi/sym53c8xx_2/sym_malloc.c |    2 
>  drivers/scsi/sym53c8xx_2/sym_misc.h   |   18 -
>  15 files changed, 311 insertions(+), 311 deletions(-)

Acked-by: Jeff Garzik <jgarzik@redhat.com>


However...   I would strongly prefer the Denis Valesko(sp?) patch that 
shrinks the aic* drivers by removing many unneeded markers.

	Jeff



