From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BusLogic error handling in kernel 2.6
Date: Thu, 4 Sep 2003 13:22:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030904132250.A30578@infradead.org>
References: <20030904115709.GA29956@mooch.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:25866 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264942AbTIDMWy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Sep 2003 08:22:54 -0400
Content-Disposition: inline
In-Reply-To: <20030904115709.GA29956@mooch.dyndns.org>; from glove@earthling.net on Thu, Sep 04, 2003 at 01:57:09PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christian Grigis <glove@earthling.net>
Cc: linux-scsi@vger.kernel.org

On Thu, Sep 04, 2003 at 01:57:09PM +0200, Christian Grigis wrote:
> My understanding is that the SCSI error handling functions have changed
> in 2.6, and that the BusLogic driver has not yet been converted to use
> the new approach. Is that correct?

Actually the new error handling was introduced in 2.2, but 2.2 and 2.5
kept glue around to support the old EH aswell.  But in principle you're right.

> Is anyone currently working, or planning to work, on this, for this adapter?

I don't think so.

> If not, I would be glad to contribute my help, within the realm of
> possibilities; could anyone give me some pointers as to where I should
> start?

http://www.andante.org/scsi_eh.html has a description of the new error
handling.  The document has been updated the last time three years ago
but the API hasn't really changed.  The biggest difference is that in
2.6 host->host_lock is held on entry now instead of the global
io_request_lock.  Also there are some new helper not yet described in
the text.

