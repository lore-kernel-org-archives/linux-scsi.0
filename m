From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/10][RFC] linux-iscsi driver
Date: Tue, 11 Jan 2005 09:59:20 +0000
Message-ID: <20050111095920.GA18119@infradead.org>
References: <41E30855.9050203@cs.wisc.edu> <20050110232442.GB10138@infradead.org> <1105404318.4477.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:27279 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262664AbVAKJ7V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 04:59:21 -0500
Content-Disposition: inline
In-Reply-To: <1105404318.4477.18.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 10, 2005 at 06:45:18PM -0600, James Bottomley wrote:
> On Mon, 2005-01-10 at 23:24 +0000, Christoph Hellwig wrote:
> > Can you kill the ugly iscsi-sfnet name?  We also don't call out networking
> > code ipv4-swansea ;-)  Simple iscsi should be enough, or if you think that's
> > confusing vs driver for hardware offload cards maybe sw-iscsi.
> 
> Please not that can of worms again.
> 
> For the time being I think iscsi-sfnet will do since there's still one
> other possible linux iscsi stack around.  And we would probably have
> called our networking code ipv4-swansea if we also had an ipv4-bsd or
> something else one could use.
> 
> In the long run, there will be only a single iscsi driver, and it can be
> renamed as such, but in the short term we're not ready to choose.

I disagree.  We have been concentrating on this driver for a long time,
everyone whoe thinks his driver should have been _the_ software initiator
should have complained for a long time.

