From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] SCSI: remove one useless stack variable
Date: Mon, 10 Oct 2016 18:51:53 +0200
Message-ID: <20161010165153.GA8398@lst.de>
References: <1476113133-24092-1-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476113133-24092-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 10, 2016 at 11:25:33PM +0800, Ming Lei wrote:
> The local variable of 'devname' in scsi_report_lun_scan()
> isn't used any more, so remove it.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
