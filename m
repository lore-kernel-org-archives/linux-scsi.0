From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] nvme-fabrics: rework nvmf_get_address() for variable
 options
Date: Mon, 1 Aug 2016 04:19:55 -0700
Message-ID: <20160801111955.GB28246@infradead.org>
References: <579a9c99.RE/wCYn5/6zl6dPY%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45997 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbcHALzY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2016 07:55:24 -0400
Content-Disposition: inline
In-Reply-To: <579a9c99.RE/wCYn5/6zl6dPY%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Thu, Jul 28, 2016 at 05:00:25PM -0700, James Smart wrote:
> 
> Revise nvmf_get_address() string to account for not all options being
> present.
> 
> Signed-off-by: James Smart <james.smart@broadcom.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
