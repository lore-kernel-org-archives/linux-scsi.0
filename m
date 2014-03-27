From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] scsi: Remove CONFIG_SCSI_MULTI_LUN
Date: Thu, 27 Mar 2014 07:47:40 -0700
Message-ID: <20140327144740.GA16958@infradead.org>
References: <1386673515-87133-1-git-send-email-hare@suse.de>
 <1386673515-87133-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36033 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902AbaC0Orp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2014 10:47:45 -0400
Content-Disposition: inline
In-Reply-To: <1386673515-87133-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Tue, Dec 10, 2013 at 12:05:11PM +0100, Hannes Reinecke wrote:
> Obsolete; either use 'max_lun' if the host supports only a
> limited number of LUNs or BLIST_NOLUN if the target has
> problems addressing more than one LUN.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, I noticed the SuSE tree has various blacklist updates, might be
worth to throw them into the series as well?

