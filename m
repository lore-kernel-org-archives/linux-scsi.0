From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/22] scsi: dump sense buffer only for debugging
Date: Sun, 31 Aug 2014 15:09:04 -0700
Message-ID: <20140831220904.GD16432@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43245 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaHaWJG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 18:09:06 -0400
Content-Disposition: inline
In-Reply-To: <1409247216-76074-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On Thu, Aug 28, 2014 at 07:33:22PM +0200, Hannes Reinecke wrote:
> Dumping the entire sense buffer might overwhelm the logging functions,
> so suppress it per default.

Call me dumb, but I don't see anything in here that limits the dumps
to debug output.

Also if you return boolean-like values please use the bool type for it.
Also please switch scsi_normalize_sense over to return bool as well
while you're at it.

