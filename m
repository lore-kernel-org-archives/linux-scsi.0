From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Sun, 13 Jul 2014 07:40:41 -0400
Message-ID: <yq1egxp32rq.fsf@sermon.lab.mkp.net>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
	<1402477799-24610-2-git-send-email-sagig@mellanox.com>
	<20140713113715.GA26031@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140713113715.GA26031@infradead.org> (Christoph Hellwig's
	message of "Sun, 13 Jul 2014 04:37:15 -0700")
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@mellanox.com>, michaelc@cs.wisc.edu, martin.petersen@oracle.com, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> Sagi, can you send an update for the core-for-3.17 tree to
Christoph> pass a dma_direction or the scsi data buffer to
Christoph> scsi_transfer_length so we can make safe for bidi usage in
Christoph> the future?

I have cleaned this up in my integrity patch set since we already have
the flag to determine whether to transfer PI or not.

I'll get those patches out today.

-- 
Martin K. Petersen	Oracle Linux Engineering
