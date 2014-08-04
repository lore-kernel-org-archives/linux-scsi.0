From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: use correct formats in printk()
Date: Mon, 4 Aug 2014 03:59:58 -0700
Message-ID: <20140804105958.GA18025@infradead.org>
References: <1407142117-23140-1-git-send-email-martink@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaHDLAD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2014 07:00:03 -0400
Content-Disposition: inline
In-Reply-To: <1407142117-23140-1-git-send-email-martink@posteo.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Kepplinger <martink@posteo.de>
Cc: ballabio_dario@emc.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>

On Mon, Aug 04, 2014 at 10:48:37AM +0200, Martin Kepplinger wrote:
> Use %llu for u64 and %u for int. Not the other way round.

I've already queued up an equivalent fix in my core-for-3.17 branch,
I just need James to pull it into the scsi for-next tree.

