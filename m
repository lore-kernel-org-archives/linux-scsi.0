From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Mon, 1 Jul 2002 15:15:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020701151553.G776@redhat.com>
References: <20020701225037.E3271-100000@localhost.my.domain> <Pine.BSF.4.21.0207011205340.62375-100000@beppo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.BSF.4.21.0207011205340.62375-100000@beppo>; from mjacob@feral.com on Mon, Jul 01, 2002 at 12:08:03PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <mjacob@feral.com>
Cc: =?iso-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>, Jeremy Higdon <jeremy@classic.engr.sgi.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org

On Mon, Jul 01, 2002 at 12:08:03PM -0700, Matthew Jacob wrote:
> Yes, exponential backoff is good in a lot of cases. BTW- this is something I
> want to put into cam_periph_error for FreeBSD- I want to make the retry after
> selection timeout also have exponential delays up to retry count.

Hmmm...what's the purpose on this BTW?  Selection timeouts on what, fiber 
or SPI or something else?

> In private mail with Doug && Pete, I managed to put myself into an untenable
> position. The problem here is that we don't have end-to-end flow control, so
> we have to *guess* when it might be good to try again. 

Yep.  Experimentation can be your friend on that.  That's what I did to 
come up with the alghorithm I was quoting.  However, I didn't try 
exponential backoff so I make no claims that it wouldn't in fact be 
better.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
