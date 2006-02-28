From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 12/13] ATA ACPI: use scsi_bus_shutdown for SATA/PATA
Date: Tue, 28 Feb 2006 21:22:19 +0100
Message-ID: <20060228202219.GA5483@elf.ucw.cz>
References: <20060222133241.595a8509.randy_d_dunlap@linux.intel.com> <20060222140608.2de3fa24.randy_d_dunlap@linux.intel.com> <20060228115858.GF4081@elf.ucw.cz> <20060228114424.0fb2d495.randy_d_dunlap@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060228114424.0fb2d495.randy_d_dunlap@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Randy Dunlap <randy_d_dunlap@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, akpm@osdl.org, jgarzik@pobox.com, james.bottomley@steeleye.com
List-Id: linux-scsi@vger.kernel.org

Hi!

> > > +	if (sht->shutdown)
> > > +		sht->shutdown(sdev);
> > > +}
> > > +
> > >  struct bus_type scsi_bus_type = {
> > >          .name		= "scsi",
> > >          .match		= scsi_bus_match,
> > >  	.suspend	= scsi_bus_suspend,
> > >  	.resume		= scsi_bus_resume,
> > > +	.shutdown	= scsi_bus_shutdown,
> > >  };
> > 
> > Whitespace?
> 
> Not a problem in my addition.  Are you requesting me to fix
> the other lines?

Ahha, sorry, I seen wrong whitespace, and did not realize it was there
already. Yes, it would be nice to to fix whitespace around
modifications.

...and sorry about all the comments about added debugging. I did not
realize Jeff actually wants it that way. (I seriously dislike
excessive debugging in ACPI case.)
								Pavel
-- 
Web maintainer for suspend.sf.net (www.sf.net/projects/suspend) wanted...
