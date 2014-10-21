From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv7 00/27] scsi logging update (the boring part)
Date: Tue, 21 Oct 2014 03:55:38 -0700
Message-ID: <20141021105538.GA1950@infradead.org>
References: <1413787950-14659-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35901 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbaJUKzk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2014 06:55:40 -0400
Content-Disposition: inline
In-Reply-To: <1413787950-14659-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Mon, Oct 20, 2014 at 08:52:03AM +0200, Hannes Reinecke wrote:
> here is now the seventh iteration of my scsi logging update.
> With this I've included another patch for ratelimiting
> I/O error messages, which resolves the outstanding issue
> noted by Robert Elliot.

What tree is this against?  This doesn't seem to touch the ufs driver,
which in 3.18-rc has grown calls to some of the functions you remove.

