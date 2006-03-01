From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] SCSI sym53c8xx_2: bigger transfer limits
Date: Wed, 01 Mar 2006 11:00:56 -0500
Message-ID: <4405C538.4050709@torque.net>
References: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local>	 <20060301152929.GZ4816@suse.de> <1141227541.3276.26.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:6584 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S1030218AbWCAQCF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 11:02:05 -0500
In-Reply-To: <1141227541.3276.26.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Kai Makisara <Kai.Makisara@kolumbus.fi>, matthew@wil.cx, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2006-03-01 at 16:29 +0100, Jens Axboe wrote:
> 
>>Strictly speaking, the clustering bit is unrelated. I seem to recall
>>Gerard years ago talking about some sym chips that did not like
>>clustering, hence it was disabled.
> 
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

James,
So the maximum data carrying size of a scatter gather list
is not deterministic? Is the worst case (page_size * SG_ALL)?

Doug Gilbert
