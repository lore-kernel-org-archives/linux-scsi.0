From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH 5/8] IB/iser: set virt_boundary_mask in the scsi host
Date: Tue, 25 Jun 2019 01:32:06 +0300
Message-ID: <bbea1029-e434-a633-5516-fe6a92e60beb@mellanox.com>
References: <20190617122000.22181-1-hch@lst.de>
 <20190617122000.22181-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617122000.22181-6-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/17/2019 3:19 PM, Christoph Hellwig wrote:
> This ensures all proper DMA layer handling is taken care of by the
> SCSI midlayer.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>


Looks good,

Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
