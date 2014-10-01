From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 24/24] scsi_error: document scsi_try_to_abort_cmd
Date: Wed, 1 Oct 2014 00:59:33 -0700
Message-ID: <20141001075933.GB5694@infradead.org>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-25-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaJAH7e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 03:59:34 -0400
Content-Disposition: inline
In-Reply-To: <1412144580-72880-25-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Wed, Oct 01, 2014 at 08:23:00AM +0200, Hannes Reinecke wrote:
> scsi_try_to_abort_cmd() should only return
> SUCCESS or FAILED. So document that in the
> function description and simplify the
> logging message.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Cc: Robert Elliott <elliott@hp.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
