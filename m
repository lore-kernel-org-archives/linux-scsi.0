From: Ben Collins <bcollins@debian.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Thu, 14 Jul 2005 21:43:12 -0400
Message-ID: <20050715014312.GI13229@phunnypharm.org>
References: <1120926901.5008.12.camel@mulgrave> <200507091656.j69GuP5Y028863@einhorn.in-berlin.de> <20050715005309.GB14816@ime.usp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:27014 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S263115AbVGOBnS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2005 21:43:18 -0400
Content-Disposition: inline
In-Reply-To: <20050715005309.GB14816@ime.usp.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rog?rio Brito <rbrito@ime.usp.br>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, James.Bottomley@SteelEye.com, arjan@infradead.org

Can you give the latest git tree, plus the latest linux1394 repo a try?

On Thu, Jul 14, 2005 at 09:53:09PM -0300, Rog?rio Brito wrote:
> First of all, thank you very much for still taking this issue into
> consideration.
> 
> Unfortunately, I was submitted to a surgery and only now I am recovered
> enough to have access to computers (and I experienced the worst pains that
> I have ever felt in my entire life this past week).
> 
> Anyway, I will still keep the data that I have on
> <http://www.ime.usp.br/~rbrito/bug/> if it helps chasing the bug.
> 
> On Jul 09 2005, Stefan Richter wrote:
> > On  9 Jul, James Bottomley wrote:
> > > What's the breakage?
> > 
> > There was one report from a -mm tester (Rog?rio Brito) who needed to
> > revert the TYPE_RBC changes to sbp2.[ch]. Else the initial inquiry would
> > fail. See the link to the archive in my initial post. Summary of that
> > report:
> (...)
> > To make the matter a bit more complicated, Rog?rio's FireWire disk has
> > got another problem with the ieee1394 base driver. Rog?rio and I will
> > try to work these two (perhaps orthogonal) problems out.
> 
> If you want me to experiment with anything, please let me know.
> 
> Already reporting to James the contents of
> /sys/class/scsi_device/<dev>/device/type when the device isn't configured
> (I'm using a -rc2-mm1 kernel here; vanilla -mm, that is), I get:
> 
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> rbrito@dumont:~$ cat /sys/class/scsi_device/0\:0\:0\:0/device/type 
> 14
> rbrito@dumont:~$ 
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> 
> If anything else is important, please, don't hesitate to ask.
> 
> 
> Thank you very much, Rog?rio.
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
