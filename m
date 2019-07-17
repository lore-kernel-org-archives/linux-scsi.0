From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: properly communicate queue limits to the DMA layer v2
Date: Tue, 16 Jul 2019 23:07:55 -0400
Message-ID: <yq1y30xxss4.fsf@oracle.com>
References: <20190617122000.22181-1-hch@lst.de>
        <20190715165823.GA10029@lst.de> <yq1tvbn2ofc.fsf@oracle.com>
        <20190715174617.GA11094@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190715174617.GA11094@lst.de> (Christoph Hellwig's message of
        "Mon, 15 Jul 2019 19:46:17 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christoph,

> I think all the patches on the block side went into 5.2, but it's been
> a while, so I might misremember..

I checked my notes and the reason I held them back was that I was
waiting for a response from Broadcom wrt. the megaraid segment size
limitation.  However, given that mpt3sas was acked, I assume it's the
same thing.

I'm not so keen on how big the last batch of patches for the merge
window is getting. But I queued your fixes up for 5.3.

-- 
Martin K. Petersen	Oracle Linux Engineering
