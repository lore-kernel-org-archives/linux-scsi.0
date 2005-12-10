From: Christoph Hellwig <hch@infradead.org>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Sat, 10 Dec 2005 18:20:01 +0000
Message-ID: <20051210182001.GA19765@infradead.org>
References: <200512091938.jB9JbnnQ025362@einhorn.in-berlin.de> <1134168322.3491.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49573 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1161019AbVLJSUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Dec 2005 13:20:04 -0500
Content-Disposition: inline
In-Reply-To: <1134168322.3491.5.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, patmans@us.ibm.com, adq_dvb@lidskialf.net, linux1394-devel@lists.sourceforge.net, axboe@suse.de

On Fri, Dec 09, 2005 at 05:45:22PM -0500, James Bottomley wrote:
> On Fri, 2005-12-09 at 20:35 +0100, Stefan Richter wrote:
> > When preparing a request in scsi_lib or in a SCSI high-level driver,
> > always set a transfer direction of DMA_NONE if data length is zero,
> > even for alleged write requests. (Extended patch derived from Jens
> > Axboe's version.)
> > 
> > Write requests with request buffer length == 0 lead to kernel panic
> > or oops if channeled through sbp2:
> > http://marc.theaimsgroup.com/?l=linux1394-devel&m=113399994920181
> > http://marc.theaimsgroup.com/?l=linux1394-user&m=112152701817435
> > 
> > Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> The problem is that I already picked up Jens' patch in rc fixes, so this
> no-longer applies.  However, given that the fix needed to be in four
> separate places, which looks rather bad, I propose the following
> consolidation instead.

Please make the export _GPL so people see it's internal and can go away
real soon.  Hopefull for 2.6.16 already when Mike's patch series is merged.

