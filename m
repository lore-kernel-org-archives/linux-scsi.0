From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 5/7] st: update to use block timeout
Date: Tue, 2 Dec 2008 20:25:18 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0812022020350.6407@kai.makisara.local>
References: <1228062986.4115.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:56210 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYLBSdZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2008 13:33:25 -0500
In-Reply-To: <1228062986.4115.41.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, Jens Axboe <Jens.Axboe@oracle.com>

On Sun, 30 Nov 2008, James Bottomley wrote:

> Since we're trying to eliminate struct scsi_device timeout, the tape
> driver has to be updated to use the block queue timeout instead.  The
> tape use of scsi_device timeout looks to be self consistent, so I don't
> think this necessarily fixes any bug, but it has to be done to allow me
> to remove the timeout parameter from struct scsi_device.
> 
Looks OK and passes the simple tests.

> Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>

Thanks,
Kai
