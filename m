From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 11:30:57 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0210311126360.23076-100000@beppo>
References: <1036092072.8584.118.camel@irongate.swansea.linux.org.uk>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1036092072.8584.118.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, Mike Brown <mbrown@emc.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org



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
> 
> 

Well, yes.



