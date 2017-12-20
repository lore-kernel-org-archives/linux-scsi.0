From: Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: Re: [-next PATCH 2/4] treewide: Use DEVICE_ATTR_RW
Date: Wed, 20 Dec 2017 12:54:04 +0200
Message-ID: <20171220105404.GA29856@bitmer.com>
References: <cover.1513706701.git.joe@perches.com>
 <cd38f14f06e1f447b3159ffe8c69c0df8241bb6e.1513706701.git.joe@perches.com>
 <20171220083403.GA27231@bitmer.com>
 <1513761884.1234.83.camel@perches.com>
 <20171220093211.GA16177@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171220093211.GA16177@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Cezary Jackiewicz <cezary.jackiewicz@gmail.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>, Mathias Nyman <mathias.nyman@intel.com>, Felipe Balbi <balbi@kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>Heiko Carstens <h>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 20, 2017 at 10:32:11AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Dec 20, 2017 at 01:24:44AM -0800, Joe Perches wrote:
> > On Wed, 2017-12-20 at 10:34 +0200, Jarkko Nikula wrote:
> > > On Tue, Dec 19, 2017 at 10:15:07AM -0800, Joe Perches wrote:
> > > > Convert DEVICE_ATTR uses to DEVICE_ATTR_RW where possible.
> > [] 
> > > > diff --git a/sound/soc/omap/mcbsp.c b/sound/soc/omap/mcbsp.c
> > []
> > > > @@ -854,7 +854,7 @@ static ssize_t dma_op_mode_store(struct device *dev,
> > > >  	return size;
> > > >  }
> > > >  
> > > > -static DEVICE_ATTR(dma_op_mode, 0644, dma_op_mode_show, dma_op_mode_store);
> > > > +static DEVICE_ATTR_RW(dma_op_mode);
> > > >  
> > > 
> > > While I can ack this part here if it helps generic cleanup effort I
> > > don't understart would it improve code readability in general? Mode 644
> > > is clear and don't need any grepping but for DEVICE_ATTR_RW() I had to go
> > > through all of these files in order to see what does it mean:
> 
> Yeah, 644 is "clear", but _RW() is even more clear.  Ideally I want to
> get rid of all of the "non-standard" users that set random modes of
> sysfs files, as we get it wrong too many times.  Using the "defaults" is
> much better.
> 
Fair enough. For the sound/soc/omap/ (Acked-by was missing from my
previous reply):

Acked-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
