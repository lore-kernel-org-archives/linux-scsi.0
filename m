From: Jens Axboe <axboe@suse.de>
Subject: Re: CDC_RAM for lk 2.4, PATCH proposed
Date: Fri, 16 Apr 2004 14:09:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040416120902.GE1966@suse.de>
References: <1082047960.15520.82.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:13547 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262996AbUDPMJQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 08:09:16 -0400
Content-Disposition: inline
In-Reply-To: <1082047960.15520.82.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: mckellj@iomega.com, linux-scsi@vger.kernel.org

On Thu, Apr 15 2004, Pat LaVarre wrote:
> Jens A:
> 
> Would you consider for 2.4.27, a patch written to give us CDC_RAM alone?
> 
> I ask because I notice, we don't need the problematic op x46
> GPCMD_GET_CONFIGURATION feature x0028 MRW for 2.4.27 to support
> CDC_RAM.  We only need that for MRW.

If you send me a patch, I'll be sure to review it. I won't be adding MRW
in 2.4. I made a substantial amount of changes and bug fixes while
migrating the code to 2.6, and I don't want to spend time on porting
that back to 2.4.

-- 
Jens Axboe

