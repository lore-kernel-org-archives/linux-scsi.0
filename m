From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: block layer sg, bsg
Date: Wed, 4 Aug 2004 11:56:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040804155643.GA31562@havoc.gtf.org>
References: <20040804085000.GH10340@suse.de> <20040804075215.155c06ac.davem@redhat.com> <20040804150403.GU10340@suse.de> <20040804084429.7de77cd7.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([216.162.42.101]:59330 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S267319AbUHDP4p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 11:56:45 -0400
Content-Disposition: inline
In-Reply-To: <20040804084429.7de77cd7.davem@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@redhat.com>
Cc: Jens Axboe <axboe@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Aug 04, 2004 at 08:44:29AM -0700, David S. Miller wrote:
> Or use a more portable well-defined type which does not change
> size nor layout between 32-bit and 64-bit environments.

IMO if this (the above) is not done, the interface needs work.

For interfaces that replace ioctl(2) with read(2)/write(2), for passing
data structures to/from the kernel, Al has rightly suggested that these
structures be not only fixed size (as David described above), but also
fixed-endian.

	Jeff



