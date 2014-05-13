From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: replace numeric messages with string error
	messages when blk_execute_rq fails.  Also add printing of sense
	info.
Date: Tue, 13 May 2014 16:07:24 +0200
Message-ID: <20140513140724.GA4618@lst.de>
References: <1398167056-14582-1-git-send-email-mlombard@redhat.com> <20140425131219.GA20644@lst.de> <20140429093035.GA2219@dhcp-27-189.brq.redhat.com> <20140429180041.GB26194@lst.de> <20140513131015.GB2015@dhcp-27-189.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54955 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933583AbaEMOH1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2014 10:07:27 -0400
Content-Disposition: inline
In-Reply-To: <20140513131015.GB2015@dhcp-27-189.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com, hare@suse.de

On Tue, May 13, 2014 at 03:10:15PM +0200, Maurizio Lombardi wrote:
> Hannes Reinecke is also working on those functions, I'll have to collaborate
> with him to minimize the conflicts with the patchset he is preparing.
> 
> In the meantime, do you think it is possible to merge the first version
> of the patch (http://www.spinics.net/lists/linux-scsi/msg73984.html)?
> We could proceed to rewrite the functions later.

I'm fine with adding the pints, but what work is Hannes doing with
scsi_execute at the moment?

