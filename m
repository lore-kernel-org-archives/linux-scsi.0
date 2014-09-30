From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/23] aha152x: Debug output update and whitespace cleanup
Date: Tue, 30 Sep 2014 07:52:10 -0700
Message-ID: <20140930145210.GA1206@infradead.org>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
 <1412077852-40893-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42407 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaI3OwN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 10:52:13 -0400
Content-Disposition: inline
In-Reply-To: <1412077852-40893-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Tue, Sep 30, 2014 at 01:50:32PM +0200, Hannes Reinecke wrote:
> Remove all uncommented debugging code and move all
> printk() statements over to dev_printk().
> And while we're at it we should be doing a whitespace
> cleanup, too.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
