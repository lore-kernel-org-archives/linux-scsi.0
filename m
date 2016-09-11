From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: RFC: should we deprecate unmaintained isa-only drivers?
Date: Sun, 11 Sep 2016 19:33:49 +0200
Message-ID: <201609111933.49345.linux@rainbow-software.org>
References: <20141230160616.GA29149@infradead.org> <201503252152.53914.linux@rainbow-software.org> <20160911170155.GA1571@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:45580 "EHLO
        smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756123AbcIKReC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2016 13:34:02 -0400
In-Reply-To: <20160911170155.GA1571@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Miroslav Zagorac <zaga@fly.cc.fer.hr>, Dario Ballabio <ballabio_dario@emc.com>

On Sunday 11 September 2016 19:01:55 Christoph Hellwig wrote:
> On Wed, Mar 25, 2015 at 09:52:53PM +0100, Ondrej Zary wrote:
> > >  - wd7000
> > >  - aha1542
> > >  - in2000
> > >  - NCR53c406
> > >  - sym53c416
> > >  - u14-34f
> > >  - ultrastor
> >
> > NCR53c406a and sym53c416 look very similar. The register numbers and
> > commands are almost the same so NCR53c406 support could probably be added
> > to sym53c416 driver (looks better of the two) and NCR53c406a driver
> > removed. Now I have cards with both chips so I'll try.
>
> Did you get a chance to look at this project?

At first try (with some quick hacking only), the 53c406 card didn't work with 
sym53c416 driver. I haven't had time for more serious work back then. 
Hopefully I'll try harder soon.

-- 
Ondrej Zary
