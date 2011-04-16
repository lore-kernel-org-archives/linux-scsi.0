From: Jens Axboe <axboe@kernel.dk>
Subject: Re: 2.6.39-rc3-git3 problem   etc , reset-resistent problem
Date: Sat, 16 Apr 2011 22:38:40 +0200
Message-ID: <4DA9FE50.6000303@kernel.dk>
References: <web-506106345@zbackend1.aha.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34335 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab1DPUir (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Apr 2011 16:38:47 -0400
In-Reply-To: <web-506106345@zbackend1.aha.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: werner <w.landgraf@ru.ru>
Cc: James.Bottomley@HansenPartnership.com, mingo@elte.hu, Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de, tj@kernel.org, randy.dunlap@oracle.com, linux-scsi@vger.kernel.org

On 2011-04-16 06:22, werner wrote:
> 
> 
> Pls see the enclosed screen foto.
> 
> After the crashs of 2.6.39-rcX , which I already 
> reclaimed, and after -rc3-git4 and the patch suggested me 
> to try out, the computer in vesa grafic mode crashs 
> quickly, in fbdev only after longer time.     After this 
> crash, on re-booting, happens early during  the boot 
> process a next kind of  crash.   This don't go away on 
> reset nor on power off, i.e. booting 
> 2.6.39-rc3-git4-patchs  again, it repeats.    Only after 
> rebooting with 2.6.38.2 or another working kernel, one can 
> booting again with 2.6.39-rc3-git4-patchs -- until after 
> its next crash, when the same happens again.
> 
> Some of these secondary crashs show a message:   ata1: 
>  nv: stopping hardreset on occupied port,    and after 
> this the system attempts wrongly to understand the nv 
> grafic card as a hard disc, and claims about read errors, 
> until it crash.
> 
> Some of these secondary crashs, instead, look like the 
> enclosed foto, also understanding something wrongly as an 
> ata1 device.

Any chance you can setup a network console or serial console and capture
all of those messages?

-- 
Jens Axboe

