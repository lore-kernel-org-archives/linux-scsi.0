From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 01/41] hpsa: add masked physical devices into h->dev[]
 array
Date: Sun, 8 Mar 2015 08:37:08 -0700
Message-ID: <20150308153708.GA17534@infradead.org>
References: <20150306233504.29973.41322.stgit@brunhilda>
 <20150306234552.29973.81396.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35011 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbbCHPhU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Mar 2015 11:37:20 -0400
Content-Disposition: inline
In-Reply-To: <20150306234552.29973.81396.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com, linux-scsi@vger.kernel.org

> +	if (!shost_use_blk_mq(sdev->host))
> +		sdev->tagged_supported = 1;

no need to do this conditionally on using blk-mq.  In fact I'm pretty
sure yo udon't need this at all given that hpsa doesn't make use of
the SCMD_TAGGED flag.

