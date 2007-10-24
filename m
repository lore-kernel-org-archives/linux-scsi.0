From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm 08/11] parisc: make iommu respect the segment size
 limits
Date: Wed, 24 Oct 2007 07:35:01 -0400
Message-ID: <471F2DE5.3060708@garzik.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org> <20071024172113Y.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60522 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbXJXLfF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 07:35:05 -0400
In-Reply-To: <20071024172113Y.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kyle@parisc-linux.org, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> This patch makes iommu respect segment size limits when merging sg
> lists.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/parisc/ccio-dma.c      |    2 +-
>  drivers/parisc/iommu-helpers.h |    7 ++++++-
>  drivers/parisc/sba_iommu.c     |    2 +-
>  3 files changed, 8 insertions(+), 3 deletions(-)

patches 3-8 look OK

