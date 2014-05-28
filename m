From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] acornscsi: remove linked command support
Date: Wed, 28 May 2014 16:17:39 +0100
Message-ID: <20140528151739.GJ3693@n2100.arm.linux.org.uk>
References: <1400926433.31526.89.camel@x220> <20140528104114.GE13542@infradead.org> <1401287204.2288.28.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37116 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753144AbaE1PTK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2014 11:19:10 -0400
Content-Disposition: inline
In-Reply-To: <1401287204.2288.28.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Paul Bolle <pebolle@tiscali.nl>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 06:26:44PM +0400, James Bottomley wrote:
> On Wed, 2014-05-28 at 03:41 -0700, Christoph Hellwig wrote:
> > Looks good,
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > And I have to disagree with James here, removing code that isn't even
> > compiled always is an improvement, especially for an unmaintained
> > driver.
> 
> Well, as I said, this is in theory a maintained driver, so just get an
> ack from Russell and this debate is moot.

I don't see any harm in removing this - I don't think I've owned any
SCSI devices which supported linked commands, which is why I never
put much effort into it.  As no one else seems to care about it (given
the number of years it's been left alone), removing the linked command
stuff is fine.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
