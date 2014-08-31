From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/22] sd: Remove scsi_print_sense() in sd_done()
Date: Sun, 31 Aug 2014 14:40:24 -0700
Message-ID: <20140831214024.GC18839@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42314 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaHaVk1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 17:40:27 -0400
Content-Disposition: inline
In-Reply-To: <1409247216-76074-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On Thu, Aug 28, 2014 at 07:33:17PM +0200, Hannes Reinecke wrote:
> sd_done() was calling scsi_print_sense() for a sense code
> of 'NO_SENSE'.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
