From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Re: sleeping in scsi EH
Date: Fri, 27 May 2005 11:52:56 +0100
Message-ID: <20050527105256.GA31318@infradead.org>
References: <42968560.7020608@pobox.com> <20050527070954.GA27256@infradead.org> <4296DC49.5020907@pobox.com> <20050527084220.GA29352@infradead.org> <4296FA61.4010003@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:8930 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262434AbVE0KxB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 06:53:01 -0400
Content-Disposition: inline
In-Reply-To: <4296FA61.4010003@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, May 27, 2005 at 06:45:53AM -0400, Jeff Garzik wrote:
> Something like the attached?

Looks good to me.

> - *      Locks: struct Scsi_Host::host_lock held (with irqsave) on entry 
> - *      and assumed to be held on return.
> + *      Locks: None held.  EH context.
>   *
>   *      Calling context: kernel thread

We already mention the calling context, no need to duplicate that in the
Locks: section.

