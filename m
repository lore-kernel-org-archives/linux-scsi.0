From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] removel useless mod use count manipulation
Date: Sun, 17 Nov 2002 13:14:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117181409.GA3280@redhat.com>
References: <dledford@redhat.com> <20021117025901.GA24557@redhat.com> <200211171731.gAHHVHO12355@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211171731.gAHHVHO12355@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Sun, Nov 17, 2002 at 11:31:17AM -0600, J.E.J. Bottomley wrote:
> > This patch conflicts with one I had internally that I was still
> > working  on.  I had a bit more stuff in mine than you did in yours so
> > I folded your  changes into my stuff.  When I push my tree out it will
> > be in there  (otherwise it would have required hand merging by someone
> > else anyway).  I  just gotta wait till I go back up to the office and
> > restart my test box in  order to push the changes out :-/  (shutdown
> > -nr segfaulted on me) 
> 
> OK, I'll back this one out of the scsi-misc-2.5 tree I have internally before 
> putting it out on the bkbits site.

Cool.  I'm up here working on it at the moment.  I'm also trying to track 
down the problem Doug Gilbert reported and that I was seeing last night as 
well, aka on /dev/sdc I can access /dev/sdc but not /dev/sdc1 which is a 
valid partition.  Once I've tracked that down I'll push my tree up.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
