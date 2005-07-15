From: Ben Collins <bcollins@debian.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Fri, 15 Jul 2005 13:28:55 -0400
Message-ID: <20050715172854.GJ13229@phunnypharm.org>
References: <1120926901.5008.12.camel@mulgrave> <200507091656.j69GuP5Y028863@einhorn.in-berlin.de> <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org> <20050715155332.GA3954@ime.usp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:51592 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S263333AbVGOR3C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2005 13:29:02 -0400
Content-Disposition: inline
In-Reply-To: <20050715155332.GA3954@ime.usp.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rog?rio Brito <rbrito@ime.usp.br>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, James.Bottomley@SteelEye.com, arjan@infradead.org

Please try with the latest trunk of our repo (just replace the direcory).

On Fri, Jul 15, 2005 at 12:53:33PM -0300, Rog?rio Brito wrote:
> Hi, all.
> 
> On Jul 14 2005, Ben Collins wrote:
> > Can you give the latest git tree, plus the latest linux1394 repo a try?
> 
> Well, I just booted with a vanilla -rc3-git2 kernel with the patch to the
> hotplug scripts that Stefan mentioned in an earlier e-mail and the
> enclosure worked this time.
> 
> I didn't try the linux1394 trunk yet.
> 
> I just uploaded the dmesg output to <http://www.ime.usp.br/~rbrito/bug/>.
> 
> 
> Thank you very much for the help, Rog?rio.
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
