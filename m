From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 14:43:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424144303.A2730@beaverton.ibm.com>
References: <UTC200304241859.h3OIxjh16776.aeb@smtp.cwi.nl> <20030424121409.C10511@one-eyed-alien.net> <1051215651.1754.71.camel@mulgrave> <20030424135932.D10511@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bi01p1.co.us.ibm.com ([32.97.110.142]:22212 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S264473AbTDXVes (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 17:34:48 -0400
Content-Disposition: inline
In-Reply-To: <20030424135932.D10511@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Thu, Apr 24, 2003 at 01:59:32PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Andries.Brouwer@cwi.nl, afafc@rnl.ist.utl.pt, Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, stelian@popies.net, torvalds@transmeta.com

On Thu, Apr 24, 2003 at 01:59:32PM -0700, Matthew Dharm wrote:
> On Thu, Apr 24, 2003 at 04:20:50PM -0400, James Bottomley wrote:

> > I think the evpd code can be thrown out into user land (where the rules
> > governing how it's used can be much more flexible).  All we really use
> > it for is to get a unique name.  However, even WWN inquiries don't
> > always guarantee even that...
> 
> Well, I'd love to see a patch to do that.  But I seem to recall someone
> being opposed to that idea.... maybe I'm just imagining that.

I wanted it to stay for scsi mid-level multi-path usage, but multi-path
isn't in the kernel, and if multi-path wants to use it in-kernel, we can
carry the deleted code as a patch or better yet use some sort of
user-initiated scanning (maybe not full user scsi scanning for now, just
something that allows synchronized user intervention to get/set id's
between the scsi_scan_host and the scsi_attach_device calls.)

And we want some sort of id for udev, but that can be done in user space.

So kill it before it's too late.

-- Patrick Mansfield
