From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [Open-FCoE] [PATCH] libfc: correct function name in comment
Date: Wed, 05 Aug 2015 13:45:29 -0700
Message-ID: <1438807529.19451.9.camel@lin-nd1-054.jf.intel.com>
References: <20150805002155.00002f53@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38586 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633AbbHEUpa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Aug 2015 16:45:30 -0400
In-Reply-To: <20150805002155.00002f53@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>, linux-scsi@vger.kernel.org
Cc: fcoe-devel@open-fcoe.org

On Wed, 2015-08-05 at 00:21 +0200, Sebastian Herbszt wrote:
> Use the correct function name in kernel-doc comment.
> 
> Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
> ---
> 
> diff -U 5 -rp a/drivers/scsi/libfc/fc_npiv.c b/drivers/scsi/libfc/fc_npiv.c
> --- a/drivers/scsi/libfc/fc_npiv.c	2014-09-03 19:30:11.760273300 +0200
> +++ b/drivers/scsi/libfc/fc_npiv.c	2015-08-05 00:06:17.927753719 +0200
> @@ -23,11 +23,11 @@
>  
>  #include <scsi/libfc.h>
>  #include <linux/export.h>
>  
>  /**
> - * fc_vport_create() - Create a new NPIV vport instance
> + * libfc_vport_create() - Create a new NPIV vport instance
>   * @vport: fc_vport structure from scsi_transport_fc
>   * @privsize: driver private data size to allocate along with the Scsi_Host
>   */
>  
>  struct fc_lport *libfc_vport_create(struct fc_vport *vport, int privsize)
> _

Looks good.

Acked-by: Vasu Dev <vasu.dev@intel.com>

