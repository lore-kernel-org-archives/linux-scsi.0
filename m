From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 0/6] PS3 Storage Drivers for 2.6.23, take 4
Date: Tue, 10 Jul 2007 10:32:41 +0200
Message-ID: <20070710083241.GV13902@kernel.dk>
References: <20070704132212.726923000@pademelon.sonytel.be> <Pine.LNX.4.62.0707100944470.22782@pademelon.sonytel.be> <20070710075506.GS13902@kernel.dk> <18067.15564.241168.217875@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:4839 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761047AbXGJIc1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jul 2007 04:32:27 -0400
Content-Disposition: inline
In-Reply-To: <18067.15564.241168.217875@cargo.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jul 10 2007, Paul Mackerras wrote:
> Jens Axboe writes:
> 
> > I have no objections to the block bits, however I feel uneasy merging
> > the full patchset unless patch #1 has been acked by the platform person.
> 
> I have the first 3 patches in my queue, so yes I've acked it.  It's
> probably easiest if the remaining 3 go through my queue once they've
> been acked - or if you prefer, you can push #4 via your tree once I've
> got Linus to pull my tree.  Let me know either way.

If you already have the 3 first patches, just slurp up the rest as well.
No point in making it more complicated than we have to.

-- 
Jens Axboe

