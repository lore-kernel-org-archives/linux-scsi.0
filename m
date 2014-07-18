From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] SCSI: Add a blacklist flag which enables VPD page
 inquiries
Date: Fri, 18 Jul 2014 08:04:06 -0700
Message-ID: <20140718150406.GA29709@infradead.org>
References: <yq18unuwos2.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210AbaGRPEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jul 2014 11:04:07 -0400
Content-Disposition: inline
In-Reply-To: <yq18unuwos2.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, KY Srinivasan <kys@microsoft.com>

On Tue, Jul 15, 2014 at 12:49:17PM -0400, Martin K. Petersen wrote:
>     
> Despite supporting modern SCSI features some storage devices continue to
> claim conformance to an older version of the SPC spec. This is done for
> compatibility with legacy operating systems.
> 
> Linux by default will not attempt to read VPD pages on devices that
> claim SPC-2 or older. Introduce a blacklist flag that can be used to
> trigger VPD page inquiries on devices that are known to support them.
> 
> Reported-by: KY Srinivasan <kys@microsoft.com>
> Tested-by: KY Srinivasan <kys@microsoft.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> CC: <stable@vger.kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

KY, can you send a hyperv patch that sets it to go along with this one?

