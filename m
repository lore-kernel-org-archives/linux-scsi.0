From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] use mod_timer in scsi_add_timer
Date: Sun, 31 Aug 2003 14:53:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030831125356.GA20378@lst.de>
References: <20030831112830.GA19502@lst.de> <1062334317.31351.30.camel@dhcp23.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:2699 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261380AbTHaMyK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Aug 2003 08:54:10 -0400
Content-Disposition: inline
In-Reply-To: <1062334317.31351.30.camel@dhcp23.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Sun, Aug 31, 2003 at 01:51:58PM +0100, Alan Cox wrote:
> On Sul, 2003-08-31 at 12:28, Christoph Hellwig wrote:
> > -
> >  	scmd->eh_timeout.data = (unsigned long)scmd;
> > -	scmd->eh_timeout.expires = jiffies + timeout;
> >  	scmd->eh_timeout.function = (void (*)(unsigned long)) complete;
> 
> And your change is racy too. You might now call the timer function with
> the data from the old timeout and the function of the new...

The data always is scmd.

