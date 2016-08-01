From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] nvme-fabrics: Add host_traddr options field to host
 infrastructure
Date: Mon, 1 Aug 2016 04:20:35 -0700
Message-ID: <20160801112035.GD28246@infradead.org>
References: <579a9c9b.pfetMBhIGNhCI9uD%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45968 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbcHALzY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2016 07:55:24 -0400
Content-Disposition: inline
In-Reply-To: <579a9c9b.pfetMBhIGNhCI9uD%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Thu, Jul 28, 2016 at 05:00:27PM -0700, James Smart wrote:
> 
> Add the host_traddr field to allow specification of the host-port
> connection info for the transport. Will be used by FC transport.
> 
> Signed-off-by: James Smart <james.smart@broadcom.com>

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
