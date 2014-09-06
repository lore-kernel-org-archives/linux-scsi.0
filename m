From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/20] scsi: do not decode sense extras
Date: Fri, 5 Sep 2014 17:04:40 -0700
Message-ID: <20140906000440.GD29588@infradead.org>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
 <1409738775-80876-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56479 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaIFACV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 20:02:21 -0400
Content-Disposition: inline
In-Reply-To: <1409738775-80876-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org

On Wed, Sep 03, 2014 at 12:06:02PM +0200, Hannes Reinecke wrote:
> Currently we're only decoding sense extras for tape devices.
> And even there only for fixed format sense formats.
> As this is of rather limited use in the general case we should
> be stop trying to decode sense extras; the tape driver does
> its own decoding anyway.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
