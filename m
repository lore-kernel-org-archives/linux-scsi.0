From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 13:04:59 -0400
Message-ID: <yq1bntigrwk.fsf@sermon.lab.mkp.net>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
	<1402477799-24610-2-git-send-email-sagig@mellanox.com>
	<53A920B2.9060503@cs.wisc.edu> <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
	<28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu>
	<53A9A702.8050503@dev.mellanox.co.il>
	<20140624163040.GA11499@infradead.org> <53A9AEB8.4040104@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53A9AEB8.4040104@cs.wisc.edu> (Mike Christie's message of "Tue,
	24 Jun 2014 12:00:40 -0500")
Sender: target-devel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Mike" == Mike Christie <michaelc@cs.wisc.edu> writes:

Mike> It would be nice to just have one function to call and it just do
Mike> the right thing for the drivers.

But what is the right thing when there are buffers for both directions?

-- 
Martin K. Petersen	Oracle Linux Engineering
