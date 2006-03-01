From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] SCSI sym53c8xx_2: bigger transfer limits
Date: Wed, 1 Mar 2006 16:54:02 +0100
Message-ID: <20060301155401.GA4816@suse.de>
References: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local> <20060301152929.GZ4816@suse.de> <1141227541.3276.26.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:2881 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S932414AbWCAPy1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 10:54:27 -0500
Content-Disposition: inline
In-Reply-To: <1141227541.3276.26.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, matthew@wil.cx, linux-scsi@vger.kernel.org

On Wed, Mar 01 2006, James Bottomley wrote:
> On Wed, 2006-03-01 at 16:29 +0100, Jens Axboe wrote:
> > Strictly speaking, the clustering bit is unrelated. I seem to recall
> > Gerard years ago talking about some sym chips that did not like
> > clustering, hence it was disabled.
> 
> Yes, I remember that too ... I've never been able to find out which
> chip, though ... the scripts all seem happily coded for variable size sg
> segments.
> 
> However, given the new way 2.6 does memory allocations,
> ENABLE_CLUSTERING will probably make quite a difference to the size of
> the sg list ... since we try to allocate contiguous pages, physical
> merging becomes much more of a possibility (I think I last measured it
> at around 30% of all SG tables, as opposed to <1% with the old
> allocation method).

So if we want to enable clustering, it should be done as a separate
patch just in case...

-- 
Jens Axboe

