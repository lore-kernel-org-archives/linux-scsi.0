From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PREEMPT-RT] bnx2i + bnx2fc: convert to generic workqueue (#2)
Date: Fri, 9 Dec 2016 13:48:54 +0100
Message-ID: <20161209124854.GC8391@linux-x5ow.site>
References: <20161122174813.16184-1-bigeasy@linutronix.de>
 <yq160n6ns12.fsf@sermon.lab.mkp.net>
 <alpine.DEB.2.20.1612091232230.3794@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48031 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932802AbcLIMs5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Dec 2016 07:48:57 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1612091232230.3794@nanos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>

[ +Lee and Chris ]
On Fri, Dec 09, 2016 at 12:33:11PM +0100, Thomas Gleixner wrote:
> On Tue, 29 Nov 2016, Martin K. Petersen wrote:
> 
> > >>>>> "Sebastian" == Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:
> > 
> > Sebastian> This is the a repost + fixups to get the patches applied
> > Sebastian> against v4.9-rc4.  mkp's scsi for-next tree can be merged
> > Sebastian> with no conflicts.
> > 
> > Chad?
> 
> Polite ping on this. We really want to get rid of the hotplug notifier crap
> in 4.10. This one of the last holdouts.

As I already said, the FCoE part looks OK and is tested.

Lee, Chris can you do some testing with the iSCSI part as well, seems like
Chad isn't reachable.

Thanks,	
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
