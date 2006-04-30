From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: How to replace bus_to_virt()?
Date: Sun, 30 Apr 2006 17:50:14 +0200
Message-ID: <1146412215.20760.10.camel@laptopd505.fenrus.org>
References: <4454CF35.7010803@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:64930 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751155AbWD3PuR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Apr 2006 11:50:17 -0400
In-Reply-To: <4454CF35.7010803@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 2006-04-30 at 16:52 +0200, Stefan Richter wrote:
> Hi all,
> 
> is there a *direct* future-proof replacement for bus_to_virt()?
> 
> It appears there are already architectures which do not define a 
> bus_to_virt() funtion or macro. If there isn't a direct replacement, is 
> there at least a way to detect at compile time whether bus_to_virt() exists?

I'd go one step further: given a world with iommu's, and multiple pci
domains etc, how can you know there even IS such a translation possible
(without first having set it up from the other direction)?


