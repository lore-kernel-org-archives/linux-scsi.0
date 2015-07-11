From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: Fix sense information setting in fixed sized format
Date: Sat, 11 Jul 2015 04:27:42 -0700
Message-ID: <20150711112742.GA7883@infradead.org>
References: <1436367603-16456-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50473 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbbGKL1n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2015 07:27:43 -0400
Content-Disposition: inline
In-Reply-To: <1436367603-16456-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Wed, Jul 08, 2015 at 06:00:03PM +0300, Sagi Grimberg wrote:
> In fixed size sense format the information field is a four byte
> field.

This looks correct to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

But: this will truncate > 32bit sector numbers.  Maybe we need to
enable descriptor format sense data for large enough LUs.
