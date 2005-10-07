From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [patch] fix unnecessary activation of blk tag queue for qla2x00
Date: Fri, 7 Oct 2005 10:03:56 -0700
Message-ID: <20051007170356.GC8370@plap.qlogic.org>
References: <B05667366EE6204181EABE9C1B1C0EB5086AEC35@scsmsx401.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:39807 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1030508AbVJGRD6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2005 13:03:58 -0400
Content-Disposition: inline
In-Reply-To: <B05667366EE6204181EABE9C1B1C0EB5086AEC35@scsmsx401.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 07 Oct 2005, Chen, Kenneth W wrote:

> Regarding to discussion on LKML:
> http://marc.theaimsgroup.com/?t=112865351000001&r=1&w=2

Ok, I had expected something like this to show on ls after the
discussion on lk.

> It turns out that qla2x00 driver unnecessarily activated generic
> blk tag queue without actually use any of the tag maintained by
> the block layer.  I suggest we turn that off until there is a
> real consumer of the tag queuing in the qla driver. Please apply.
> 
> Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
> 

ACK.

Thanks,
Andrew Vasquez
