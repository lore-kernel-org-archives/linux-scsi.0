From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/23] 53c700: remove scsi_print_sense() usage
Date: Tue, 30 Sep 2014 07:55:32 -0700
Message-ID: <20140930145532.GD1206@infradead.org>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
 <1412077852-40893-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaI3Oze (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 10:55:34 -0400
Content-Disposition: inline
In-Reply-To: <1412077852-40893-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Tue, Sep 30, 2014 at 01:50:37PM +0200, Hannes Reinecke wrote:
> The 53c700 driver would be using scsi_print_sense() in a debug
> statement, which was never compiled in. Plus the same information
> can get retrieved with logging. So remove it.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
