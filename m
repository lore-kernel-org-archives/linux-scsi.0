From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 20/23] scsi: simplify scsi_log_(send|completion)
Date: Tue, 30 Sep 2014 08:19:34 -0700
Message-ID: <20140930151934.GA28330@infradead.org>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
 <1412077852-40893-21-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaI3PTf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 11:19:35 -0400
Content-Disposition: inline
In-Reply-To: <1412077852-40893-21-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Tue, Sep 30, 2014 at 01:50:49PM +0200, Hannes Reinecke wrote:
> Simplify scsi_log_(send|completion) by externalizing
> scsi_mlreturn_string() and always print the command address.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks,

Reviewed-by: Christoph Hellwig <hch@lst.de>
