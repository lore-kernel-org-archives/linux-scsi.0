From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fw: legacy megaraid driver bug in mm-series
Date: Tue, 13 Sep 2005 10:23:59 +0100
Message-ID: <20050913092359.GA29552@infradead.org>
References: <20050907025258.35100c34.akpm@osdl.org> <20050908143547.GA9741@infradead.org> <20050909165817.1a8ad251.akpm@osdl.org> <432613BA.5060606@usa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:21670 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932460AbVIMJYE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 05:24:04 -0400
Content-Disposition: inline
In-Reply-To: <432613BA.5060606@usa.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Byer <ojbyer@usa.net>
Cc: Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Mon, Sep 12, 2005 at 07:48:10PM -0400, Jack Byer wrote:
> Andrew Morton wrote:
> > Christoph Hellwig <hch@infradead.org> wrote:
> > 
> >>On Wed, Sep 07, 2005 at 02:52:58AM -0700, Andrew Morton wrote:
> >>
> >>>
> >>>Begin forwarded message:
> >>
> >>This looks preyyu much like a breakage because we're now always sending
> >>S/G list down the scsi layer.
> >>
> >>The patch below brings over code to handle that case from the megaraid_mbox
> >>driver.  It's still wrong for the case someone sends a MODE_SENSE from
> >>highmem userspace, but it should at least boot with the patch applied.
> >>
> > 
> > 
> > Jack, have you had a chance to test this?
> > 
> > Thanks.
> > 
> Sorry, I spent the weekend whitewater rafting :)  I will be able to test
> this patch on Wednesday. Which kernel versions should I apply this patch to?

I did it against the at that time latest scsi-misc tree.  The old megaraid
driver hasn'tt changed much for a long time so it should apply against
any recent-ish tree.

