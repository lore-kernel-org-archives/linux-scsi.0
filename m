From: ajit k jena <ajit@iitb.ac.in>
Subject: INTEL SRCS16 (SATA) reliability+performance issues
Date: Sat, 4 Feb 2006 22:40:41 +0530 (IST)
Message-ID: <Pine.LNX.4.44.0602042237570.1163-100000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.iitb.ac.in ([202.68.145.249]:33473 "HELO smtp1.iitb.ac.in")
	by vger.kernel.org with SMTP id S932530AbWBDRKq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Feb 2006 12:10:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi All,

Hope this is the correct forum for asking my questions. Pl forgive
me if it is otherwise.

I am facing severe reliability issues with the following environment:

OS: MANDRIVA 2006

KERNEL : 2.6.12-12mdksmp

RAID CARD: INTEL SRCS16

KERNEL MODULE: megaraid_mbox

DISKS (these are 400 GB units) I am using: 
	HITACHI ATA HDS724040KLSA80
	SEAGATE ATA ST3400832AS

After I setup the hardware RAID, it seems to work ok (the read/write
performance is very poor though) but after a few days, the RAID disk
collapses with the following errors in /var/log/messages:

   Feb  4 05:49:58 archive kernel: scsi2 (0:0): rejecting I/O to offline device
   Feb  4 05:49:58 archive kernel: EXT3-fs error (device sdc1): ext3_readdir: directory #1464833 contains a hole at offset 4096

My questions:

   a) Has anyone in this list tried this CARD+DISK combination and if so what
      are the experiences ?

   b) What am I possibly doing wrong ? I am using the same disks on a different
      system which has onboard SATA support. I have 8 such ports and I have
      configured a software RAID5 on that one. It seems to be quite stable and
      also the I/O thruput seems to be at least twice that of the hardware
      RAID5 configuration.

Pl try and share any information/suggestion you may have on this.

--ajit


