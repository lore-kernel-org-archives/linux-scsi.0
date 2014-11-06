From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/10] scsi: Rename SERVICE_ACTION_IN to
 SERVICE_ACTION_IN_16
Date: Wed, 5 Nov 2014 23:07:12 -0800
Message-ID: <20141106070712.GC19721@infradead.org>
References: <1415088409-46590-1-git-send-email-hare@suse.de>
 <1415088409-46590-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35818 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaKFHHO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 02:07:14 -0500
Content-Disposition: inline
In-Reply-To: <1415088409-46590-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org

On Tue, Nov 04, 2014 at 09:06:46AM +0100, Hannes Reinecke wrote:
> SPC-3 defines SERVICE ACTION IN(12) and SERVICE ACTION IN(16).
> So rename SERVICE_ACTION_IN to SERVICE_ACTION_IN_16 to be
> consistent with SPC and to allow for better distinction.

Looks fine, I'd really like to take this at the beginning of the series.

Reviewed-by: Christoph Hellwig <hch@lst.de>
