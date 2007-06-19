From: Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Tue, 19 Jun 2007 07:53:58 +0200
Message-ID: <20070619055358.GD18542@lst.de>
References: <1181918159.25228.543.camel@pmac.infradead.org> <Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be> <20070615171545.316dfac7@the-village.bc.nu> <20070615.141917.85409547.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:36318 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255AbXFSFyd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jun 2007 01:54:33 -0400
Content-Disposition: inline
In-Reply-To: <20070615.141917.85409547.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, axboe@kernel.dk, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org, Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org

On Fri, Jun 15, 2007 at 02:19:17PM -0700, David Miller wrote:
> Another quirk I have to deal with is that under LDOMs you
> can export full disks and also just slices.  So I'll have
> to get down into the partition machinery to support that
> somehow.

What's the problem with that?  Partition machinery is perfectly
fine with just getting a raw disk without a partition table,
and it obviously doesn't care if the raw disk it sees is part
of a partition on the storage server.
