From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] libata: consolidate ata_dev_classify()
Date: Mon, 2 Jun 2014 02:16:25 -0700
Message-ID: <20140602091625.GA32301@infradead.org>
References: <1401692478-23557-1-git-send-email-hare@suse.de>
 <1401692478-23557-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38951 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaFBJQ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 05:16:27 -0400
Content-Disposition: inline
In-Reply-To: <1401692478-23557-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Mon, Jun 02, 2014 at 09:01:16AM +0200, Hannes Reinecke wrote:
> ata_dev_classify() just uses the 'lbah' and 'lbam'
> fields from the taskfile, so we can as well use those
> as arguments and rip out the custom code from sas_ata.

There is no reason why SAS couldn't set up a taskfile structure either,
but this looks cleaner to me anyway, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But you really need to run libata changes past the linux-ide list
and not just the scsi list.

