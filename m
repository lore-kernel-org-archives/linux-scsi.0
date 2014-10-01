From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: add a CONFIG_SCSI_MQ_DEFAULT option
Date: Wed, 1 Oct 2014 10:08:09 +0200
Message-ID: <20141001080809.GA20498@lst.de>
References: <1412090453-24484-1-git-send-email-hch@lst.de> <94D0CD8314A33A4D9D801C0FE68B402958CC5E9E@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41654 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaJAIIM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2014 04:08:12 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CC5E9E@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, Oct 01, 2014 at 01:02:32AM +0000, Elliott, Robert (Server Storage) wrote:
> A printk indicating the choice would be helpful; there's no indication
> in the "Command line" or "Kernel command line" lines after this patch.

No need for a printk to further increase the gigantic kernel log at boot
time, you can easily find the indicator in the use_blk_mq sysfs attributes,
both on the module, and each individual host.
