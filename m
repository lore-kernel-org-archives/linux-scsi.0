From: Matthew Wilcox <willy@debian.org>
Subject: Re: 2.6.3 CONFIG_SCSI_AIC7 X X X Kconfig bug
Date: Thu, 11 Mar 2004 13:10:40 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040311131040.GH2148@parcelfarce.linux.theplanet.co.uk>
References: <20040308211148.08cd89ff.rddunlap@xenotime.net> <20040311124646.GG2148@parcelfarce.linux.theplanet.co.uk> <20040311125333.GC19457@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:21484 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261248AbUCKNKl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 08:10:41 -0500
Content-Disposition: inline
In-Reply-To: <20040311125333.GC19457@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: Matthew Wilcox <willy@debian.org>, "Randy.Dunlap" <rddunlap@xenotime.net>, linux-scsi@vger.kernel.org, jejb <james.bottomley@steeleye.com>, gibbs@scsiguy.com

On Thu, Mar 11, 2004 at 01:53:33PM +0100, Olaf Hering wrote:
>  On Thu, Mar 11, Matthew Wilcox wrote:
> 
> >  
> >  config SCSI_SATA
> >  	bool "Serial ATA (SATA) support"
> > -	depends on SCSI && EXPERIMENTAL
> > +	depends on EXPERIMENTAL
> >  	help
> >  	  This driver family supports Serial ATA host controllers
> >  	  and devices.
> > @@ -397,7 +397,7 @@ config SCSI_SATA
> >  
> >  config SCSI_SATA_SVW
> >  	tristate "ServerWorks Frodo / Apple K2 SATA support (EXPERIMENTAL)"
> > -	depends on SCSI_SATA && PCI && EXPERIMENTAL
> > +	depends on SCSI_SATA && PCI && (X86 || PPC) && EXPERIMENTAL
> 
> how do you handle the SCSI=m here? sata remains =y. I havent tried to
> load scsi_mod and sd_mod, is SCSI=m supposed to work for SATA?

Putting the 'depends on SCSI' attribute on the menu means it applies to
every item in the menu.  So if SCSI=m, SCSI_SATA would also be constrained
to 'm' or 'n'.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
