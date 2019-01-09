From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: isci: initialize shost fully before calling scsi_add_host()
Date: Tue, 08 Jan 2019 22:29:09 -0500
Message-ID: <yq1d0p64igq.fsf@oracle.com>
References: <20190108205043.3122-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190108205043.3122-1-logang@deltatee.com> (Logan Gunthorpe's
        message of "Tue, 8 Jan 2019 13:50:43 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>
List-Id: linux-scsi@vger.kernel.org


Logan,

> To prevent this, the calls to scsi_host_set_prot() are moved into
> isci_host_alloc() before the call to scsi_add_host(). Out of caution,
> also move the similar call to scsi_host_set_guard().

Applied to 5.0/scsi-fixes. Thanks much!

-- 
Martin K. Petersen	Oracle Linux Engineering
