From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/22] Use sdev as argument for scsi_print_result
Date: Sun, 31 Aug 2014 15:11:17 -0700
Message-ID: <20140831221117.GE16432@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaHaWLT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 18:11:19 -0400
Content-Disposition: inline
In-Reply-To: <1409247216-76074-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

Please also remove the now useless sd_print_result wrapper.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

