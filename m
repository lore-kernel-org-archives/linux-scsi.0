From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 16:49:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615154913.GA13917@infradead.org>
References: <40CF0F9F.4050902@adaptec.com> <1087313241.2710.40.camel@laptop.fenrus.com> <40CF1852.6030306@adaptec.com> <20040615154223.GA13780@infradead.org> <40CF19C0.5080507@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:2688 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265716AbUFOPtP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 11:49:15 -0400
Content-Disposition: inline
In-Reply-To: <40CF19C0.5080507@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, arjanv@redhat.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jun 15, 2004 at 11:46:08AM -0400, Luben Tuikov wrote:
> >That's why the plan is to move it into the transport class slowly.  Remeber
> >there are much more SPI drivers than just aic7xxx/aic79xx ;-)
> 
> Yes, in which case it would look like FreeBSD.  Then SCSI Core will
> have to implement _all_ transports it wants to support (a la USB Storage).

Umm, no.  Look at a recent Linux 2.6 codebase.  We support modular transport
classes so it's _NOT_ a big mess like FreeBSD.  And we won't stop providing
sensible defaults abyway.

> But if we *do* allow for this patch, then _moving_ this functionality
> into the transport class recovery would be really easy.  Just move
> eh_cmd_timed_out() into the transport class.

Show us a patch with your SPI EH improvements.

