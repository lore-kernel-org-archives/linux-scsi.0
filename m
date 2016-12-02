From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] hpsa: expose enclosures
Date: Fri, 2 Dec 2016 12:39:58 +0100
Message-ID: <20161202113958.GA26885@lst.de>
References: <1480674993-118324-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:32963 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751608AbcLBLkA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 06:40:00 -0500
Content-Disposition: inline
In-Reply-To: <1480674993-118324-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Dec 02, 2016 at 11:36:33AM +0100, Hannes Reinecke wrote:
> Some servers have a built-in enclosure which will show up on the
> same bus as the internal physical devices. As the driver doesn't
> differentiate here they'll be hidden from the OS.
> This patch add a module parameter 'hpsa_expose_enclosure' which
> will expose these enclosures.

Any reason for not doing this unconditionally?
