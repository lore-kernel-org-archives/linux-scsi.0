From: Ben Collins <bcollins@debian.org>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: Fri, 27 Feb 2004 07:30:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040227123009.GD4019@phunnypharm.org>
References: <1077842444.2662.123.camel@mulgrave> <20040227005601.GA6127@one-eyed-alien.net> <20040227010411.GB819@phunnypharm.org> <1077868581.4443.0.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bristol.phunnypharm.org ([65.207.35.130]:27353 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S262693AbUB0MbS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 07:31:18 -0500
Content-Disposition: inline
In-Reply-To: <1077868581.4443.0.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Feb 27, 2004 at 08:56:22AM +0100, Arjan van de Ven wrote:
> On Fri, 2004-02-27 at 02:04, Ben Collins wrote:
> > On Thu, Feb 26, 2004 at 04:56:01PM -0800, Matthew Dharm wrote:
> > > My only concern with something like this is the userspace race problem.
> > > i.e the following sequence of events:
> > > 
> > > (1) User uses cdrecord -scanbus to locate their device (host:bus:dev:lun)
> > > (2) HBA is disconnected 
> > > (3) New HBA is added
> > > (4) User issues command to host:bus:dev:lun, and addresses the wrong device
> > > 
> > > While the current system doesn't prevent this, it makes it a much more
> > > difficult situation to happen.
> > 
> > Surely the user would have to have known that one device was
> > disconnected and another connected. Same thing could already be said for
> > the scsi device allocation (sda, sdb, and sg0, sg1, sg2, etc...).
> 
> surely everyone is using cdrecord -dev=/dev/scd5  by now and not the 
> host:bus:dev crap...

scsidev: '/dev/sg1'
devname: '/dev/sg1'
scsibus: -2 target: -2 lun: -2
Warning: Open by 'devname' is unintentional and not supported.


-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
WatchGuard - http://www.watchguard.com/
