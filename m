From: Meelis Roos <mroos@linux.ee>
Subject: Re: blk-mq problem on proliant DL380 G3 (cciss)
Date: Wed, 29 Oct 2014 13:46:04 +0200 (EET)
Message-ID: <alpine.LRH.2.11.1410291344220.12885@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:33243 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390AbaJ2LqH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2014 07:46:07 -0400
In-Reply-To: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>

> I tried 3.18-rc2 with blk-mq default on on HP ProLiant DL380 G3 (with HP 
> CCISS RAID controller). It fails late in the bootup with "task 
> scsi_eh_1:720 blocked for more than 120 seconds." messages.
> 
> Booting with scsi_mod.use_blk_mq=0 fixes the problem.

Another test server with MPT SCSI RAID has similar problem, 
scsi_mode.use_blk_mq=0 cures it but I can not get good trace (no serail 
console). 3.18.0-rc2-00043-gf7e87a4 was tested there.

-- 
Meelis Roos (mroos@linux.ee)
