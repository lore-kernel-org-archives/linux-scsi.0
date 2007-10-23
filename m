From: Mike Aerts <mmgaerts@skynet.be>
Subject: Mysterious hangs of system.
Date: Tue, 23 Oct 2007 22:13:38 +0200
Message-ID: <200710232213.38194.mmgaerts@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:20790 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbXJWUNk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Oct 2007 16:13:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: promise_linux@promise.com

Hi all,

I have 44 supermicro PDSMi servers running linux 2.6.17.13.
Each of these systems have a Promise Super Trak EX16350 controller with 16 WDC 
WD5000ABYS-01TNA disks connected.
The controllers have BIOS 2.9.022 installed and the stex driver used is 
version 2.9.0.16.
These servers are used in a backup-to-disk environment and are connected via 
NFS to 4 backup servers.
Now every few days, mostly at night, one of these servers hang for about 40 
minutes which can be defined as not accepting any TCP/IP connections; no 
crontab jobs (sar) are run.  After this period that can vary from 5 minutes 
to 60 minutes spontaneously the system becomes available again and 
disconnects the stex controller device not the disks.

This also occurs with the latest version of Linux 2.6.23.1 but in this version 
it has as a more negative effect as also both devices created on these disks 
are offlined and the system hangs for the same amount of time. With the newer 
version of the kernel I also get an handshake failure message.  As the root 
filesystem is on these disks too I cannot login into the server and have to 
reboot the system after what the system comes up like nothing has happened. 
With the newer version of the kernel and stex driver the system is also 
unstable when I allow the system to start in SMP then I cannot even create a 
ext3 filesystem as I get a kernel panic in add_list telling me the pointers 
are corrupt.

Question has anybody else encountered these problem? In what direction do I 
have to seek is this a issue with the stex driver or stex firmware?

Thanks in advance


Mike.
  
