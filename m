From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] scsi: replace numeric messages with string error
 messages when blk_execute_rq fails.  Also add printing of sense info.
Date: Fri, 25 Apr 2014 17:40:29 +0200
Message-ID: <20140425154028.GA2351@dhcp-27-189.brq.redhat.com>
References: <1398167056-14582-1-git-send-email-mlombard@redhat.com>
 <20140425131219.GA20644@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbaDYPkl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2014 11:40:41 -0400
Content-Disposition: inline
In-Reply-To: <20140425131219.GA20644@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com

Hi,

On Fri, Apr 25, 2014 at 03:12:19PM +0200, Christoph Hellwig wrote:
> 
> Looks useful, but why do we have basically two copies of the same
> code for different commands? Looking at them in detail they mostly look
> like copies of scsi_execute/scsi_execute_req_flags and should be switched
> to that.

Yes I think you are right, I'm trying to write a patch to get rid of all
this duplicated code.
I'll publish a patchset next week.

Thanks,
Maurizio Lombardi

