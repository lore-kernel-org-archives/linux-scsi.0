From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 19/23] sd: Cleanup logging
Date: Tue, 30 Sep 2014 07:58:58 -0700
Message-ID: <20140930145858.GI1206@infradead.org>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
 <1412077852-40893-20-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44332 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaI3O7A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 10:59:00 -0400
Content-Disposition: inline
In-Reply-To: <1412077852-40893-20-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Tue, Sep 30, 2014 at 01:50:48PM +0200, Hannes Reinecke wrote:
> Open-code scsi_print_result in sd.c, and cleanup logging to
> not print duplicate informations.
> 
> With that we can remove scsi_show_result in constants.c

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
