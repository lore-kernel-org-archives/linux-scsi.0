From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] drivers/scsi/scsi_error.c should #include "scsi_transport_api.h"
Date: Tue, 2 Jan 2007 11:11:36 +0000
Message-ID: <20070102111136.GD21963@infradead.org>
References: <20061129100422.GL11084@stusta.de> <20061129131624.GV14076@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55820 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbXABLMD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2007 06:12:03 -0500
Content-Disposition: inline
In-Reply-To: <20061129131624.GV14076@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Adrian Bunk <bunk@stusta.de>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Nov 29, 2006 at 06:16:24AM -0700, Matthew Wilcox wrote:
> On Wed, Nov 29, 2006 at 11:04:22AM +0100, Adrian Bunk wrote:
> > +#include "scsi_transport_api.h"
> 
> scsi_transport_api.h is a weird little file.  It's not included by
> anything in the drivers/scsi directory, only
> drivers/scsi/libsas/sas_scsi_host.c:#include "../scsi_transport_api.h"
> drivers/ata/libata-eh.c:#include "../scsi/scsi_transport_api.h"
> 
> To me, that says it should be living in include/scsi/ somewhere ...
> maybe just put the one function prototype into scsi_eh.h?

Yes, it should probably go into scsi_eh.h.
