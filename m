From: Christoph Hellwig <hch@infradead.org>
Subject: device support in hpasa, was: Re: OOPS from cciss_ioctl in 4.12+git
Date: Fri, 7 Jul 2017 08:00:42 -0700
Message-ID: <20170707150042.GA15445@infradead.org>
References: <alpine.LRH.2.20.1707051555130.20086@math.ut.ee>
 <20170705225134.GA31786@infradead.org>
 <alpine.LRH.2.20.1707061236010.6514@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.20.1707061236010.6514@math.ut.ee>
Sender: linux-block-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, Don Brace <don.brace@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 06, 2017 at 12:55:04PM +0300, Meelis Roos wrote:
> > Also we're trying to move people away from the cciss driver, can you
> > check if the hpsa SCSI driver works for you as well?
> 
> I have older adapter:
> 
> Compaq Computer Corporation Smart Array 64xx [0e11:0046] (rev 01)
> 
> That does not seem to be supported by hpsa AFAICS.

Looks like.  Although hpsa has support for various SA5 controllers
it seems like it decided to skip all Compaq branded controllers.

As far as I can tell we could simply add support for those to
hpsa.  Ccing hpsa folks to figure out if that's the case.
