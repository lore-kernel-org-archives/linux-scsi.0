From: Ben Collins <bcollins@debian.org>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: Fri, 27 Feb 2004 10:15:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040227151551.GK4019@phunnypharm.org>
References: <1077842444.2662.123.camel@mulgrave> <20040227124811.A32109@infradead.org> <1077894499.1806.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bristol.phunnypharm.org ([65.207.35.130]:3547 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S263000AbUB0PRN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 10:17:13 -0500
Content-Disposition: inline
In-Reply-To: <1077894499.1806.14.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Feb 27, 2004 at 09:08:18AM -0600, James Bottomley wrote:
> On Fri, 2004-02-27 at 06:48, Christoph Hellwig wrote:
> > Well, the last patch looks sane if we want to do that.  But didn't we
> > declare the mononically increasing host numbers a feature?
> 
> This is the part that worries me too.  At the moment with monotonically
> increasing host numbers, the operation of scsi_host_lookup() is provably
> safe.  Can we prove that all uses of it are still safe if we reuse the
> host numbers?

If a driver somehow removes it's scsi host and then later attempts a
scsi_host_lookup for the id, I think that driver is broken anyway. IOW,
it is safe as long as you aren't broken in the first place.

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
WatchGuard - http://www.watchguard.com/
