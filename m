From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Format Unit can take many hours
Date: Tue, 11 May 2004 20:30:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040511183013.GC14789@suse.de>
References: <20040511162822.C46BFDBDB@gherkin.frus.com> <Pine.GSO.4.33.0405111243300.14297-100000@sweetums.bluetronic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:56289 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263032AbUEKSae (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2004 14:30:34 -0400
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.33.0405111243300.14297-100000@sweetums.bluetronic.net>
List-Id: linux-scsi@vger.kernel.org
To: Ricky Beam <jfbeam@bluetronic.net>
Cc: Bob Tracy <rct@gherkin.frus.com>, Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>

On Tue, May 11 2004, Ricky Beam wrote:
> On Tue, 11 May 2004, Bob Tracy wrote:
> >Moreover, it simply "feels" wrong to define a constant for something
> >that isn't...  The quick fix of increasing the timeout doesn't address
> >the underlying issue of how long a format should take, and as Ricky
> >implies, that's probably more the concern of the application rather
> >than the driver.
> 
> The real problem is a lack of being able to specify a timeout for user
> supplied commands.  In-kernel drivers can set a command timeout.  The
> IOCTL interface does not export that capability.

Noone should use that interface, period. That ioctl is about as bad an
interface as you could imagine. Use any variant of sg and you should be
fine.

-- 
Jens Axboe

