From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] block: Expose discard granularity
Date: Mon, 02 Nov 2009 08:31:08 -0500
Message-ID: <yq1aaz59hpf.fsf@sermon.lab.mkp.net>
References: <1256873409-12668-1-git-send-email-martin.petersen@oracle.com>
	<1256873409-12668-2-git-send-email-martin.petersen@oracle.com>
	<20091030050719.GD17714@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:30376 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbZKBNbg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2009 08:31:36 -0500
In-Reply-To: <20091030050719.GD17714@infradead.org> (Christoph Hellwig's
	message of "Fri, 30 Oct 2009 01:07:19 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

>> +static inline unsigned int queue_discard_granularity(struct

Christoph> Btw, I really hate these wrapper, they make followign the
Christoph> code much harder.  Already annoyed me for the I/O topology
Christoph> bits.

They all follow the block layer calling conventions.  They are also
there to prevent the disaster that was the topology merge which exposed
code all over the kernel that was poking directly at fields in struct
request.

-- 
Martin K. Petersen	Oracle Linux Engineering
