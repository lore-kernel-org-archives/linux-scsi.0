From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 20/20] scsi_error: format abort error message
Date: Fri, 5 Sep 2014 17:33:05 -0700
Message-ID: <20140906003305.GA18426@infradead.org>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
 <1409738775-80876-21-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:32953 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaIFAdI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 20:33:08 -0400
Content-Disposition: inline
In-Reply-To: <1409738775-80876-21-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org

On Wed, Sep 03, 2014 at 12:06:15PM +0200, Hannes Reinecke wrote:
> Decode the return value if the command abort failed.

I've not seen an answer to my question in reply to the previous version
of this.  Why would you do pretty printing of a variable that can just
return SUCCESS or FAILURE?

