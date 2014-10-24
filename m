From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv8 00/27] scsi logging update (the boring part)
Date: Fri, 24 Oct 2014 07:54:15 -0700
Message-ID: <20141024145415.GB2940@infradead.org>
References: <1414153627-2863-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39335 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbaJXOyR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2014 10:54:17 -0400
Content-Disposition: inline
In-Reply-To: <1414153627-2863-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org

On Fri, Oct 24, 2014 at 02:26:40PM +0200, Hannes Reinecke wrote:
> here is now the eigth iteration of my scsi logging update.
> With this I've updated the patch to ratelimit I/O error messages
> as suggested by Robert Elliott.
> Additionally I've updated it to core-for-3.19 and included the
> missing hunks for ufs as requested by Christoph Hellwig.

This looks good to me.  I'll apply it once Robert gives me ACKs for the
new patches at the end of the series and it passes local sanity testing.
