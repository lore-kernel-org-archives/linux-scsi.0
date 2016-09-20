From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 5/7] pas16: remove from tree
Date: Tue, 20 Sep 2016 10:12:28 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1609200955490.3516@nippy.intranet>
References: <1474300253-31351-1-git-send-email-hch@lst.de> <1474300253-31351-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:56916 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932272AbcITAM1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 20:12:27 -0400
In-Reply-To: <1474300253-31351-6-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, schmitzmic@gmail.com, linux@rainbow-software.org


On Mon, 19 Sep 2016, Christoph Hellwig wrote:

> The driver has not seen any maintainer activity or other work that 
> wasn't tree wide conversion or clenaups in the entire history of the git 
> tree.

That could indicate mature code, absent maintainer etc. It doesn't justify 
or explain code removal.

In this case, no-one seems to have the hardware needed to test the code, 
and no-one appears willing to do the conversion to the scsi_host_alloc() 
API. I think this justification should appear in the commit message.

On that basis, I would remove these drivers along with scsi_register() 
itself. Is there some reason to remove them earlier? It messes up my patch 
queue.

Either way, you may add my
Acked-by: Finn Thain <fthain@telegraphics.com.au>
for the pas16, t128 and dtc patches if you like.

-- 
