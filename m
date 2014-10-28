From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 27/27] scsi: ratelimit I/O error messages
Date: Tue, 28 Oct 2014 10:57:09 -0700
Message-ID: <20141028175709.GA8088@infradead.org>
References: <1414153627-2863-1-git-send-email-hare@suse.de>
 <1414153627-2863-28-git-send-email-hare@suse.de>
 <94D0CD8314A33A4D9D801C0FE68B4029593375F6@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53801 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaJ1R5M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2014 13:57:12 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593375F6@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Oct 24, 2014 at 09:00:15PM +0000, Elliott, Robert (Server Storage) wrote:
> Assuming the MLQUEUE -> MLCOMPLETE fix is put back in,
> you may add:
> Tested-by: Robert Elliott <elliott@hp.com>
> Reviewed-by: Robert Elliott <elliott@hp.com> 

Does this apply just to this patch or the whole series?
