From: Pedro Pla <pedropla@holidaymarketing.com>
Subject: Problem with Gdt driver under smp?
Date: Thu, 31 Oct 2002 16:37:07 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DC0EBB3.9030707@holidaymarketing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lgm.com.sg (bb-203-125-28-243.singnet.com.sg [203.125.28.243])
	by smtp23.singnet.com.sg (8.12.6/8.12.6) with SMTP id g9V8eKhc004600
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2002 16:40:21 +0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I was wondering if there is any known problem with the Gdt driver under 
an smp machine, I have a dual p3 scb2 motherboard, with 1-2GB ram, an 
scrmr intel 0 channel raid controller and 3 hotswap disks. Initially I 
thought it was a memory problem since the kernel was complaining at 
mem_alloc:89, however as long as the memory I move is not read from the 
disk (through a kernel compile, or a dd if=/dev/sda) then it seems to 
work fine. A kernel compiled with no smp works fine as well. I've tried 
kernels from the 2.2.22 to the 2.4.17-2.4.20-pre10-ac with pre11 patches 
applied on top.

The symptoms are segmentation faults, signal 11's, and occasionally 
kernel oops at mem_alloc:89, I have also seen several kernel oops in 
journal.c when I tried using ext3, I disactivated that but the faults 
remained. It has also froze once and given a kernel oops while loading 
the scsi driver at boot, and another time it simply rebooted the machine 
when loading the driver. Any ideas? For now I will work with only one 
cpu and smp disactivated since that gives no problems at all, but I 
would like to be able to unleash the full power of these machines.

Thanks

Pedro

