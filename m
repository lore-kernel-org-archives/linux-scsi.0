From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] scsi: replace numeric messages with string error
 messages when blk_execute_rq fails.  Also add printing of sense info.
Date: Wed, 4 Jun 2014 09:51:22 +0200
Message-ID: <20140604075122.GA5700@dhcp-27-189.brq.redhat.com>
References: <1398167056-14582-1-git-send-email-mlombard@redhat.com>
 <20140425131219.GA20644@lst.de>
 <20140429093035.GA2219@dhcp-27-189.brq.redhat.com>
 <20140429180041.GB26194@lst.de>
 <20140513131015.GB2015@dhcp-27-189.brq.redhat.com>
 <20140513140724.GA4618@lst.de>
 <537228D7.3080306@suse.de>
 <20140513142401.GC2015@dhcp-27-189.brq.redhat.com>
 <20140515064110.GA7410@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbaFDHvd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jun 2014 03:51:33 -0400
Content-Disposition: inline
In-Reply-To: <20140515064110.GA7410@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, hare@suse.de
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com

On Thu, May 15, 2014 at 08:41:10AM +0200, Christoph Hellwig wrote:
> 
> We now have a readily available copy of EVPD page 0x83 hanging off
> the scsi device, so the alua device handler should use it.
> 
> Hannes, how about you handle that if you're doing major surgery in that
> area anwyay?

Hannes?

Did you notice this email?

Thanks,
Maurizio Lombardi

