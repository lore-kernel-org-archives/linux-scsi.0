From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] Use sdev_scsi2lun for SCSI parallel drivers
Date: Sat, 5 Jul 2014 02:41:47 -0700
Message-ID: <20140705094147.GA18130@infradead.org>
References: <1404474875-109997-1-git-send-email-hare@suse.de>
 <1404474875-109997-2-git-send-email-hare@suse.de>
 <20140704134437.GA12345@infradead.org>
 <53B6B646.5080301@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbaGEJlw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jul 2014 05:41:52 -0400
Content-Disposition: inline
In-Reply-To: <53B6B646.5080301@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Fri, Jul 04, 2014 at 04:12:22PM +0200, Hannes Reinecke wrote:
> >So what would be set in the upper 48 bits for those drivers?  We receive
> >the LUN over the wire to start with.
> >
> None. All these devices are physically incapable of receiving or sending
> LUNs more that a byte wide.

So what problems does this patch fix then?

