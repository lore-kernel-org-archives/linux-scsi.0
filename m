From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/16] gdth: Make one abuse of scsi_cmnd less obvious
Date: Sun, 30 Sep 2007 22:28:13 +0100
Message-ID: <20070930212813.GD13343@infradead.org>
References: <46FFFC8C.6080804@panasas.com> <47000367.6090402@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40372 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbXI3V20 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 17:28:26 -0400
Content-Disposition: inline
In-Reply-To: <47000367.6090402@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Sep 30, 2007 at 10:13:27PM +0200, Boaz Harrosh wrote:
> 
>   Rather than having internal commands abuse scsi_done to call
>   gdth_scsi_done, have all the places that use to call scsi_done directly
>   call gdth_scsi_done, which now checks whether the command was internal,
>   and calls scsi_done if not.

I think it would be better if your whole patch series goes ontop of
willy's ->done removal series instead.  I really hope we can get that
one into scsi-misc ASAP.

