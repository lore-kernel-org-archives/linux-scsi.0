From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: hpsa: free irq on q indexed by h->intr_mode and
        not i
Date: Mon, 14 Nov 2016 16:42:47 +0100
Message-ID: <20161114154247.GA26092@lst.de>
References: <20161114125935.12158-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161114125935.12158-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Looks fine, I was actually about to send the same fix..

Reviewed-by: Christoph Hellwig <hch@lst.de>
