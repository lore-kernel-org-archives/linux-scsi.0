From: Christoph Hellwig <hch@infradead.org>
Subject: Re: sleeping in scsi EH
Date: Fri, 27 May 2005 09:42:21 +0100
Message-ID: <20050527084220.GA29352@infradead.org>
References: <42968560.7020608@pobox.com> <20050527070954.GA27256@infradead.org> <4296DC49.5020907@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:12000 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262158AbVE0ImW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 04:42:22 -0400
Content-Disposition: inline
In-Reply-To: <4296DC49.5020907@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, May 27, 2005 at 04:37:29AM -0400, Jeff Garzik wrote:
> Christoph Hellwig wrote:
> >You can sleep in them.  You must however release the host lock and enable
> >irqs first and reverse that before returning.  The error handlers don't
> >need the host lock, but we're stuck with the unfortunate calling convention
> >for now.
> 
> Why are we stuck with this calling convention, when everyone who cares 
> circumvents it?

Because no one found the time to do a full transition yet.  If you want to
update all scsi drivers feel free.  One patch per method please.

