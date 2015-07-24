From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] scsi: rescan VPD attributes
Date: Fri, 24 Jul 2015 16:43:48 +0200
Message-ID: <20150724144348.GA29080@lst.de>
References: <1436353788-104911-1-git-send-email-hare@suse.de> <1436353788-104911-2-git-send-email-hare@suse.de> <20150724143834.GA28970@lst.de> <55B24E6A.6030904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55815 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbbGXOnt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2015 10:43:49 -0400
Content-Disposition: inline
In-Reply-To: <55B24E6A.6030904@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Fri, Jul 24, 2015 at 04:40:42PM +0200, Hannes Reinecke wrote:
> Yeah, possibly. After all, the variable isn't expected to change
> under rcu_read_lock().

Actually it can and will change, that's the point.  But if you use
a local variable you keep a single version of it, which won't be
freed until after rcu_read_unlock.

