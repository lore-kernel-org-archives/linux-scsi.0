From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH [14/18] qla2xxx: Use proper include files
Date: Tue, 22 Jun 2004 09:57:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622085727.GA31917@infradead.org>
References: <20040622055847.GA8483@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:8834 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261602AbUFVI52 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 04:57:28 -0400
Content-Disposition: inline
In-Reply-To: <20040622055847.GA8483@linux.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

> --- a/drivers/scsi/qla2xxx/qla_os.h	2004-06-21 15:39:47 -07:00
> +++ b/drivers/scsi/qla2xxx/qla_os.h	2004-06-21 15:39:47 -07:00
> @@ -58,11 +58,13 @@
>  #include <linux/ioctl.h>
>  #include <asm/uaccess.h>
>  
> -#include "scsi.h"
> -#include "hosts.h"
> -
> -#include <scsi/scsicam.h>
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_tcq.h>
>  #include <scsi/scsi_ioctl.h>
> +#include <scsi/scsicam.h>
>  #include <scsi/scsi_transport.h>
>  #include <scsi/scsi_transport_fc.h>

Umm, no.  I moved them away from qla_os.h precisly because I want to get
rid of that file in the next steps.

