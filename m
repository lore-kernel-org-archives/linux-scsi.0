From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Concurrent SG_SCSI_RESET ioctls
Date: Wed, 15 Oct 2014 06:25:37 -0700
Message-ID: <20141015132537.GA10652@infradead.org>
References: <94D0CD8314A33A4D9D801C0FE68B402958CE9B54@G4W3202.americas.hpqcorp.net>
 <20141011161110.GA16812@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958CEB20A@G4W3202.americas.hpqcorp.net>
 <20141014111354.GA3022@infradead.org>
 <543D5272.5080102@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaJONZm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Oct 2014 09:25:42 -0400
Content-Disposition: inline
In-Reply-To: <543D5272.5080102@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Don Brace (PMC)" <Don.Brace@pmcs.com>, "Scales, Webb" <webb.scales@hp.com>

On Tue, Oct 14, 2014 at 12:42:26PM -0400, Douglas Gilbert wrote:
> I don't mind if you change it. However I plan to release
> sg3_utils-1.40 in the next 2 or 3 weeks, so that would
> be the earliest a revised sg_reset would be available for
> distros. Improving error reports is something I always
> like to do (so ENODEV for the "in progress" case seems a
> bit strident).

If sg_utils needs any changes for a different ENODEV we shouldn't
bother - breaking backwards compatibility is a bad idea.

