From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv3 08/10] scsi: allocate reserved commands
Date: Tue, 21 Feb 2017 15:13:43 +0100
Message-ID: <20170221141343.GA27251@lst.de>
References: <1487680029-3701-1-git-send-email-hare@suse.de> <1487680029-3701-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37627 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752574AbdBUONq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Feb 2017 09:13:46 -0500
Content-Disposition: inline
In-Reply-To: <1487680029-3701-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On Tue, Feb 21, 2017 at 01:27:07PM +0100, Hannes Reinecke wrote:
> The block layer already has the notion of 'reserved' commands, so
> we should be enabling scsi hosts to allocate them.

Only if using blk-mq so far, so this patch is incomplete.  But
fortunately I don't think you actually need this patch, see my reply to
the next one for details.
