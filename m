From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 16:57:16 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615155716.GA14017@infradead.org>
References: <40CF0F9F.4050902@adaptec.com> <1087313241.2710.40.camel@laptop.fenrus.com> <40CF1852.6030306@adaptec.com> <20040615154313.GA25397@devserv.devel.redhat.com> <40CF1A5D.30908@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:14464 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265716AbUFOP5S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 11:57:18 -0400
Content-Disposition: inline
In-Reply-To: <40CF1A5D.30908@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Arjan van de Ven <arjanv@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jun 15, 2004 at 11:48:45AM -0400, Luben Tuikov wrote:
> This really isn't anything new or paramount.  It's just a simple
> extension, marked OPTIONAL, that only *capable* drivers should use.
> (i.e. the aic7xxx drivers, maybe some FC and USB).
> 
> So it's not really that big of a deal, but does wonders to
> SCSI Core in terms of recovery time and *uninterruptible*
> IO.

Well, the question is always what is so special about your driver that
it doesn't benefit from beeing in a common library.  I've pulled more crap
out of individual drivers than I'd ever want to imagine, and because of
that I'm pretty much allergic against giving driver writers more control
then nessecary.

