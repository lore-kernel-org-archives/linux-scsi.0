From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/4] libata: consolidate ata_dev_classify()
Date: Sat, 6 Sep 2014 21:52:27 +0900
Message-ID: <20140906125227.GA29401@mtj.dyndns.org>
References: <1406706911-79510-1-git-send-email-hare@suse.de>
 <1406706911-79510-2-git-send-email-hare@suse.de>
 <20140905234241.GH15723@mtj.dyndns.org>
 <540AC41F.8020506@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:50751 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaIFMwd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Sep 2014 08:52:33 -0400
Content-Disposition: inline
In-Reply-To: <540AC41F.8020506@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

Hello,

On Sat, Sep 06, 2014 at 10:21:51AM +0200, Hannes Reinecke wrote:
> Well, yes, in principle. I was looking into that, too.
> But then I figured that moving to ata_taskfile would be a major overhaul for
> libsas, which would be quite beyond scope here.
> And all for a puny little patch.

Hmm?  Just allocate a ata_taskfile stuct on stack when invoking the
function.  The change would be a lot smaller actually.

Thanks.

-- 
tejun
