From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Perverting cciss
Date: Thu, 5 Apr 2007 11:03:26 +0100
Message-ID: <20070405100326.GA19092@infradead.org>
References: <4614C82E.1020100@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37615 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbXDEKDb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Apr 2007 06:03:31 -0400
Content-Disposition: inline
In-Reply-To: <4614C82E.1020100@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Miller <mike.miller@hp.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Apr 05, 2007 at 11:58:06AM +0200, Hannes Reinecke wrote:
> Hi All,
> 
> this patch adds the SG_IO ioctl to the cciss driver.
> As the driver is capable of sending SCSI CDBs to the controller there is
> no reason why we shouldn't exploit it.
> This way we get to use all the nice sg_utils for the cciss driver.
> And a persistent device name for free.

Instead of adding yet another implementation of SG_IO please implement
support for REQ_TYPE_BLOCK_PC requests and add all the nice block layer
passthrough ioctls to it.

> Makes one wonder why this one is not implemented as a SCSI driver in the
> first place.

It probably should have been a scsi driver, but it's far too late now.

