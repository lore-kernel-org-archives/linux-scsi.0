From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCH 0/3] libfc patches for kernel v4.2
Date: Mon, 29 Jun 2015 13:29:35 -0700
Message-ID: <1435609775.20022.10.camel@lin-nd1-054.jf.intel.com>
References: <20150605212003.6054.15351.stgit@lin-nd1-054.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:21818 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbbF2U3g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jun 2015 16:29:36 -0400
In-Reply-To: <20150605212003.6054.15351.stgit@lin-nd1-054.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@intel.com>, JamesBottomley <JBottomley@Odin.com>, "Christoph Hellwig <hch"@lst.de
Cc: linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, target-devel <target-devel@vger.kernel.org>

On Fri, 2015-06-05 at 14:20 -0700, Vasu Dev wrote:
> These libfc fixes are for kernel 4.2 and with two patches CCed for stable
> kernel also, those two could be picked for current 4.1 cycle now but in case
> too late for current 4.1 then anyway should get picked up by 4.1 stable
> kernel later.
> 
> These patches were posted by Bart Van Assche at open-fcoe.org and then 
> I updated them per discussion on original patches to pick revised patch
> and add related comments at:
> 
> http://lists.open-fcoe.org/pipermail/fcoe-devel/2015-May/012467.html
> 
> 
> Bart Van Assche (3):
>       libfc: Fix fc_fcp_cleanup_each_cmd()
>       libfc: Fix fc_exch_recv_req() error path
>       libfc: Fix a typo in a source code comment
> 
> 
>  drivers/scsi/libfc/fc_exch.c |    8 ++++----
>  drivers/scsi/libfc/fc_fcp.c  |   21 ++++++++++++++++++---
>  2 files changed, 22 insertions(+), 7 deletions(-)
> 

Hello James and Christoph,

This patch series is not applied as of now, so can you apply the patch
series ?

Thanks,
Vasu

