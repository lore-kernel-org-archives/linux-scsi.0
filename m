From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix off-by-one LUN check in scsi_scan_host_selected()
Date: Fri, 17 Oct 2014 06:24:36 -0700
Message-ID: <20141017132436.GK16538@infradead.org>
References: <20141009123948.ed14b2f96456fecdb4af960b@clara.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaJQNYg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2014 09:24:36 -0400
Content-Disposition: inline
In-Reply-To: <20141009123948.ed14b2f96456fecdb4af960b@clara.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Knibbs <markk@clara.co.uk>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 09, 2014 at 12:39:48PM +0100, Mark Knibbs wrote:
> Hi,
> 
> The Scsi_Host structure max_lun field is the maximum allowed LUN plus 1. So
> a LUN value is invalid if >= max_lun.
> 
> Signed-off-by: Mark Knibbs <markk@clara.co.uk>

Ah, there we go.  Thanks!


Reviewed-by: Christoph Hellwig <hch@lst.de>
