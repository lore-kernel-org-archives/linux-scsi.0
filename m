From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/23] acornscsi: use scsi_print_command()
Date: Tue, 30 Sep 2014 07:52:57 -0700
Message-ID: <20140930145257.GB1206@infradead.org>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
 <1412077852-40893-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42727 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaI3Ow6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 10:52:58 -0400
Content-Disposition: inline
In-Reply-To: <1412077852-40893-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Tue, Sep 30, 2014 at 01:50:35PM +0200, Hannes Reinecke wrote:
> Update acornscsi to use scsi_print_command() instead of the
> underscore version. This will add correct device annotations
> in the resulting message.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Also includes a few scmd_printk converstions that should be mentioned
in the changelog, but otherwise looks fine.

Reviewed-by: Christoph Hellwig <hch@lst.de>
