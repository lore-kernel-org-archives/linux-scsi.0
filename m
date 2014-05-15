From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: replace numeric messages with string error
	messages when blk_execute_rq fails.  Also add printing of sense
	info.
Date: Thu, 15 May 2014 08:41:10 +0200
Message-ID: <20140515064110.GA7410@lst.de>
References: <1398167056-14582-1-git-send-email-mlombard@redhat.com> <20140425131219.GA20644@lst.de> <20140429093035.GA2219@dhcp-27-189.brq.redhat.com> <20140429180041.GB26194@lst.de> <20140513131015.GB2015@dhcp-27-189.brq.redhat.com> <20140513140724.GA4618@lst.de> <537228D7.3080306@suse.de> <20140513142401.GC2015@dhcp-27-189.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59555 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbaEOGlO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2014 02:41:14 -0400
Content-Disposition: inline
In-Reply-To: <20140513142401.GC2015@dhcp-27-189.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Christoph Hellwig <hch@lst.de>

On Tue, May 13, 2014 at 04:24:02PM +0200, Maurizio Lombardi wrote:
> On Tue, May 13, 2014 at 04:14:47PM +0200, Hannes Reinecke wrote:
> > If you were to go ahead with the patch please strip the first
> > scsi_execute() altogether and use the VPD information already
> > provided by the scsi device.
> 
> The patch I'm asking to merge just adds some printks, nothing else,
> it does not make use of scsi_execute():
> 
> http://www.spinics.net/lists/linux-scsi/msg73984.html

We now have a readily available copy of EVPD page 0x83 hanging off
the scsi device, so the alua device handler should use it.

Hannes, how about you handle that if you're doing major surgery in that
area anwyay?

