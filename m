From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi wait_for_completion hangs!!!
Date: Fri, 22 Aug 2003 10:53:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030822105303.A12533@infradead.org>
References: <BAY7-F92BLMasiZAPG400002a63@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:14859 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263143AbTHVJxF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2003 05:53:05 -0400
Content-Disposition: inline
In-Reply-To: <BAY7-F92BLMasiZAPG400002a63@hotmail.com>; from invictus_rm@hotmail.com on Fri, Aug 22, 2003 at 03:18:06PM +0530
List-Id: linux-scsi@vger.kernel.org
To: invictus rm <invictus_rm@hotmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Aug 22, 2003 at 03:18:06PM +0530, invictus rm wrote:
> hi ,
>     I am trying to write a HBA driver for a  PCI SCSI card(linux - 2.4.7 ).
> 
>    On insmoding the driver( after enabling scsi verbose logging) i was able 
> to trace the point at which it get stuck.

2.4.7 is obsolete.  IF it still happens with 2.4.21 please post the
affected driver source so we can take a look what you're doing wrong.

