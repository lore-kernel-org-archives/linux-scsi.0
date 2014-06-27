From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] Use 'Scsi_Host' as argument for host reset
Date: Fri, 27 Jun 2014 00:59:38 -0700
Message-ID: <20140627075938.GD21799@infradead.org>
References: <1403850425-89297-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50136 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaF0H7j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 03:59:39 -0400
Content-Disposition: inline
In-Reply-To: <1403850425-89297-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Fri, Jun 27, 2014 at 08:26:58AM +0200, Hannes Reinecke wrote:
> eh_host_reset_handler can only depend on the Scsi_Host, so
> we should make that explicit by using 'struct Scsi_Host' as
> argument for it.

I like where this is going.  Are you going to do a similar conversion
away from scsi_cmnd for the other reset methods as well?  It would be
good to get them into a single kernel release so that we don't have
a churn of lots of small driver API changes.

