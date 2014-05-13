From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] scsi: replace numeric messages with string error
 messages when blk_execute_rq fails.  Also add printing of sense info.
Date: Tue, 13 May 2014 15:10:15 +0200
Message-ID: <20140513131015.GB2015@dhcp-27-189.brq.redhat.com>
References: <1398167056-14582-1-git-send-email-mlombard@redhat.com>
 <20140425131219.GA20644@lst.de>
 <20140429093035.GA2219@dhcp-27-189.brq.redhat.com>
 <20140429180041.GB26194@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933371AbaEMNh2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2014 09:37:28 -0400
Content-Disposition: inline
In-Reply-To: <20140429180041.GB26194@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, hare@suse.de

Hi,

On Tue, Apr 29, 2014 at 08:00:41PM +0200, Christoph Hellwig wrote:
> 
> What kind of update do you want?  All the sense buffer updates are done
> in the low-level code, and then you could update anything additional
> you would need in the caller as you get the whole sense buffer when
> using scsi_execute() (for scsi_execute_req_flags it's harder due to the
> normalized sense buffer).

Hannes Reinecke is also working on those functions, I'll have to collaborate
with him to minimize the conflicts with the patchset he is preparing.

In the meantime, do you think it is possible to merge the first version
of the patch (http://www.spinics.net/lists/linux-scsi/msg73984.html)?
We could proceed to rewrite the functions later.

Thanks,
Maurizio Lombardi

