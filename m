From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 15:31:59 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928153159.A2655@infradead.org>
References: <4159611C.4030106@adaptec.com> <20040928141228.A1815@infradead.org> <415964D2.80808@adaptec.com> <20040928142133.A1956@infradead.org> <41596793.6040900@adaptec.com> <20040928143652.A2144@infradead.org> <41596A58.1060208@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:34323 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267823AbUI1OcB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 10:32:01 -0400
Content-Disposition: inline
In-Reply-To: <41596A58.1060208@adaptec.com>; from luben_tuikov@adaptec.com on Tue, Sep 28, 2004 at 09:42:48AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Sep 28, 2004 at 09:42:48AM -0400, Luben Tuikov wrote:
> > Yes, a gradual progression is exactly what I want to see.  But based on
> > _logical_ changes, aka fix this, rearchitect that, cleanup this.
> 
> This isn't quite possible to be generated from a difference
> of the latest version which I have from the version in
> the linux kernel.  They are just too far apart.

This requires intensive manual work indeed.  Splitting an enormous into
logical pieces is an effort, but it usually pays off, both because of the
additional review and better documentation.

I'd suggest you apply rule 1 of every lazy hacker and try to solve an
easier partial problem first instead of a full resync.  Like merging
over all those local small fixes.
