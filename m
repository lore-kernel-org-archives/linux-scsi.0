From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi_execute_async should take a struct scatterlist *
Date: Tue, 7 Nov 2006 18:43:20 +0100
Message-ID: <20061107174320.GA14674@lst.de>
References: <20061104191440.GD23477@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:19387 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932753AbWKGRnb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2006 12:43:31 -0500
Content-Disposition: inline
In-Reply-To: <20061104191440.GD23477@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

On Sat, Nov 04, 2006 at 08:14:40PM +0100, Christoph Hellwig wrote:
> Crrently scsi_execute_async takes a void *buffer argument that can
> be either interpreted as a kernel buffer or scatterlist pointer
> depending on what the use_sg argument is set to.  There is no user
> of the use_sg == 0 kernel buffer case and we should remove it in
> favour of type safety.
> 
> And yes, long-term we should get rid of the current scsi_execute_async
> interface entirely, struct scatterlist * doesn't make sense as a data
> structure above the block layer.

Actually I just noticed osst is using the non-sg variant.  patch
withdrawn.

