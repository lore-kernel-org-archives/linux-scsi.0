From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/6] mpt2sas: get rid of MPI2_FUNCTION_SCSI_TASK_MGMT
Date: Mon, 13 Apr 2015 11:49:15 +0200
Message-ID: <20150413094915.GD5259@lst.de>
References: <1428427120-20971-1-git-send-email-axboe@fb.com> <1428427120-20971-4-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60222 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbbDMJtR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Apr 2015 05:49:17 -0400
Content-Disposition: inline
In-Reply-To: <1428427120-20971-4-git-send-email-axboe@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de

This should also mention that you now allocate the hdr for the normal
pass through from a different pool.  Actually that change probably should
really be a separate patch..
