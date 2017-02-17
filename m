From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 10/11] scsi: allocate reserved commands
Date: Fri, 17 Feb 2017 09:55:05 +0100
Message-ID: <20170217085505.GE18443@lst.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de> <1487319790-97340-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41215 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756021AbdBQIzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:55:06 -0500
Content-Disposition: inline
In-Reply-To: <1487319790-97340-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Feb 17, 2017 at 09:23:09AM +0100, Hannes Reinecke wrote:
> The block layer already has the notion of 'reserved' commands, so
> we should be enabling hosts to allocate them.

How does this interact with the non blk-mq path?
