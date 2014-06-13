From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] scsi_error: set DID_TIME_OUT correctly
Date: Fri, 13 Jun 2014 09:25:49 -0700
Message-ID: <20140613162549.GA19895@infradead.org>
References: <1402660906-74661-1-git-send-email-hare@suse.de>
 <1402660906-74661-2-git-send-email-hare@suse.de>
 <1402669934.3820.117.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51240 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaFMQZv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jun 2014 12:25:51 -0400
Content-Disposition: inline
In-Reply-To: <1402669934.3820.117.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ewan Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Bart vn Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org

On Fri, Jun 13, 2014 at 10:32:14AM -0400, Ewan Milne wrote:
> See Paolo's patch series which includes:
> 
> [PATCH v3 4/6] scsi_error: fix invalid setting of host byte
> 
> I think your patch won't apply after his.

Might make sense to rebase this, which shouldn't be too hard.

I already have a local tree with the few remaining for 3.16 fixes, but
James didn't reply if he actually agrees with them so far.

