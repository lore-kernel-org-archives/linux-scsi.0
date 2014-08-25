From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi-mq and 3.17rc1
Date: Mon, 25 Aug 2014 07:50:33 -0700
Message-ID: <20140825145033.GA21318@infradead.org>
References: <94D0CD8314A33A4D9D801C0FE68B402958C22037@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54665 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911AbaHYOud (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2014 10:50:33 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C22037@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Aug 25, 2014 at 02:31:58PM +0000, Elliott, Robert (Server Storage) wrote:
> Two scsi-mq tips:
> 
> 1. Several people have been wondering how to enable scsi-mq.
> Add this to your kernel command line (e.g., in /boot/grub/grub.conf
> if using grub-1):
> 	scsi_mod.use_blk_mq=Y

Btw, I heard a few complaints about this, and one suggestion would be
to add a config option to enable it by default.  Would you or others
like this?

