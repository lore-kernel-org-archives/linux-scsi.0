From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: sata_sil24 0000:04:00.0: DMA-API: device driver frees DMA sg list
	with different entry count [map count=13] [unmap count=10]
Date: Wed, 27 May 2009 04:11:56 +0200
Message-ID: <64bb37e0905261911v1b80456ckbc7b7c7858d4b28a@mail.gmail.com>
References: <64bb37e0905261214g2957924ar837339367f320d4c@mail.gmail.com>
	 <4A1C7DDB.9010605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:37723 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842AbZE0CL4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2009 22:11:56 -0400
In-Reply-To: <4A1C7DDB.9010605@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, May 27, 2009 at 1:40 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> Torsten Kaiser wrote:
>>
>> On upgrading to 2.6.30-rc1 I enable the DMA-Debugging option
>> CONFIG_DMA_API_DEBUG=y
>> Since then I get the following or similar errors on each boot:
>
> Please retest with a newer -rc, this patch likely fixes it:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5825627c9463581fd9e70f8285685889ae5bb9bb
>

I saw this with 2.6.30-rc1 the first time, but I'm not sure if it
broke during the merge window or if it was always broken, because I
did not have enable DMA_API_DEBUG with earlier kernels.

But I'm seeing it with all -rc since then. The traces I posted were
from -rc6 and -rc7.

Torsten
