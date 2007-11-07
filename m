From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [SCSI] sym53c8xx: fix free_irq() regression in 2.6.24
Date: Wed, 7 Nov 2007 17:43:34 +0000
Message-ID: <20071107174334.GF25560@infradead.org>
References: <4730C346.4050701@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50834 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759173AbXKGRnj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 12:43:39 -0500
Content-Disposition: inline
In-Reply-To: <4730C346.4050701@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Tue, Nov 06, 2007 at 02:40:54PM -0500, Tony Battersby wrote:
> The following commit changed the pointer passed to request_irq(), but
> failed to change the pointer passed to free_irq():

Looks good.
