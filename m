From: Jens Axboe <axboe@suse.de>
Subject: Re: block layer sg, bsg
Date: Wed, 4 Aug 2004 17:58:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040804155814.GW10340@suse.de>
References: <20040804085000.GH10340@suse.de> <20040804075215.155c06ac.davem@redhat.com> <20040804150403.GU10340@suse.de> <20040804084429.7de77cd7.davem@redhat.com> <20040804155643.GA31562@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:37290 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S267329AbUHDP6f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 11:58:35 -0400
Content-Disposition: inline
In-Reply-To: <20040804155643.GA31562@havoc.gtf.org>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "David S. Miller" <davem@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Aug 04 2004, Jeff Garzik wrote:
> On Wed, Aug 04, 2004 at 08:44:29AM -0700, David S. Miller wrote:
> > Or use a more portable well-defined type which does not change
> > size nor layout between 32-bit and 64-bit environments.
> 
> IMO if this (the above) is not done, the interface needs work.
> 
> For interfaces that replace ioctl(2) with read(2)/write(2), for passing
> data structures to/from the kernel, Al has rightly suggested that these
> structures be not only fixed size (as David described above), but also
> fixed-endian.

I completely agree with that, we need a different structure for other
devices as well. Show me what you'd like for libata, for instance.

-- 
Jens Axboe

