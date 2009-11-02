From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] sd: WRITE SAME(16) / UNMAP support
Date: Mon, 02 Nov 2009 08:32:08 -0500
Message-ID: <yq1639t9hnr.fsf@sermon.lab.mkp.net>
References: <1256873409-12668-1-git-send-email-martin.petersen@oracle.com>
	<1256873409-12668-3-git-send-email-martin.petersen@oracle.com>
	<20091030051120.GE17714@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:31285 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbZKBNcU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2009 08:32:20 -0500
In-Reply-To: <20091030051120.GE17714@infradead.org> (Christoph Hellwig's
	message of "Fri, 30 Oct 2009 01:11:20 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> If we want to expose this we'd better do it at the block
Christoph> layer

I agree.  I've already had several requests for "is this blkdev thinly
provisioned?"...

-- 
Martin K. Petersen	Oracle Linux Engineering
