From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dpt_i2o: convert to SCSI hotplug model
Date: Mon, 30 Jul 2007 22:29:35 +0100
Message-ID: <20070730212935.GC4987@infradead.org>
References: <20070730211917.GK21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50895 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765762AbXG3V3l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 17:29:41 -0400
Content-Disposition: inline
In-Reply-To: <20070730211917.GK21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org

On Mon, Jul 30, 2007 at 03:19:18PM -0600, Matthew Wilcox wrote:
> dpt_i2o: Convert to new SCSI driver model
> 
>  - Delete refereces to HOSTS_C
>  - Switch to module_init/module_exit instead of detect/release
>  - Don't pass around the host template and rename it to adpt_template
>  - Switch from scsi_register/scsi_unregister to scsi_host_alloc,
>    scsi_add_host, scsi_scan_host and scsi_host_put.

Looks fine to me except that I'd prefer to see adpt_detect merged into
adpt_init even if that means moving some code around and the cleanup
in the init path might better be just opencoded than re-using adpt_exit
especiall if that one's going to get a little more complicated later on.

