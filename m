From: Ben Collins <bcollins@debian.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sun, 10 Jul 2005 00:38:38 -0400
Message-ID: <20050710043838.GG2972@phunnypharm.org>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de> <1120922306.5008.5.camel@mulgrave> <20050709233138.GT29099@phunnypharm.org> <20050710032914.GA13883@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:51426 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261844AbVGJEik (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 00:38:40 -0400
Content-Disposition: inline
In-Reply-To: <20050710032914.GA13883@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

On Sat, Jul 09, 2005 at 11:29:14PM -0400, Jeff Garzik wrote:
> On Sat, Jul 09, 2005 at 07:31:38PM -0400, Ben Collins wrote:
> > Thing is, these don't seem to be working for SBP2. I assume these
> > conversions came from libata
> 
> Incorrect.
> 
> 
> > (since that's the only other user of them).
> 
> Incorrect.

Well, I didn't see anything else in the kernel that set the use_10_*
settings, other than libata.

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/
