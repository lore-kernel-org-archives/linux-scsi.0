From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/10] scsi: log request tag for scmd_printk()
Date: Wed, 5 Nov 2014 22:40:34 -0800
Message-ID: <20141106064034.GA713@infradead.org>
References: <1415088409-46590-1-git-send-email-hare@suse.de>
 <1415088409-46590-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53526 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaKFGkg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 01:40:36 -0500
Content-Disposition: inline
In-Reply-To: <1415088409-46590-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org

On Tue, Nov 04, 2014 at 09:06:41AM +0100, Hannes Reinecke wrote:
> The request tag provides a concise identification of a SCSI
> command, so we should be printing that out for scmd_printk().
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Christoph Hellwig <hch@lst.de>

