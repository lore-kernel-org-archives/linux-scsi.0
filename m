From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REPOST v2] [PATCH 1/1] lpfc: Add iotag memory barrier
Date: Mon, 19 May 2014 07:07:07 -0700
Message-ID: <20140519140707.GA13015@infradead.org>
References: <1400508269.10454.1.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59094 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaESOHI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2014 10:07:08 -0400
Content-Disposition: inline
In-Reply-To: <1400508269.10454.1.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org

On Mon, May 19, 2014 at 10:04:29AM -0400, James Smart wrote:
> Prior patch still had a whitespace error. This should be the good one.

FYI, I fixed thos manually when I picked up the patch for the scsi-queue
tree.

