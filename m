From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 21/22] scsi: reduce messages for command failure
Date: Sun, 31 Aug 2014 15:28:40 -0700
Message-ID: <20140831222840.GM16432@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-22-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHaW2n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 18:28:43 -0400
Content-Disposition: inline
In-Reply-To: <1409247216-76074-22-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On Thu, Aug 28, 2014 at 07:33:35PM +0200, Hannes Reinecke wrote:
> When devices fail they can generate quite a lot of error
> messages, possibly overloading the logging system.
> So we should be putting these messages under logging control
> to be able to silence them if requested.
> And we should shorten the overall message; more verbose
> logging can be requested by the normal scsi logging.

While the logging mask magic always confused me I'm fairly sure this
disables logging the completion errors entirely by default.  If that
was the intention it should be mentioned in the changelog.

I do however think printing them in a ratelimit way might be useful,
so I'd like to see a few more arguments for not doing it that way if
you really prefer it.

