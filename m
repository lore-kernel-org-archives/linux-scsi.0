From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/4] sg: protect access to to 'reserved' page array
Date: Fri, 3 Feb 2017 11:24:32 +0100
Message-ID: <20170203102432.GB29163@lst.de>
References: <1486112091-68470-1-git-send-email-hare@suse.de> <1486112091-68470-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486112091-68470-3-git-send-email-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 03, 2017 at 09:54:49AM +0100, Hannes Reinecke wrote:
> The 'reserved' page array is used as a short-cut for mapping
> data, saving us to allocate pages per request.
> However, the 'reserved' array is only capable of holding one
> request, so we need to protect it against concurrent accesses.

Can you please explain how you protect the access here a bit more,
as mentioned before the set_bit for exclusion trick is always
suspicious, so the changelog needs to have a justification for it.
