From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] introduce scsi_host_alloc
Date: Thu, 5 Jun 2003 23:24:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030605212403.GB12812@lst.de>
References: <20030603203243.GA9018@lst.de> <20030605205010.GD2154@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:57035 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265157AbTFEVKj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2003 17:10:39 -0400
Content-Disposition: inline
In-Reply-To: <20030605205010.GD2154@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Thu, Jun 05, 2003 at 01:50:10PM -0700, Mike Anderson wrote:
> We could move the host_no to scsi_sysfs_init_host and use the
> class->subsys.rwsem to protect this.

I think the best idea would be to just use a separate sinlock for this.

