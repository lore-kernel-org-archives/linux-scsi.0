From: Christoph Hellwig <hch@infradead.org>
Subject: Re: aic79xx update?
Date: Tue, 24 May 2005 20:06:01 +0100
Message-ID: <20050524190600.GA21070@infradead.org>
References: <42932AAD.9060609@suse.de> <42937864.8030204@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:20891 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261400AbVEXTGI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 15:06:08 -0400
Content-Disposition: inline
In-Reply-To: <42937864.8030204@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, May 24, 2005 at 02:54:28PM -0400, Luben Tuikov wrote:
> On 05/24/05 09:22, Hannes Reinecke wrote:
> > Hi Luben,
> > 
> > I did some patch regarding 'rmmod aic79xx' which got partially vetoed as
> > the aic79xx driver should rather be updated to use the spi_transport
> > class as the aic7xxx driver already has.
> > Do you have any plans in that area?
> 
> I've no resources attributed to aic79xx at the moment.
> 
> But I'd like to say absolute kudos to James and Christoph for
> making aic7xxx SPI transport aware!  Thumbs up!

All the hard work was done by James, I just did some minor cleanups so
I shouldn't be credited here :)

Is Adaptec willing to give aic79xx hardware and docs to scsi developers
to allow converting aic79xx to the SPI transport class and perform
other updates?
