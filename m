From: Jens Axboe <axboe@suse.de>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Sat, 31 Jul 2004 16:12:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040731141240.GE23697@suse.de>
References: <1091228652.6845.1.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:21696 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S267956AbUGaOND (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Jul 2004 10:13:03 -0400
Content-Disposition: inline
In-Reply-To: <1091228652.6845.1.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 30 2004, Pat LaVarre wrote:
> Offline a friend reports seeing bytes/CDB of Linux ioctl SG_IO grossly
> limited - like down below 0.000000128 GB/CDB for op x3B "WRITE BUFFER".

Could you have chosen a more awkward way to express that number? I can't
even make sense of it if I try, 0.128 bytes/cdb?! And are you talking
about the length of the cdb, or do you mean the data that it can
send/receive? I'd guess the latter, but then cdb isn't the correct term.

So in short, please try again :-)

-- 
Jens Axboe

