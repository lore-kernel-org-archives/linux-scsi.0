From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 15:03:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031200350.GA30047@redhat.com>
References: <1036092072.8584.118.camel@irongate.swansea.linux.org.uk> <Pine.BSF.4.21.0210311126360.23076-100000@beppo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.BSF.4.21.0210311126360.23076-100000@beppo>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <mjacob@feral.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Mike Brown <mbrown@emc.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org

On Thu, Oct 31, 2002 at 11:30:57AM -0800, Matthew Jacob wrote:
> 
> 
> > On Thu, 2002-10-31 at 18:28, Matthew Jacob wrote:
> > > > 3) Linux should be using the Report Luns command to determine how
> > > >    many luns are on a device and at what locations.  This might
> > > >    even allow you to never probe more than 8 luns on a SCSI 2
> > > >    device unless they support this command.  Does the Symetrix support
> > > >    it?  Going beyond 8 luns on a SCSI2 device is really a hack
> > > >    otherwise.
> > > 
> > > Absolutely.
> > 
> > Now is the right time to fix this properly for 2.5
> > 
> > 
> 
> Well, yes.

2.5 does this already.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
