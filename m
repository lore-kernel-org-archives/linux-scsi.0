From: Ben Collins <bcollins@debian.org>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: Thu, 26 Feb 2004 20:04:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040227010411.GB819@phunnypharm.org>
References: <1077842444.2662.123.camel@mulgrave> <20040227005601.GA6127@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bristol.phunnypharm.org ([65.207.35.130]:47572 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261672AbUB0BEq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2004 20:04:46 -0500
Content-Disposition: inline
In-Reply-To: <20040227005601.GA6127@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Feb 26, 2004 at 04:56:01PM -0800, Matthew Dharm wrote:
> My only concern with something like this is the userspace race problem.
> i.e the following sequence of events:
> 
> (1) User uses cdrecord -scanbus to locate their device (host:bus:dev:lun)
> (2) HBA is disconnected 
> (3) New HBA is added
> (4) User issues command to host:bus:dev:lun, and addresses the wrong device
> 
> While the current system doesn't prevent this, it makes it a much more
> difficult situation to happen.

Surely the user would have to have known that one device was
disconnected and another connected. Same thing could already be said for
the scsi device allocation (sda, sdb, and sg0, sg1, sg2, etc...).

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
WatchGuard - http://www.watchguard.com/
