From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: should we deprecate unmaintained isa-only drivers?
Date: Sun, 11 Sep 2016 10:01:55 -0700
Message-ID: <20160911170155.GA1571@infradead.org>
References: <20141230160616.GA29149@infradead.org>
 <201503252152.53914.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45120 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756093AbcIKRB5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2016 13:01:57 -0400
Content-Disposition: inline
In-Reply-To: <201503252152.53914.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Miroslav Zagorac <zaga@fly.cc.fer.hr>, Dario Ballabio <ballabio_dario@emc.com>

On Wed, Mar 25, 2015 at 09:52:53PM +0100, Ondrej Zary wrote:
> >  - wd7000
> >  - aha1542
> >  - in2000
> >  - NCR53c406
> >  - sym53c416
> >  - u14-34f
> >  - ultrastor
> 
> NCR53c406a and sym53c416 look very similar. The register numbers and commands 
> are almost the same so NCR53c406 support could probably be added to sym53c416 
> driver (looks better of the two) and NCR53c406a driver removed. Now I have 
> cards with both chips so I'll try.

Did you get a chance to look at this project?
