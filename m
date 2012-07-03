From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH] BNX2I: Removed the reference to the
 netdev->base_addr
Date: Tue, 3 Jul 2012 15:06:48 -0700
Message-ID: <1341353208.10180.765.camel@dhcp-10-12-137-160.irv.broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1341013055-16339-1-git-send-email-eddie.wai@broadcom.com>
 <4FEE674C.9070807@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4564 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313Ab2GCWHC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jul 2012 18:07:02 -0400
In-Reply-To: <4FEE674C.9070807@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

Thanks, Mike.

Hello James,

This patch is actually a critical bug fix as the 1G bnx2 driver no
longer supports the netdev->base_addr in the current kernel of the scsi
tree.  This means that Broadcom's 1G Linux iSCSI offload solution would
not work at all without this patch.  If at all possible, please consider
including this patch into the fixes branch.

Thanks,
Eddie

On Fri, 2012-06-29 at 21:41 -0500, Mike Christie wrote:
> On 06/29/2012 06:37 PM, Eddie Wai wrote:
> > The netdev->base_addr parameter has been deprecated in the L2 bnx2
> > driver.  This is used by bnx2i for the BARn iomapping.
> >
> > This patch will directly reference the pci_resource_start instead
> > of using the deprecated netdev->base_addr.
> >
> > Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
> 
> 
> Looks ok to me
> 
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> 


