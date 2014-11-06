From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] scsi: missing braces in scsi_extd_sense_format()
Date: Wed, 5 Nov 2014 22:39:32 -0800
Message-ID: <20141106063932.GB26433@infradead.org>
References: <20141105203837.GA26314@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaKFGjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 01:39:33 -0500
Content-Disposition: inline
In-Reply-To: <20141105203837.GA26314@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, Nov 05, 2014 at 11:38:37PM +0300, Dan Carpenter wrote:
> There were missing curly braces so we always return the first
> additional2[] string.
> 
> Fixes: 7046d2fa6dbd ('scsi: use sdev as argument for sense code printing')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks! 
