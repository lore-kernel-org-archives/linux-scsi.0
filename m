From: Jens Axboe <axboe@suse.de>
Subject: Re: [ANNOUNCE] megaraid 2.00.6 patch for kernels without hostlock
Date: Fri, 1 Aug 2003 07:49:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030801054923.GM22104@suse.de>
References: <0E3FA95632D6D047BA649F95DAB60E570185F3CF@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:52707 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S270671AbTHAFtZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2003 01:49:25 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570185F3CF@EXA-ATLANTA.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <atulm@lsil.com>
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-megaraid-devel@dell.com'" <linux-megaraid-devel@dell.com>

On Thu, Jul 31 2003, Mukker, Atul wrote:
> 
> Well, that's definitely a good idea. Expect a new driver with this change.
> BTW, is there a kernel version beyond which all versions would support per
> host lock, and I mean a 2.4.x kernel :-)

Unfortunately no, however it is trivial to just add host->lock pointer
and make it point to io_request_lock. Ditto for q->queue_lock. That wont
change how the code operates at all. I will probably do that once 2.4.23
opens, it would make maintaining 2.6/2.4 drivers much easier (and ditto
for vendor kernels).

-- 
Jens Axboe

