From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] scsi: replace numeric messages with string error
 messages when blk_execute_rq fails.  Also add printing of sense info.
Date: Tue, 13 May 2014 16:24:02 +0200
Message-ID: <20140513142401.GC2015@dhcp-27-189.brq.redhat.com>
References: <1398167056-14582-1-git-send-email-mlombard@redhat.com>
 <20140425131219.GA20644@lst.de>
 <20140429093035.GA2219@dhcp-27-189.brq.redhat.com>
 <20140429180041.GB26194@lst.de>
 <20140513131015.GB2015@dhcp-27-189.brq.redhat.com>
 <20140513140724.GA4618@lst.de>
 <537228D7.3080306@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbaEMOYP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2014 10:24:15 -0400
Content-Disposition: inline
In-Reply-To: <537228D7.3080306@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Christoph Hellwig <hch@lst.de>

On Tue, May 13, 2014 at 04:14:47PM +0200, Hannes Reinecke wrote:
> If you were to go ahead with the patch please strip the first
> scsi_execute() altogether and use the VPD information already
> provided by the scsi device.

The patch I'm asking to merge just adds some printks, nothing else,
it does not make use of scsi_execute():

http://www.spinics.net/lists/linux-scsi/msg73984.html

Maurizio Lombardi

