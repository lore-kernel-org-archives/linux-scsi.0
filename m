From: Or Gerlitz <ogerlitz@voltaire.com>
Subject: Re: [PATCH] iscsi transport endpoint calls
Date: Mon, 24 Apr 2006 17:54:38 +0300
Message-ID: <444CE6AE.8020502@voltaire.com>
References: <Pine.LNX.4.44.0604111646040.18200-100000@zuben>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from taurus.voltaire.com ([193.47.165.240]:34342 "EHLO
	taurus.voltaire.com") by vger.kernel.org with ESMTP
	id S1750812AbWDXOyn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Apr 2006 10:54:43 -0400
In-Reply-To: <Pine.LNX.4.44.0604111646040.18200-100000@zuben>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, hch@lst.de, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu

Or Gerlitz wrote:
> This patch allows for iscsi transport to have its connection 
> being established and disconnected from the kernel.
> 
> The patch is the sixth iscsi update to 2.6.18 and is needed by iser,
> it is relative to the five iscsi patches sent by Mike Christie.
> 
> Doing this is a must for iSER and some of the iscsi offloads but on the
> other hand not needed for TCP where a socket (fd) is connected in user space
> and then sent down to the kernel where struct sock is retrieved from the fd.
> 
> The iscsi user space implementation was enhanced to have a user space
> transport where TCP is doing things directly from user space and iSER
> is using the extension to the iscsi u/k IPC ABI to do things in the kernel.
> 
> Acked-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Or Gerlitz <ogerlitz@voltaire.com>

James, Christoph:

As the iscsi patches sent by Mike Christie were accepted and merged into 
the scsi-misc git tree, this patch is the remaining iscsi related piece 
on which iser is dependent and is not yet accepted for upstream push.

We really need your feedback on the patch, which allowed us to remove 
the pseudo socket from iser (Christoph is aware to the details).

Once the patch is accepted, Roland will open a branch for iser upstream 
push on the his infiniband git tree and pull the iscsi updates into it, 
so the tree compiles.

Or.


