From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: linux-next: Tree for September 20 (scsi/pcmcia/nsp_cs.c)
Date: Mon, 20 Sep 2010 19:42:55 +0200
Message-ID: <20100920174255.GA16938@isilmar-3.linta.de>
References: <20100920161239.f204a507.sfr@canb.auug.org.au> <20100920091811.551ee35a.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100920091811.551ee35a.randy.dunlap@oracle.com>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, linux-pcmcia@lists.infradead.org, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
List-Id: linux-scsi@vger.kernel.org

Thanks for testing, should be fixed for tomorrow.

On Mon, Sep 20, 2010 at 09:18:11AM -0700, Randy Dunlap wrote:
> On Mon, 20 Sep 2010 16:12:39 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100917:
> 
> 
> drivers/scsi/pcmcia/nsp_cs.c:1573: error: 'cfg' undeclared (first use in this function)
> drivers/scsi/pcmcia/nsp_cs.c:1592: error: dereferencing pointer to incomplete type
> drivers/scsi/pcmcia/nsp_cs.c:1595: error: dereferencing pointer to incomplete type
> drivers/scsi/pcmcia/nsp_cs.c:1697: error: 'struct pcmcia_device' has no member named 'win'
> 
> 
> (rand)config is attached.
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
