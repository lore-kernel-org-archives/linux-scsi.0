From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 10/11] scsi: allocate reserved commands
Date: Fri, 17 Feb 2017 13:37:48 +0100
Message-ID: <20170217123748.GA23739@lst.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de> <1487319790-97340-11-git-send-email-hare@suse.de> <20170217085505.GE18443@lst.de> <54057180-fcdf-848e-80ca-50519456f18c@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42423 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755550AbdBQMhv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 07:37:51 -0500
Content-Disposition: inline
In-Reply-To: <54057180-fcdf-848e-80ca-50519456f18c@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Feb 17, 2017 at 10:00:28AM +0100, Hannes Reinecke wrote:
> So here's my question: how are 'reserved' commands are imagined to be used?
> ATM they exist for blk-mq solely, and are not even implemented for
> legacy sq.

Yes.

> At the same time quite some drivers (like mpt3sas) really could make use
> of the notion of 'reserved' commands.
> Does it make sense to implement 'reserved' commands for the legacy sq
> code path, too?

Yes.
