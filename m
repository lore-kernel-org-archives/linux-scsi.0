From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: isci: initialize shost fully before calling
 scsi_add_host()
Date: Wed, 9 Jan 2019 19:41:05 +0100
Message-ID: <20190109184105.GB22070@lst.de>
References: <20190108205043.3122-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190108205043.3122-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

This looks good.  I wonder if there is any good way to prevent other
drivers from picking up this bug byt using a better interface, but
that should not delay your fix.
