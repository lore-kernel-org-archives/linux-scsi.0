From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: 27 Feb 2004 10:37:13 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077899833.2157.82.camel@mulgrave>
References: <1077842444.2662.123.camel@mulgrave>
	<20040227124811.A32109@infradead.org> <1077894499.1806.14.camel@mulgrave>
	<20040227151551.GK4019@phunnypharm.org> <1077895775.2157.22.camel@mulgrave>
	 <20040227153247.GL4019@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:59613 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263038AbUB0QhW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 11:37:22 -0500
In-Reply-To: <20040227153247.GL4019@phunnypharm.org>
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-02-27 at 09:32, Ben Collins wrote:
> On the same token, if you hot plug/unplug a single device (not a host)
> on the same host, you will already have this problem. This wont make the
> problem any worse or better. Devices are more likely to get
> plugged/unplugged anyway (well, in the case of usb/firewire you
> plug/unplug a host/dev combination, but still).

Simply having races is not an excuse for introducing more, particularly
when they're under our control.

This represents a behaviour change in a stable kernel introducing a
potential problem in hotplug and solving a fixable issue in a single
user application tool.

What I'm not yet convinced of is that the benefits outweigh the risks.

James


