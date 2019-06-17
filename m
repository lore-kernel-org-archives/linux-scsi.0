From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 6/8] IB/srp: set virt_boundary_mask in the scsi host
Date: Mon, 17 Jun 2019 14:01:01 -0700
Message-ID: <840d9dbd-918b-d749-186a-3cc26d53fe76@acm.org>
References: <20190617122000.22181-1-hch@lst.de>
 <20190617122000.22181-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617122000.22181-7-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/17/19 5:19 AM, Christoph Hellwig wrote:
> This ensures all proper DMA layer handling is taken care of by the
> SCSI midlayer.

Acked-by: Bart Van Assche <bvanassche@acm.org>
