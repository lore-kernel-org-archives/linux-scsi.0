From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/43] hpsa: clean up host, channel, target, lun prints
Date: Mon, 23 Feb 2015 12:16:08 -0800
Message-ID: <20150223201608.GB11037@infradead.org>
References: <20150221221553.21954.32599.stgit@brunhilda>
 <20150221221741.21954.90751.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbBWUQJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Feb 2015 15:16:09 -0500
Content-Disposition: inline
In-Reply-To: <20150221221741.21954.90751.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com, linux-scsi@vger.kernel.org

> +	dev_info(&h->pdev->dev,
> +		"%6s scsi %d:%d:%d:%d: %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",

So you still have an action before the identifier.  Can't you just add
a hpsa_dev_printk macro similar to sdev_printk that encapsulates the
format, and also makes sure it's always the prefix for the log message?
