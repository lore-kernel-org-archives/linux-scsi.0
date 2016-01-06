From: Christoph Hellwig <hch@lst.de>
Subject: Re: NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s!
	[kworker/1:1:29]
Date: Wed, 6 Jan 2016 07:10:45 +0100
Message-ID: <20160106061045.GB16509@lst.de>
References: <20151217222737.00000ab6@localhost> <20151231180415.00000bfc@localhost> <20160103114628.GA10582@lst.de> <20160103190341.0000387b@localhost> <20160105210600.000017c5@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42164 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbcAFGKr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jan 2016 01:10:47 -0500
Content-Disposition: inline
In-Reply-To: <20160105210600.000017c5@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>

On Tue, Jan 05, 2016 at 09:06:00PM +0100, Sebastian Herbszt wrote:
> > I can give it a try but it will likely take a few days.
> > 
> > [1] http://marc.info/?l=linux-scsi&m=144771953020415&w=2
> 
> Bart's patch mentioned above seems to fix my issue.

Bart, can you resend that patch with a a Reported-by and Tested-by for
Sebastian?

> The soft lockup is gone and now I am getting the following but that
> already happened on 4.3 too:

This looks power management related.  Might be worth to send a separate
bug report to both linux-scsi and the people responsible for
drivers/base/power/sysfs.c
