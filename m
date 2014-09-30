From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 21/23] scsi: fixup logging messages in scsi_error.c
Date: Tue, 30 Sep 2014 08:20:10 -0700
Message-ID: <20140930152010.GB28330@infradead.org>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
 <1412077852-40893-22-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaI3PUL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 11:20:11 -0400
Content-Disposition: inline
In-Reply-To: <1412077852-40893-22-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Tue, Sep 30, 2014 at 01:50:50PM +0200, Hannes Reinecke wrote:
> Use the matching scope for logging messages to allow for
> better command tracing.
> 
> Suggested-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
