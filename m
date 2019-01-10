From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: isci: initialize shost fully before calling
 scsi_add_host()
Date: Thu, 10 Jan 2019 09:11:44 +0000
Message-ID: <8d96b40d-fc83-9218-9479-3de423594ddb@huawei.com>
References: <20190108205043.3122-1-logang@deltatee.com>
 <20190109184105.GB22070@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190109184105.GB22070@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Logan Gunthorpe <logang@deltatee.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, chenxiang <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 09/01/2019 18:41, Christoph Hellwig wrote:
> This looks good.  I wonder if there is any good way to prevent other
> drivers from picking up this bug byt using a better interface, but
> that should not delay your fix.
>
> .
>

I noticed that hisi_sas has this same problem but I forgot to fix it.

So how about just drop these APIs and let the user set the shost 
protection parameters directly, like other shost parameters, which 
should make it a bit clearer when these should be set, i.e. before 
scsi_add_host()?

John
