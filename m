From: Ben Collins <bcollins@debian.org>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: Fri, 27 Feb 2004 07:43:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040227124314.GF4019@phunnypharm.org>
References: <1077842444.2662.123.camel@mulgrave> <20040227005601.GA6127@one-eyed-alien.net> <20040227010411.GB819@phunnypharm.org> <1077868581.4443.0.camel@laptop.fenrus.com> <20040227123009.GD4019@phunnypharm.org> <20040227123906.GB25779@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bristol.phunnypharm.org ([65.207.35.130]:38105 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S262848AbUB0MoX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 07:44:23 -0500
Content-Disposition: inline
In-Reply-To: <20040227123906.GB25779@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Arjan van de Ven <arjanv@redhat.com>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Feb 27, 2004 at 12:39:06PM +0000, Matthew Wilcox wrote:
> On Fri, Feb 27, 2004 at 07:30:09AM -0500, Ben Collins wrote:
> > On Fri, Feb 27, 2004 at 08:56:22AM +0100, Arjan van de Ven wrote:
> > > surely everyone is using cdrecord -dev=/dev/scd5  by now and not the 
> > > host:bus:dev crap...
> > 
> > scsidev: '/dev/sg1'
> > devname: '/dev/sg1'
> > scsibus: -2 target: -2 lun: -2
> > Warning: Open by 'devname' is unintentional and not supported.
> 
> Yeah, we need to patch that warning out of the debian cdrecord packages.

Even still, if the real bus number is > 15, it doesn't recognize the device.

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
WatchGuard - http://www.watchguard.com/
