From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] removel useless mod use count manipulation
Date: Sun, 17 Nov 2002 11:31:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211171731.gAHHVHO12355@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA31361
	for <linux-scsi@vger.kernel.org>; Sun, 17 Nov 2002 09:31:20 -0800
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Sat, 16 Nov 2002 21:59:01 EST." <20021117025901.GA24557@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

> This patch conflicts with one I had internally that I was still
> working  on.  I had a bit more stuff in mine than you did in yours so
> I folded your  changes into my stuff.  When I push my tree out it will
> be in there  (otherwise it would have required hand merging by someone
> else anyway).  I  just gotta wait till I go back up to the office and
> restart my test box in  order to push the changes out :-/  (shutdown
> -nr segfaulted on me) 

OK, I'll back this one out of the scsi-misc-2.5 tree I have internally before 
putting it out on the bkbits site.

James


