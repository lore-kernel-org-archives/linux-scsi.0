From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 17:41:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031174121.A8399@eng2.beaverton.ibm.com>
References: <Pine.BSF.4.21.0210311027500.23076-100000@beppo> <1036092072.8584.118.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1036092072.8584.118.camel@irongate.swansea.linux.org.uk>; from alan@lxorguk.ukuu.org.uk on Thu, Oct 31, 2002 at 07:21:12PM +0000
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mjacob@feral.com, "Justin T. Gibbs" <gibbs@scsiguy.com>, Mike Brown <mbrown@emc.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org

On Thu, Oct 31, 2002 at 07:21:12PM +0000, Alan Cox wrote:
> On Thu, 2002-10-31 at 18:28, Matthew Jacob wrote:
> > > 3) Linux should be using the Report Luns command to determine how
> > >    many luns are on a device and at what locations.  This might
> > >    even allow you to never probe more than 8 luns on a SCSI 2
> > >    device unless they support this command.  Does the Symetrix support
> > >    it?  Going beyond 8 luns on a SCSI2 device is really a hack
> > >    otherwise.
> > 
> > Absolutely.
> 
> Now is the right time to fix this properly for 2.5

REPORT LUNS is a SCSI-3 command, not SCSI-2, so it can't solve
the problem. Right?

You should be able to configure any recent EMC box (and AFAIK any
recent disk array hardware, at least IBM Shark, IBM fastt) to report
back as a SCSI-3 device.

-- Patrick Mansfield
