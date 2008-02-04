From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 04 Feb 2008 19:25:42 +0300
Message-ID: <47A73C86.3060604@vlnb.net>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	 <1201639331.3069.58.camel@localhost.localdomain>	 <47A05CBD.5050803@vlnb.net>  <47A7049A.9000105@vlnb.net> <1202139015.3096.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:55416 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbYBDQZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 11:25:44 -0500
In-Reply-To: <1202139015.3096.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

James Bottomley wrote:
>>Vladislav Bolkhovitin wrote:
>>So, James, what is your opinion on the above? Or the overall SCSI target 
>>project simplicity doesn't matter much for you and you think it's fine 
>>to duplicate Linux page cache in the user space to keep the in-kernel 
>>part of the project as small as possible?
> 
> 
> The answers were pretty much contained here
> 
> http://marc.info/?l=linux-scsi&m=120164008302435
> 
> and here:
> 
> http://marc.info/?l=linux-scsi&m=120171067107293
> 
> Weren't they?

No, sorry, it doesn't look so for me. They are about performance, but 
I'm asking about the overall project's architecture, namely about one 
part of it: simplicity. Particularly, what do you think about 
duplicating Linux page cache in the user space to have zero-copy cached 
I/O? Or can you suggest another architectural solution for that problem 
in the STGT's approach?

Vlad
