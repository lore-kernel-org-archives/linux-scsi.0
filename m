From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/2] libsas: Convert sas_proto users to sas_protocol
Date: Mon, 05 Nov 2007 15:27:36 -0500
Message-ID: <472F7CB8.4070809@garzik.org>
References: <20071105195117.GB7010@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60806 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbXKEU1k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Nov 2007 15:27:40 -0500
In-Reply-To: <20071105195117.GB7010@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Alexis Bruemmer <alexisb@us.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Darrick J. Wong wrote:
> sparse complains about the mixing of enums in libsas.  Since the
> underlying numeric values of both enums are the same, combine them
> to get rid of the warning.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/scsi/aic94xx/aic94xx_dev.c  |    6 +++---
>  drivers/scsi/aic94xx/aic94xx_dump.c |    4 ++--
>  drivers/scsi/aic94xx/aic94xx_hwi.c  |    2 +-
>  drivers/scsi/aic94xx/aic94xx_scb.c  |    6 +++---
>  drivers/scsi/aic94xx/aic94xx_task.c |   30 +++++++++++++++---------------
>  drivers/scsi/aic94xx/aic94xx_tmf.c  |   12 ++++++------
>  drivers/scsi/libsas/sas_discover.c  |    2 +-
>  drivers/scsi/libsas/sas_expander.c  |    6 +++---
>  drivers/scsi/libsas/sas_internal.h  |    2 +-
>  include/scsi/libsas.h               |   18 +++++++++---------
>  include/scsi/sas.h                  |   13 ++++++-------
>  include/scsi/scsi_transport_sas.h   |    8 +-------
>  12 files changed, 51 insertions(+), 58 deletions(-)

ACK patches 1-2


