From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] sg: disable SET_FORCE_LOW_DMA
Date: Fri, 3 Feb 2017 11:23:10 +0100
Message-ID: <20170203102310.GA29163@lst.de>
References: <1486112091-68470-1-git-send-email-hare@suse.de> <1486112091-68470-2-git-send-email-hare@suse.de> <56d69348-13e0-8daa-9fac-942033ab564a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47190 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753094AbdBCKXM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 05:23:12 -0500
Content-Disposition: inline
In-Reply-To: <56d69348-13e0-8daa-9fac-942033ab564a@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Feb 03, 2017 at 10:32:28AM +0100, Johannes Thumshirn wrote:
> I'm not sure if returning a bogus '0' is better here to not break any 
> existing application, which assumed it always worked.

Agreed, this should return 0, and maybe also print a (ratelimited)
warning.
