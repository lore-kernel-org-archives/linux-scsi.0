From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: patch so cciss stats are collected in /proc/stat
Date: Wed, 29 Sep 2004 17:35:48 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929203548.GA19037@logos.cnet>
References: <D4CFB69C345C394284E4B78B876C1CF107DBFE0B@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:20924 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269162AbUI2Wgt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 18:36:49 -0400
Content-Disposition: inline
In-Reply-To: <D4CFB69C345C394284E4B78B876C1CF107DBFE0B@cceexc23.americas.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <mike.miller@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, mikem@beardog.cca.cpqcorp.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Baker, Brian (ISS - Houston)" <brian.b@hp.com>

On Wed, Sep 29, 2004 at 11:29:59AM -0500, Miller, Mike (OS Dev) wrote:
> 
> > On Wed, Sep 29, 2004 at 11:13:45AM -0500, mike.miller@hp.com wrote:
> > > Currently cciss statistics are not collected in /proc/stat. 
> > This patch
> > > bumps DK_MAX_MAJOR to 111 to fix that. This has been a 
> > common complaint
> > > by customers wishing to gather info about cciss devices.
> > > Please consider this for inclusion. Applies to 2.4.28-pre3.
> > 
> > This patch has been reject about half a million times, why are people
> > submitting it again and again?
> 
> As I said in my mail, it's a customer driven issue. As long as customers rely on /proc/stat we'll keep trying. You can't tell a customer how he/she should be doing things on their systems.

Mike, 

I dont like the patch either.

If you can have the same statistics through /proc/partitions 
(do I get this right?) just tell that to users.

