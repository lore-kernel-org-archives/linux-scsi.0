From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [2.6 patch] drivers/scsi/scsi_error.c should #include "scsi_transport_api.h"
Date: Wed, 29 Nov 2006 06:16:24 -0700
Message-ID: <20061129131624.GV14076@parisc-linux.org>
References: <20061129100422.GL11084@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56738 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1758839AbWK2NQZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Nov 2006 08:16:25 -0500
Content-Disposition: inline
In-Reply-To: <20061129100422.GL11084@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Nov 29, 2006 at 11:04:22AM +0100, Adrian Bunk wrote:
> +#include "scsi_transport_api.h"

scsi_transport_api.h is a weird little file.  It's not included by
anything in the drivers/scsi directory, only
drivers/scsi/libsas/sas_scsi_host.c:#include "../scsi_transport_api.h"
drivers/ata/libata-eh.c:#include "../scsi/scsi_transport_api.h"

To me, that says it should be living in include/scsi/ somewhere ...
maybe just put the one function prototype into scsi_eh.h?
