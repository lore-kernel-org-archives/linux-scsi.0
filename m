From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s!
 [kworker/1:1:29]
Date: Sun, 3 Jan 2016 19:03:41 +0100
Message-ID: <20160103190341.0000387b@localhost>
References: <20151217222737.00000ab6@localhost>
	<20151231180415.00000bfc@localhost>
	<20160103114628.GA10582@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:63994 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbcACSDt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Jan 2016 13:03:49 -0500
In-Reply-To: <20160103114628.GA10582@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Sebastian Herbszt <herbszt@gmx.de>

Christoph Hellwig wrote:
> On Thu, Dec 31, 2015 at 06:04:15PM +0100, Sebastian Herbszt wrote:
> > I still get this on 4.4.0-rc7-1.g276c9f4-default. Since this did not
> > happen on 4.3 I checked the scsi changes and found the following commit:
> > 
> > scsi: restart list search after unlock in scsi_remove_target
> > 
> > Christoph, can it cause this issue?
> 
> Apparently yes.  Bad hard a patch to avoid this when he resubmitted
> my patch, which for some reason didn't get apply.  Can you grab it
> from the list archives and give it a try?

Do you mean the following patch?

"[PATCH v2] Separate target visibility from reaped state information" [1]

I can give it a try but it will likely take a few days.

[1] http://marc.info/?l=linux-scsi&m=144771953020415&w=2

Sebastian
