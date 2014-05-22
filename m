From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] qla2xxx: Restrict max_lun to 16-bit for older HBAs
Date: Thu, 22 May 2014 02:09:31 -0700
Message-ID: <20140522090931.GD14854@infradead.org>
References: <1400583791-123120-1-git-send-email-hare@suse.de>
 <1400583791-123120-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60568 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaEVJJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2014 05:09:31 -0400
Content-Disposition: inline
In-Reply-To: <1400583791-123120-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>

On Tue, May 20, 2014 at 01:03:09PM +0200, Hannes Reinecke wrote:
> Older HBAs are only capable of supporting 16-bit LUNs,
> so we need to make sure to adjust max_lun accordingly.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

This is probably something we should put in now instead of waiting for
the rest of the series.

