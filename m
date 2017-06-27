From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/35] visorhba: sanitze private device data allocation
Date: Wed, 28 Jun 2017 01:56:13 +0200
Message-ID: <20170627235613.GG13988@lst.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de> <1498222975-71858-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46507 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753975AbdF0X4O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Jun 2017 19:56:14 -0400
Content-Disposition: inline
In-Reply-To: <1498222975-71858-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Jun 23, 2017 at 03:02:26PM +0200, Hannes Reinecke wrote:
> There's no need to keep the private data for a device in a separate
> list; better to store it in ->hostdata and do away with the additional
> list.

Nice improvement, although that driver is a complete mess..  And
I guess you need to send this to Greg separately.
