From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] allow sleep inside EH hooks
Date: Fri, 27 May 2005 18:16:38 +0100
Message-ID: <20050527171638.GB5715@infradead.org>
References: <4296A2C7.4090107@pobox.com> <20050527071109.GB27256@infradead.org> <4296D0D8.6030907@pobox.com> <20050527075924.GA28608@infradead.org> <4296DC0B.9060802@pobox.com> <42974E19.9040007@adaptec.com> <42974F95.6010603@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40937 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262513AbVE0RQm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 13:16:42 -0400
Content-Disposition: inline
In-Reply-To: <42974F95.6010603@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, May 27, 2005 at 12:49:25PM -0400, Jeff Garzik wrote:
> >I'd like to see the same thing for queuecommand(), i.e. host_lock be gone.
> 
> We can take up that topic once I'm done with sleeping-in-EH project :)
> 
> I don't disagree...   but changing the locking for ->queuecommand() is a 
> -lot- more invasive, and requires much more care.

I'll promise to do the ->queuecommand bits ASAP once you're done with
all error handlers :)

