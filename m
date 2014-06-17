From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/2] libahci: Implement the function
 ahci_restart_engine to restart the port dma engine.
Date: Tue, 17 Jun 2014 12:21:56 -0400
Message-ID: <20140617162156.GI31819@htj.dyndns.org>
References: <1402911336-31788-1-git-send-email-stripathi@apm.com>
 <1402911336-31788-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:46039 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933325AbaFQQWA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jun 2014 12:22:00 -0400
Content-Disposition: inline
In-Reply-To: <1402911336-31788-2-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com

Hello,

On Mon, Jun 16, 2014 at 03:05:35PM +0530, Suman Tripathi wrote:
> This patch implements the function ahci_restart_engine function to restart the port dma engine.

Please fit the text under 80 column.

> ---

I can't apply w/o your SOB.

> +int ahci_restart_engine(struct ata_port *ap)
> +{
> +	ahci_stop_engine(ap);
> +	ahci_start_fis_rx(ap);
> +	ahci_start_engine(ap);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ahci_restart_engine);

Why is this exported?  The next patch doesn't seem to use the function
outside libahci.c proper.

Thanks.

-- 
tejun
