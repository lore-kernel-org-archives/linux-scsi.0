From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/23] scsi: stop decoding if scsi_normalize_sense() fails
Date: Tue, 30 Sep 2014 07:56:22 -0700
Message-ID: <20140930145622.GE1206@infradead.org>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
 <1412077852-40893-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44203 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaI3O4Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 10:56:24 -0400
Content-Disposition: inline
In-Reply-To: <1412077852-40893-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Tue, Sep 30, 2014 at 01:50:38PM +0200, Hannes Reinecke wrote:
> If scsi_normalize_sense() fails we couldn't decode the sense
> buffer, and the scsi_sense_hdr fields are invalid.
> For those cases we should rather dump the sense buffer
> and not try to decode invalid fields.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
