From: Ben Collins <bcollins@debian.org>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: Fri, 27 Feb 2004 08:04:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040227130414.GH4019@phunnypharm.org>
References: <1077842444.2662.123.camel@mulgrave> <20040227124811.A32109@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bristol.phunnypharm.org ([65.207.35.130]:53721 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S262830AbUB0NFY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 08:05:24 -0500
Content-Disposition: inline
In-Reply-To: <20040227124811.A32109@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Feb 27, 2004 at 12:48:11PM +0000, Christoph Hellwig wrote:
> On Thu, Feb 26, 2004 at 06:40:43PM -0600, James Bottomley wrote:
> > I'm forwarding this to linux-scsi, which is the appropriate list to
> > scrutinise it.
> 
> Well, the last patch looks sane if we want to do that.  But didn't we
> declare the mononically increasing host numbers a feature?

I can't see how things like the device naming can work the "right" way,
but making the host numbers work in an increasing fashion would be a
feature or even a benefit.

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
WatchGuard - http://www.watchguard.com/
