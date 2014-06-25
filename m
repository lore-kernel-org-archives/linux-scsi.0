From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Wed, 25 Jun 2014 07:29:01 -0400
Message-ID: <yq1ha39fcsi.fsf@sermon.lab.mkp.net>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
	<1402477799-24610-2-git-send-email-sagig@mellanox.com>
	<53A920B2.9060503@cs.wisc.edu> <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
	<28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu>
	<53A9A702.8050503@dev.mellanox.co.il>
	<20140624163040.GA11499@infradead.org> <53A9AEB8.4040104@cs.wisc.edu>
	<53A9B0A0.6000103@cs.wisc.edu> <53AA42E6.3090101@cs.wisc.edu>
	<20140625091418.GA5360@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140625091418.GA5360@infradead.org> (Christoph Hellwig's
	message of "Wed, 25 Jun 2014 02:14:18 -0700")
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> So here we use blk_rq_bytes still, which is incorrect for
Christoph> WRITE SAME.

Yeah, scsi_transfer_length() needs to go away completely if we go with
the in and out variants.

Christoph> I think the easiest fix is to just pass a scsi_data_buffer to
Christoph> scsi_transfer_length(), and let the caller use
Christoph> scsi_in/scsi_out to find the right one.

I'm perfectly OK with that approach.

-- 
Martin K. Petersen	Oracle Linux Engineering
