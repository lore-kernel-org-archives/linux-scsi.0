From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/9] blk: In elv_abort_queue skip requests with
	REQ_DONTPREP set
Date: Tue, 4 May 2010 12:47:10 +0200
Message-ID: <20100504104709.GO27497@kernel.dk>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com> <1272944228-30511-3-git-send-email-andmike@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57863 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab0EDKrK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 06:47:10 -0400
Content-Disposition: inline
In-Reply-To: <1272944228-30511-3-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

On Mon, May 03 2010, Mike Anderson wrote:
> Having REQ_DONTPREP set on a request can indicated that resources have been
> allocated for this request. In elv_abort_queue skip requests with
> REQ_DONTPREP set to avoid leaking resources.

This also seems weird, are you coding the API backwards from what SCSI
currently has implemented?

Would seem a lot cleaner to separate dont-prep from already-prepped.

-- 
Jens Axboe

