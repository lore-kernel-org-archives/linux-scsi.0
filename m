From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/9] I/O path micro-optimizations and per-command private
 data support
Date: Wed, 12 Mar 2014 00:27:17 -0700
Message-ID: <20140312072717.GA27496@infradead.org>
References: <20140220222052.717958451@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59039 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570AbaCLH1S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2014 03:27:18 -0400
Content-Disposition: inline
In-Reply-To: <20140220222052.717958451@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

I specificly sent this set of patches because it were those deemed
easily mergeable 4 weeks ago.  Any progress on it?

On Thu, Feb 20, 2014 at 02:20:52PM -0800, Christoph Hellwig wrote:
> This is a resend of the easily acceptable subset of the previously sent
> patches. The first two patches avoid taking the host_lock needlessly for
> fast path operations, patches 3 to 5 avoid useless manipulations of the
> device reference count, and the remaining ones allow a driver specifying
> an extra command size so drivers don't have to allocate memory for driver
> specific data additionally, as well as converting virtio-scsi to use this
> feature.
> 
> Changes from the first version are limited to reordering the patch series,
> fixing patch subjects and attribution and adding some boilerplate commands
> back.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
