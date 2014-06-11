From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] scsi: Handle power-on reset unit attention
Date: Wed, 11 Jun 2014 05:49:41 -0700
Message-ID: <20140611124941.GA17312@infradead.org>
References: <1401953203-103015-1-git-send-email-hare@suse.de>
 <1401953203-103015-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbaFKMtn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 08:49:43 -0400
Content-Disposition: inline
In-Reply-To: <1401953203-103015-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Robert Elliot <elliot@hp.com>, linux-scsi@vger.kernel.org

On Thu, Jun 05, 2014 at 09:26:43AM +0200, Hannes Reinecke wrote:
> As per SAM there is a status precedence, with any sense code 29/XX
> taking second place just after an ACA ACTIVE status.
> Additionally, each target might prefer to not queue any unit
> attention conditions but just report one.
> Due to the above this will be that one with the highest precedence.
> This results in the sense code 29/XX effectively overwriting any
> other unit attention.
> Hence we should report the power-on reset to userland so that
> it can take appropriate action.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
