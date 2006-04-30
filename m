From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: How to replace bus_to_virt()?
Date: Mon, 01 May 2006 01:40:46 +0200
Message-ID: <44554AFE.30804@s5r6.in-berlin.de>
References: <4454CF35.7010803@s5r6.in-berlin.de> <1146412215.20760.10.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57257 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751238AbWD3XnZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Apr 2006 19:43:25 -0400
In-Reply-To: <1146412215.20760.10.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 2006-04-30 at 16:52 +0200, Stefan Richter wrote:
>>is there a *direct* future-proof replacement for bus_to_virt()?
>>
>>It appears there are already architectures which do not define a 
>>bus_to_virt() funtion or macro. If there isn't a direct replacement, is 
>>there at least a way to detect at compile time whether bus_to_virt() exists?
> 
> 
> I'd go one step further: given a world with iommu's, and multiple pci
> domains etc, how can you know there even IS such a translation possible
> (without first having set it up from the other direction)?

Well, we actually do set it up from the other direction. But in a way 
that does not work with IOMMUs...

AFAIU, the patch "dc395x: dynamically map scatter-gather for PIO" [1] by 
Guennadi Liakhovetski is dealing with the same issue. I am not yet clear 
whether I could adopt this method for sbp2.
[1] http://marc.theaimsgroup.com/?l=linux-scsi&t=114400790300004
-- 
Stefan Richter
-=====-=-==- -=-= ----=
http://arcgraph.de/sr/
