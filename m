From: Christoph Hellwig <hch@lst.de>
Subject: Re: properly communicate queue limits to the DMA layer v2
Date: Mon, 15 Jul 2019 19:46:17 +0200
Message-ID: <20190715174617.GA11094@lst.de>
References: <20190617122000.22181-1-hch@lst.de> <20190715165823.GA10029@lst.de> <yq1tvbn2ofc.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1tvbn2ofc.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 15, 2019 at 01:33:11PM -0400, Martin K. Petersen wrote:
> 
> Christoph,
> 
> > Ping?  What happened to this set of bug fixes?
> 
> I thought they depended on Jens' tree?

I think all the patches on the block side went into 5.2, but it's been
a while, so I might misremember..
