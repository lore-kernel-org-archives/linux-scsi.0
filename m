From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [SCSI] Make scsi_transfer_length take a scsi_data_buffer
 argument
Date: Fri, 25 Jul 2014 14:19:27 -0700
Message-ID: <20140725211927.GB22025@infradead.org>
References: <20140713113715.GA26031@infradead.org>
 <1406318419-7273-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760181AbaGYVT2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2014 17:19:28 -0400
Content-Disposition: inline
In-Reply-To: <1406318419-7273-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@infradead.org>

On Fri, Jul 25, 2014 at 04:00:19PM -0400, Martin K. Petersen wrote:
> For bidirectional commands we need to be able to distinguish between the
> in and out scsi_data_buffers when calculating the wire transfer length.
> Make scsi_transfer_length() take a scsi_data_buffer argument so the
> caller can choose which I/O direction the calculation should apply to.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks, this looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>
