From: Andrew Morton <akpm@osdl.org>
Subject: Re: Adaptec 29160 + Promise Ultratrak100 TX8 problems
Date: Wed, 25 May 2005 15:33:37 -0700
Message-ID: <20050525153337.0a4436f5.akpm@osdl.org>
References: <20050308145251.6b73b8b6.mdeboer@iua.upf.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:60299 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261554AbVEYWc5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 18:32:57 -0400
In-Reply-To: <20050308145251.6b73b8b6.mdeboer@iua.upf.es>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maarten de Boer <mdeboer@iua.upf.es>
Cc: aic7xxx@freebsd.org, linux-scsi@vger.kernel.org

Maarten de Boer <mdeboer@iua.upf.es> wrote:
>
> Hello,
> 
> I am having nasty problems with an Adaptec 29160 and Promise
> Ultratrak100 TX8 external RAID. (kernel 2.6.11)

Could you please test 2.6.12-rc5, provide us with a status update?

Thanks.

> Initially, I can access the RAID normally. I create a (small, for
> testing) partition on it, and an ext3 filesystem. But when I start
> writing, in no-time the RAID and the SCSI adapter get into a broken
> state, and rebooting both RAID and Linux (simply rmmod/modprobe is not
> enough) is the only way out.
> 
> I trigger this with a small test like creating 10000 files, or
> extracting a kernel tar.gz.
> 
> In my /var/log/messages I find:
> 
> Mar  8 10:58:22 iua-file-2 kernel: (scsi3:A:0:0): data overrun detected in Data-out phase.  Tag == 0x2.
> Mar  8 10:58:22 iua-file-2 kernel: (scsi3:A:0:0): Have seen Data Phase.  Length = 524288.  NumSGs = 33.
> Mar  8 10:58:52 iua-file-2 kernel: scsi3:0:0:0: Attempting to queue an ABORT message
> Mar  8 10:58:52 iua-file-2 kernel: CDB: 0x2a 0x0 0x0 0x2 0x8c 0x37 0x0 0x4 0x0 0x0
> Mar  8 10:58:52 iua-file-2 kernel: scsi3: At time of recovery, card was not paused
> Mar  8 10:58:52 iua-file-2 kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> Mar  8 10:58:52 iua-file-2 kernel: scsi3: Dumping Card State in Data-out phase,
> at SEQADDR 0x17b
> Mar  8 10:58:52 iua-file-2 kernel: Card was paused
> 
> I have tried changing settings in the adaptec controller BIOS, I tried
> lowering the global_tag_depth, all to no avail. And having the reboot
> everytime it goes wrong makes trying things rather slow :-(
> 
> I googled for the messages, and found many people mentioning them, but
> no solution.
> 
> I'd very much appreciate your help. Please Cc: me when replying, because
> I am not subscribed to the lkml.
> 
> Kind regards,
> 
> Maarten
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
