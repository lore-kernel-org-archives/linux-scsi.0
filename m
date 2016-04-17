From: Christoph Hellwig <hch@infradead.org>
Subject: Re: EXPORT_SYMBOL(scsi_use_blk_mq);
Date: Sun, 17 Apr 2016 11:04:41 -0700
Message-ID: <20160417180441.GA9327@infradead.org>
References: <5712ED24.60806@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51934 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbcDQSEq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Apr 2016 14:04:46 -0400
Content-Disposition: inline
In-Reply-To: <5712ED24.60806@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sat, Apr 16, 2016 at 09:55:48PM -0400, Douglas Gilbert wrote:
> Is there a good reason why 'bool scsi_use_blk_mq' declared as
> extern in scsi_hosts.h is not an exported symbol?

Yes, no module has any business looking at the symbol.
