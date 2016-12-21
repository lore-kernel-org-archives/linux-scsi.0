From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -next] scsi: qedi: fix build, depends on UIO
Date: Tue, 20 Dec 2016 23:35:38 -0800
Message-ID: <20161221073537.GA28607@infradead.org>
References: <26cb8213-7474-0563-67f8-c6b85ee0f024@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42435 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750721AbcLUHfi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2016 02:35:38 -0500
Content-Disposition: inline
In-Reply-To: <26cb8213-7474-0563-67f8-c6b85ee0f024@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.or>, QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Tue, Dec 20, 2016 at 08:43:30AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build of SCSI qedi driver. It uses uio interfaces so it
> should depend on UIO.
> 
> ERROR: "uio_unregister_device" [drivers/scsi/qedi/qedi.ko] undefined!
> ERROR: "uio_event_notify" [drivers/scsi/qedi/qedi.ko] undefined!
> ERROR: "__uio_register_device" [drivers/scsi/qedi/qedi.ko] undefined!

Why is it hiding an uio driver in an iscsi offload driver?
