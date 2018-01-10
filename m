From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] libsas: Disable asynchronous aborts for SATA devices
Date: Wed, 10 Jan 2018 09:15:14 +0100
Message-ID: <20180110081514.GA9810@lst.de>
References: <1515512632-115483-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45714 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751228AbeAJIPQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jan 2018 03:15:16 -0500
Content-Disposition: inline
In-Reply-To: <1515512632-115483-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Yves-Alexis Perez <corsac@debian.org>, Hannes Reinecke <hare@suse.com>

Looks fine to me for 4.15 and -stable:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But we really need to fix this properly in the long run.
