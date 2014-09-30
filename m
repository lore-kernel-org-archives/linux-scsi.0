From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/23] scsi: remove last argument from print_opcode_name()
Date: Tue, 30 Sep 2014 07:57:23 -0700
Message-ID: <20140930145723.GF1206@infradead.org>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
 <1412077852-40893-17-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44301 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaI3O5Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 10:57:24 -0400
Content-Disposition: inline
In-Reply-To: <1412077852-40893-17-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Tue, Sep 30, 2014 at 01:50:45PM +0200, Hannes Reinecke wrote:
> print_opcode_name() was only ever called with a '0' argument
> from LLDDs and ULDs which were _not_ supporting variable length
> CDBs, so the 'if' clause was never triggered.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
