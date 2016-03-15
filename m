From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: vpd pages are mandatory for SPC-2
Date: Tue, 15 Mar 2016 08:42:32 +0100
Message-ID: <20160315074232.GA10944@lst.de>
References: <1457703965-71028-1-git-send-email-hare@suse.de> <yq137rshbrr.fsf@sermon.lab.mkp.net> <56E7B9AA.3020302@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44896 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934114AbcCOHmf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 03:42:35 -0400
Content-Disposition: inline
In-Reply-To: <56E7B9AA.3020302@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.com>

On Tue, Mar 15, 2016 at 08:28:42AM +0100, Hannes Reinecke wrote:
> But it feels even sillier having to whitelist every
> standards-conformant device here; I certainly was when I figured
> that EMC Clariion won't work properly without this patch.
> 
> And the idea was to mark off _misbehaving_ drives, not the other way
> round.

It's the idea, but it has to prove workable as well in the end.

That being said I'd prefer to allow Hannes patch in and see what
the fallout is. 
