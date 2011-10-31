From: yoma sophian <sophian.yoma@gmail.com>
Subject: Re: question about passing physical address to lower level driver in scsi
Date: Mon, 31 Oct 2011 09:53:47 +0800
Message-ID: <CADUS3on70KNyS5=NfMRN2eJ_aOGnZbUqo7_P_RsrEuW49xh48A@mail.gmail.com>
References: <CADUS3okkKEu_Re1FU_AvVk6agFwrmx0mwzbMSmso6pV8HFfWMA@mail.gmail.com>
	<20111030132821.4df33f1e@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53975 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab1JaBxs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Oct 2011 21:53:48 -0400
Received: by qyk27 with SMTP id 27so5867552qyk.19
        for <linux-scsi@vger.kernel.org>; Sun, 30 Oct 2011 18:53:47 -0700 (PDT)
In-Reply-To: <20111030132821.4df33f1e@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org

hi stefan:
Thanks for your reply.
2011/10/30, Stefan Richter <stefanr@s5r6.in-berlin.de>:
> On Oct 30 yoma sophian wrote:
>> in scsi_init_sgtable, we create sgtable, sdb->table.sgl, and get the
>> page from blk_rq_map_sg.
>> But when the dma_address of sdb->table.sgl will be calclated out
>> before send the scsi command down to the lower level driver?
>
> The low level driver, not SCSI core, is responsible to obtain a DMA
> address.

Why I ask this because I found there is no same transformation for
scsi usb subsystem.
Would anyone can let me know where it is?
>
> dma_map_sg() maps the scatter-gather list into DMA memory.  Then you can
> iterate over the list with for_each_sg and obtain DMA handles and lengths
> with sg_dma_address() and sg_dma_len().  E.g.:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/firewire/sbp2.c;h=41841a3e3f99c9acd4c4fc72c972626d8dffdcee;hb=02f8c6aee8df3cdc935e9bdd4f2d020306035dbe#l1398
> --
> Stefan Richter
> -=====-==-== =-=- ====-
> http://arcgraph.de/sr/
>
Retards,
