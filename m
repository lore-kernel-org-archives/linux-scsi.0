From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH 3/5] aacraid: update dma mapping
Date: Wed, 30 Nov 2005 10:55:01 -0800
Message-ID: <1133376901.2288.28.camel@markh1.pdx.osdl.net>
References: <1133375778.2288.23.camel@markh1.pdx.osdl.net>
	 <1133376327.3312.43.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:56725 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751506AbVK3SzO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 13:55:14 -0500
In-Reply-To: <1133376327.3312.43.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, 2005-11-30 at 12:45 -0600, James Bottomley wrote:
> On Wed, 2005-11-30 at 10:36 -0800, Mark Haverkamp wrote:
> > This patch changes map_single to map_page in compliance with
> > recommendations made in the IO-Perf howto document to prevent bounce
> > buffering of DMA requests.
> 
> Erm, there's a misunderstanding somewhere.  You're replacing correct
> pci_map_single calls with its more difficult to use pci_map_page.  This
> has absolutely zero performance impact and adds the risk that because
> pci_map_page is more complex to use, someone gets it wrong somewhere.
> Really, for block devices pci_map_single is the absolutely correct
> interface.  pci_map_page should really only be used by the net stack for
> packet fragment mapping.

Thanks,  The remaining patches still apply cleanly without it.

Mark.


> 
> James
> 
-- 
Mark Haverkamp <markh@osdl.org>

