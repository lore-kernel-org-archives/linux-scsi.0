From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/20] scsi: merge print_opcode_name()
Date: Fri, 5 Sep 2014 17:12:07 -0700
Message-ID: <20140906001207.GH29588@infradead.org>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
 <1409738775-80876-13-git-send-email-hare@suse.de>
 <540910D8.1080703@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56539 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbaIFAJu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 20:09:50 -0400
Content-Disposition: inline
In-Reply-To: <540910D8.1080703@hitachi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On Fri, Sep 05, 2014 at 10:24:40AM +0900, Yoshihiro YUNOMAE wrote:
> >   #define SA_NAME_LIST_SZ ARRAY_SIZE(sa_names_arr)
> 
> We can delete SA_NAME_LIST_SZ because we define it out of
> CONFIG_SCSI_CONSTANTS.

I'd generally prefer to just use ARRAY_SIZE() directly instead of adding
another layer of indirection.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
