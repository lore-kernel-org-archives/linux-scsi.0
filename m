From: Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Tue, 19 Jun 2007 10:15:46 +0200
Message-ID: <20070619081546.GA25336@lst.de>
References: <1181947242.3600.8.camel@mulgrave.il.steeleye.com> <20070615.160858.26276547.davem@davemloft.net> <20070619055629.GE18542@lst.de> <20070618.230731.11645150.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:38697 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbXFSIQY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jun 2007 04:16:24 -0400
Content-Disposition: inline
In-Reply-To: <20070618.230731.11645150.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: hch@lst.de, James.Bottomley@SteelEye.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org, Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk

On Mon, Jun 18, 2007 at 11:07:31PM -0700, David Miller wrote:
> The main disk I/O block read and write is done using descriptors
> sent to the disk server.  SCSI pass-through is provided (optionally)
> so that disk analysis tools can do things like MODE_SENSE on the
> disk.

SG_IO can easily be implemented for block devices.  See cciss in
current mainline for an example.
