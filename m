From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 2/2] struct scsi_lun preparation
Date: Mon, 11 Sep 2006 14:43:42 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70307645@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51692 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964897AbWIKUnz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 16:43:55 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org

On Monday, September 11, 2006 8:36 AM, Jeff Garzik wrote: 

> 
> 
> DO NOT APPLY.
> 
> Not-signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
>  drivers/scsi/3w-xxxx.c                |   22 ++++++++++++--------
>  drivers/scsi/BusLogic.c               |    6 ++---
>  drivers/scsi/NCR5380.c                |    8 +++----
>  drivers/scsi/NCR53C9x.c               |   12 +++++------
>  drivers/scsi/advansys.c               |   23 +++++++++++----------
>  drivers/scsi/aha152x.c                |    6 ++---
>  drivers/scsi/aic7xxx/aic7xxx_osm.c    |    8 +++----
>  drivers/scsi/dc395x.c                 |   24 +++++++++++-----------
>  drivers/scsi/eata.c                   |    9 ++------
>  drivers/scsi/g_NCR5380.c              |   10 ++++-----
>  drivers/scsi/gdth_proc.c              |   12 +++++------
>  drivers/scsi/in2000.c                 |   36 
> +++++++++++++++++-----------------
>  drivers/scsi/initio.c                 |    2 -
>  drivers/scsi/ipr.c                    |    3 +-
>  drivers/scsi/libata-scsi.c            |    2 -
>  drivers/scsi/megaraid/mega_common.h   |    2 -
>  drivers/scsi/megaraid/megaraid_mbox.c |    6 ++---
>  drivers/scsi/megaraid/megaraid_sas.h  |    6 ++---
>  drivers/scsi/ncr53c8xx.c              |    2 -
>  drivers/scsi/nsp32.c                  |    4 +--
>  drivers/scsi/pcmcia/nsp_cs.c          |    2 -
>  drivers/scsi/psi240i.c                |    2 -
>  drivers/scsi/sym53c8xx_2/sym_glue.c   |    6 ++---
>  23 files changed, 108 insertions(+), 105 deletions(-)
> 

Can you convert drivers/message/fusion please?
