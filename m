From: Ben Collins <bcollins@debian.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 16 Jul 2005 11:56:37 -0400
Message-ID: <20050716155637.GA22044@phunnypharm.org>
References: <1120926901.5008.12.camel@mulgrave> <200507091656.j69GuP5Y028863@einhorn.in-berlin.de> <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org> <20050715155332.GA3954@ime.usp.br> <20050715172854.GJ13229@phunnypharm.org> <20050715185034.GA3903@ime.usp.br> <20050715205741.GN13229@phunnypharm.org> <20050716014225.GA9733@ime.usp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:55691 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261675AbVGPP4p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Jul 2005 11:56:45 -0400
Content-Disposition: inline
In-Reply-To: <20050716014225.GA9733@ime.usp.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rog?rio Brito <rbrito@ime.usp.br>
Cc: Ben Collins <bcollins@debian.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, James.Bottomley@SteelEye.com, arjan@infradead.org

>From your last dmesg, it appears that things are in fact working.

Are you sure that you just don't need to do modprobe sd_mod?

On Fri, Jul 15, 2005 at 10:42:25PM -0300, Rog?rio Brito wrote:
> On Jul 15 2005, Ben Collins wrote:
> > No, there are changes in the current rev of the repo. Are sure you tried
> > the latest rev?
> 
> Well, I think it is, since this is what svn tells me:
> 
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> rbrito@dumont:/usr/local/media/progs$ svn co svn://svn.linux1394.org/ieee1394/trunk/ ieee1394
> Checked out revision 1315.
> rbrito@dumont:/usr/local/media/progs$ 
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> 
> I then copied this over the ieee1394 tree of the git2 kernel and things
> stopped working (but with vanilla git2, it worked).
> 
> I will now try what Stefan told me and I will report back.
> 
> 
> Thanks, Rog?rio.
> 
> -- 
> Rog?rio Brito : rbrito@ime.usp.br : http://www.ime.usp.br/~rbrito
> Homepage of the algorithms package : http://algorithms.berlios.de
> Homepage on freshmeat:  http://freshmeat.net/projects/algorithms/

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/
