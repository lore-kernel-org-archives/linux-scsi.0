From: Ben Collins <bcollins@debian.org>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: Fri, 27 Feb 2004 11:39:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040227163914.GO4019@phunnypharm.org>
References: <1077842444.2662.123.camel@mulgrave> <20040227124811.A32109@infradead.org> <1077894499.1806.14.camel@mulgrave> <20040227151551.GK4019@phunnypharm.org> <1077895775.2157.22.camel@mulgrave> <20040227153247.GL4019@phunnypharm.org> <1077899833.2157.82.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bristol.phunnypharm.org ([65.207.35.130]:61147 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S263036AbUB0Qkj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 11:40:39 -0500
Content-Disposition: inline
In-Reply-To: <1077899833.2157.82.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Feb 27, 2004 at 10:37:13AM -0600, James Bottomley wrote:
> On Fri, 2004-02-27 at 09:32, Ben Collins wrote:
> > On the same token, if you hot plug/unplug a single device (not a host)
> > on the same host, you will already have this problem. This wont make the
> > problem any worse or better. Devices are more likely to get
> > plugged/unplugged anyway (well, in the case of usb/firewire you
> > plug/unplug a host/dev combination, but still).
> 
> Simply having races is not an excuse for introducing more, particularly
> when they're under our control.
> 
> This represents a behaviour change in a stable kernel introducing a
> potential problem in hotplug and solving a fixable issue in a single
> user application tool.
> 
> What I'm not yet convinced of is that the benefits outweigh the risks.

The problems you keep raising already exist and aren't going to be
increased by this patch.

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
WatchGuard - http://www.watchguard.com/
