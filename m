From: "Peter Stokes" <peter_stokes@dadeos.freeserve.co.uk>
Subject: =?iso-8859-1?Q?aacraid_1.1.5-2372_waiting..?=
Date: Tue, 25 Jan 2005 18:27:09 -0000
Message-ID: <001101c5030b$7b038900$f800000a@tuscan>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmailg1.svr.pol.co.uk ([195.92.195.171]:29444 "EHLO
	cmailg1.svr.pol.co.uk") by vger.kernel.org with ESMTP
	id S262039AbVAYS1T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2005 13:27:19 -0500
Received: from user-7310.l1.c3.dsl.pol.co.uk ([81.79.28.142] helo=tuscan)
	by cmailg1.svr.pol.co.uk with smtp (Exim 4.14)
	id 1CtVPB-0000HK-3v
	for linux-scsi@vger.kernel.org; Tue, 25 Jan 2005 18:27:09 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have recently bought an Adaptec 2410SA raid controller and I am having 
some IO performance difficulties. Basically, whenever I access the 
configured RAID5 logical device the CPU appears to be spending most of it's 
time in the 'iowait' state (I am running 'top' and the 'wa' figure shoots up 
(I think that's what it's telling me?)) this occurs for both reads and 
writes and is having a very detrimental affect on everything else running on 
the system. After some extensive googling I have come across other people's 
reports of similar behaviour but I have been unable to find any solutions?

My system configuration: -

AMD Athlon XP 2000+ (133MHz FSB)
512MB DDR RAM (Dual channel)
Asus A7N8X nForce2 motherboard (Rev 2.0 board with latest BIOS)
Adaptec 2410SA using 7348 firmware (installed in a 32-bit PCI slot)
3xHitachi Deskstar 7K250 250GB drives (1 RAID5 logical device using default 
64K stripe size containing 1 Ext3 partition made with appropriate 'stripe' 
option to mke2fs.

Slackware 10 base installation updated with most of the latest packages 
available.
Custom built 2.6.10 kernel (I have tried 2.4.26 as well)
aacraid 1.1.5-2372 (I have also tried the stock linux 2.6.10 aacraid driver)

The system appears to be running reasonably well apart from the dire 
performance, it always finds that array on boot, I can use the Adaptec 
Storage manager software etc. (Although the performance has prevented me 
using the RAID storage properly, at the moment it spends most of its time 
sitting in the system idle)

I have tried lots of different things, changing the PCI slot, changing the 
PCI latencies of the controller and other PCI devices, various combinations 
of drivers and kernels, turning IOAPIC on/off for the motherboard..

I would really appreciate any assistance anyone can provide me with this 
problem, even if it's only further diagnostics that I can try.

Thanks in advance.

Peter Stokes 

