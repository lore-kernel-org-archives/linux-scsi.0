From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [stable] [SCSI] Fix incorrect memset in bnx2fc_parse_fcp_rsp
Date: Wed, 24 Jul 2013 16:20:48 +0200
Message-ID: <20130724142048.GV6123@two.firstfloor.org>
References: <1374637362.18653.13.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:55459 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3GXOUu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jul 2013 10:20:50 -0400
Content-Disposition: inline
In-Reply-To: <1374637362.18653.13.camel@deadeye.wl.decadent.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>, James Bottomley <JBottomley@Parallels.com>, stable@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Jul 24, 2013 at 04:42:42AM +0100, Ben Hutchings wrote:
> This looks like a candidate for stable:

Don't know if it's a security issue, but should be fine for stable.

-Andi

> 
> commit 16da05b1158d1bcb31656e636a8736a663b1cf1f
> Author: Andi Kleen <andi@firstfloor.org>
> Date:   Mon Sep 3 20:50:30 2012 +0200
> 
>     [SCSI] Fix incorrect memset in bnx2fc_parse_fcp_rsp
> 
> Typically this sort of bug can result in leaking kernel memory to
> userland, which is a security issue, but I don't know whether that's
> true in this case.
> 
> Ben.
> 
> -- 
> Ben Hutchings
> Once a job is fouled up, anything done to improve it makes it worse.



-- 
ak@linux.intel.com -- Speaking for myself only.
