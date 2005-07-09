From: Ben Collins <bcollins@debian.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 9 Jul 2005 13:51:18 -0400
Message-ID: <20050709175118.GB29099@phunnypharm.org>
References: <20050709162712.GB27347@phunnypharm.org> <200507091700.j69H0q5Y029204@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:39136 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261643AbVGIRvT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Jul 2005 13:51:19 -0400
Content-Disposition: inline
In-Reply-To: <200507091700.j69H0q5Y029204@einhorn.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On Sat, Jul 09, 2005 at 07:00:52PM +0200, Stefan Richter wrote:
> On  9 Jul, Ben Collins wrote:
> > If it was orphaned it was done so mistakenly. I maintain that code, and
> > linux1394.
> 
> sbp2 and eth1394 have been listed as orphan since linux-2.6.12.

Can't see how the most used driver in our repo can be considered orphaned.
I'm a little irritated that the change occured. I've sent a patch to Linus
to put SBP2 back under my name.

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/
