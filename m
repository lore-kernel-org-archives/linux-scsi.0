From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 02/25] block: remove the blk_execute_rq return value
Date: Fri, 14 Apr 2017 10:22:31 +0200
Message-ID: <20170414082231.GC24901@lst.de>
References: <20170406153944.10058-1-hch@lst.de> <20170406153944.10058-3-hch@lst.de> <1492113800.24345.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41692 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbdDNIWd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Apr 2017 04:22:33 -0400
Content-Disposition: inline
In-Reply-To: <1492113800.24345.9.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Thu, Apr 13, 2017 at 08:03:22PM +0000, Bart Van Assche wrote:
> That blk_execute_rq() call can only be reached if a few lines above 0 was
> assigned to the "error" variable. Since nfsd4_scsi_identify_device() returns
> the value of the "error" variable I think -EIO should be assigned to that
> variable before the "goto out_put_request" statement is reached.

You're right!  I'll fix it up.
