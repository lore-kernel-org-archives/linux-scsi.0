From: Ben Collins <bcollins@debian.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 9 Jul 2005 13:53:03 -0400
Message-ID: <20050709175303.GC29099@phunnypharm.org>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de> <1120922306.5008.5.camel@mulgrave> <20050709162712.GB27347@phunnypharm.org> <1120927030.3176.39.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:40416 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261647AbVGIRxF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Jul 2005 13:53:05 -0400
Content-Disposition: inline
In-Reply-To: <1120927030.3176.39.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux1394-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, James Bottomley <James.Bottomley@SteelEye.com>

On Sat, Jul 09, 2005 at 06:37:10PM +0200, Arjan van de Ven wrote:
> On Sat, 2005-07-09 at 12:27 -0400, Ben Collins wrote:
> > If it was orphaned it was done so mistakenly. I maintain that code, and
> > linux1394.
> > 
> > Aside from that, the the change was pushed into the mainstream kernel
> > without going through our repository, which means it would have been
> > caught before going to all of our users (most of users of ieee1394 on
> > linux use it for sbp2).
> > 
> > THese changes break sbp2, and we'll need to revert them in the main stream
> > kernel until the patch is tested and fixed in our tree.
> > 
> 
> you can't revert the changes done to the locking really.... the API
> changed. Also I can't imagine these breaking at all.
> 
> Does ieee1394 tree have a git tree that james could pull? (like akpm
> pulls many trees I guess at least sbp2 should be pulled into the scsi
> tree)

No git tree, we've been strictly subversion lately. I may end up creating
a script to sync a git tree soon.

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/
