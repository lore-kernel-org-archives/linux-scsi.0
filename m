From: Don Jessup <donj@asaca.com>
Subject: SCSI memeory warnings
Date: Sun, 21 Sep 2003 10:11:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030921171159.81052.qmail@web14504.mail.yahoo.com>
Reply-To: donj@asaca.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web14504.mail.yahoo.com ([216.136.224.67]:4658 "HELO
	web14504.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262465AbTIURMA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Sep 2003 13:12:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


  I'm using the 2.4.22 linux kernel and I have a system that trys to bring
  48 SATA drives online.   For some reason it will only register the first
  41 devices with scsi subsystem.  In other words I get devices sda - sdz, 
  sdaa - sdao.  When it gets to the 42nd device, I see the following warning
  in /var/log/messages.


scsi::resize_dma_pool: WARNING, dma_sectors=26992, wanted=36736, scaling
scsi::resize_dma_pool: WARNING, dma_sectors=26992, wanted=27552, scaling
       WARNING, not enough memory, pool not expanded


  Oh, by the way this system has 2G of ram  and all 48 devices are seen when
   doing "cat" on /proc/scsi/scsi but as I wrote above only 41 devices get 
  assigned a name.  


    I read this might be a issue with kernel when compiling in support for 
  ISA.   I have recompiled kernel and removed support for ISA or at least I
  think I have.   

   Does anybody know why I would get these warnings and why not all 48 SATA
disk
   show up?


   

=====
Don Jessup
Asaca/Shibasoku Corp. of America
400 Corporate Circle, Unit G
Golden, CO  80401
303-278-1111 X232
donj@asaca.com
http://www.asaca.com
