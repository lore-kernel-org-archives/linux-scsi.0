From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] rationalize allocation and freeing of struct scsi_device
Date: Mon, 18 Nov 2002 10:24:10 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021118102410.A19492@eng2.beaverton.ibm.com>
References: <20021117234901.A9784@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021117234901.A9784@lst.de>; from hch@lst.de on Sun, Nov 17, 2002 at 11:49:01PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sun, Nov 17, 2002 at 11:49:01PM +0100, Christoph Hellwig wrote:
> Currently allocation and freeing of struct scsi_device is a mess.
> We have two nice functions in scsi_scan.c (scsi_allocate_sdev/
> scsi_free_sdev) that are the right interfaces to deal with it, so I moved
> them to scsi and made them non-static.  I've changed all functions
> allocation freeing them to use it.

What happened to the scsi_release_sdev that was in your previous version
of the patch?

That was a nice place to call device_unregister(), and would be the right
place to remove sysfs scsi_device files.

-- Patrick Mansfield
