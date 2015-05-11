From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: Do not set cmd_per_lun to 1 in the host template
Date: Mon, 11 May 2015 02:07:34 -0700
Message-ID: <20150511090734.GA28820@infradead.org>
References: <1430290654-109136-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35228 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbbEKJHh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 05:07:37 -0400
Content-Disposition: inline
In-Reply-To: <1430290654-109136-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Wed, Apr 29, 2015 at 08:57:34AM +0200, Hannes Reinecke wrote:
> '0' is now used as the default cmd_per_lun value,
> so there's no need to explicitly set it to '1' in the
> host template.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
