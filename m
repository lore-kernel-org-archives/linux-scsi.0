From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill of ->command
Date: Mon, 9 Jun 2003 18:51:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609165157.GA2079@lst.de>
References: <20030609162056.GA1857@lst.de> <20030609094130.A14870@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:61838 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264403AbTFIQif (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 12:38:35 -0400
Content-Disposition: inline
In-Reply-To: <20030609094130.A14870@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk

On Mon, Jun 09, 2003 at 09:41:30AM -0700, Patrick Mansfield wrote:
> On Mon, Jun 09, 2003 at 06:20:56PM +0200, Christoph Hellwig wrote:
> > It's unused now.  Also kill off the stupid = NULL initializations
> > in usb-storage that made this not compile the first time..
> 
> It looks like drivers/scsi/NCR53c406a.c

eek, this one would still need ->command for some devices it appears.
Looks like I should crap this patch or just disable support for that
hw until soneone steps up to fix it.

> and drivers/scsi/arm/arxescsi.c
> can still set can_queue = 0. Correct?

Russell, and idea why this one sets can_queue = 0 but implements
->queuecommand?

