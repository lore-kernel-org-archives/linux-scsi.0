From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] gdth buggy page mapping
Date: 23 Nov 2004 13:19:49 -0600
Message-ID: <1101237594.1723.17.camel@mulgrave>
References: <20041123180622.GK13174@suse.de>
	<1101235504.2016.14.camel@mulgrave>  <20041123191321.GL13174@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:52450 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261467AbUKWTT6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2004 14:19:58 -0500
In-Reply-To: <20041123191321.GL13174@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, achim_leubner@adaptec.com

On Tue, 2004-11-23 at 13:13, Jens Axboe wrote:
> On Tue, Nov 23 2004, James Bottomley wrote:
> > never done.  I think all use of the sg_dma_ macros in this driver will
> > need modifying with this change.
> 
> How so? It's internal usage in that function, it needs a one-liner to
> work.

Sorry, misread ... I thought all use of pci_map_sg was being removed
rather than just the one in gdth_copy_internal().  The patch looks fine
now.

Thanks,

James


