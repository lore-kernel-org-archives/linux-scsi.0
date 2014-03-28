From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] scsi_scan: Restrict sequential scan to 256 LUNs
Date: Fri, 28 Mar 2014 05:47:47 -0700
Message-ID: <20140328124747.GA18866@infradead.org>
References: <1386673515-87133-1-git-send-email-hare@suse.de>
 <1386673515-87133-3-git-send-email-hare@suse.de>
 <20140327144926.GB16958@infradead.org>
 <53353137.2050603@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40107 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaC1Mrw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Mar 2014 08:47:52 -0400
Content-Disposition: inline
In-Reply-To: <53353137.2050603@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Fri, Mar 28, 2014 at 01:22:15AM -0700, Hannes Reinecke wrote:
> Because there is no guarantee that pre-SCSI-3 devices (or devices
> announcing to be pre-SCSI-3) will not allow to scan more than 256
> devices.
> Thinking of older Symmetrix here with their weird 'SPC-3 masking as
> SCSI-2' habit.

Don't we have a blist entry for those to use REPORT LUNS anyway?
> 
> Also currently we're allowing to scan beyond 256 without any
> restrictions there might be installations out there which rely on
> this behaviour.
> 
> Hence this flag.

Which doesn't really have an effect as-is as it's never set.

