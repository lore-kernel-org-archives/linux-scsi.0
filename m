From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill of ->command
Date: Mon, 9 Jun 2003 20:11:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609181148.GA3121@lst.de>
References: <20030609162056.GA1857@lst.de> <20030609094130.A14870@beaverton.ibm.com> <20030609165157.GA2079@lst.de> <20030609110413.A15239@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:59279 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262042AbTFIR6h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 13:58:37 -0400
Content-Disposition: inline
In-Reply-To: <20030609110413.A15239@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk

On Mon, Jun 09, 2003 at 11:04:13AM -0700, Patrick Mansfield wrote:
> The patch is a good idea, we ought to keep it.
> 
> We could move the ->command code (check for can_queue == 0) into the
> drivers queuecommand function, and let them call their own "command"
> function.

Well, the scsi midlayer handling for the two variants is a bit
different.  But I think just disabling support for the can_queue == 0
in NCR53c406a.c should be fine as it's a parameter whether to use
irqs (can_queue == 1) or not.

I'd just love to hear a comment from rmk on arxescsi.c.
