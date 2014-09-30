From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 22/23] scsi: use shost argument in scsi_eh_prt_fail_stats
Date: Tue, 30 Sep 2014 08:20:29 -0700
Message-ID: <20140930152029.GC28330@infradead.org>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
 <1412077852-40893-23-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:32931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaI3PUa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 11:20:30 -0400
Content-Disposition: inline
In-Reply-To: <1412077852-40893-23-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Tue, Sep 30, 2014 at 01:50:51PM +0200, Hannes Reinecke wrote:
> The EH statistics are per host, so we should be using
> shost_printk() here.
> 
> Suggested-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
