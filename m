From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/24] fas216: Return DID_ERROR for incomplete data
 transfer
Date: Wed, 1 Oct 2014 00:58:49 -0700
Message-ID: <20141001075849.GA5694@infradead.org>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36818 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaJAH6u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 03:58:50 -0400
Content-Disposition: inline
In-Reply-To: <1412144580-72880-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Wed, Oct 01, 2014 at 08:22:43AM +0200, Hannes Reinecke wrote:
> fas216 returns DID_BAD_TARGET for an incomplete data
> transfer. The midlayer uses DID_BAD_TARGET to signal
> a non-existing or not reachable target. So we should
> rather be using DID_ERROR here.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
