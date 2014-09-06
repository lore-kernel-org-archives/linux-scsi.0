From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/20] aha152x: Debug output update and whitespace cleanup
Date: Fri, 5 Sep 2014 17:02:20 -0700
Message-ID: <20140906000220.GA29588@infradead.org>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
 <1409738775-80876-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56452 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIFAAO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 20:00:14 -0400
Content-Disposition: inline
In-Reply-To: <1409738775-80876-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org

On Wed, Sep 03, 2014 at 12:05:57PM +0200, Hannes Reinecke wrote:
> Remove all uncommented debugging code and move all
> printk() statements over to dev_printk().
> And while we're at it we should be doing a whitespace
> cleanup, too.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
