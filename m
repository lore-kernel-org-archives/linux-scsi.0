From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] kill of ->command
Date: Mon, 9 Jun 2003 19:15:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609191552.A2006@flint.arm.linux.org.uk>
References: <20030609162056.GA1857@lst.de> <20030609094130.A14870@beaverton.ibm.com> <20030609165157.GA2079@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:6159 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S262856AbTFISCQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2003 14:02:16 -0400
Content-Disposition: inline
In-Reply-To: <20030609165157.GA2079@lst.de>; from hch@lst.de on Mon, Jun 09, 2003 at 06:51:57PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Jun 09, 2003 at 06:51:57PM +0200, Christoph Hellwig wrote:
> > and drivers/scsi/arm/arxescsi.c
> > can still set can_queue = 0. Correct?
> 
> Russell, and idea why this one sets can_queue = 0 but implements
> ->queuecommand?

I would guess its because the author just did a cut and paste followed
by minimum editing to make it work.

I'd need to look at the code, but I'd imagine we could probably do
everything we need to inside ->queuecommand that's currently being
done by ->command.  My only concern would be calling the done
function from within queuecommand.

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

