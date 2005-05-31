From: Rhys Johnson <rhys@golfbox.com.au>
Subject: megaraid driver for PE1850 running SME Server 6.5
Date: Tue, 31 May 2005 13:03:52 +0800
Message-ID: <1117515832.27402.24.camel@bogey.golfbox.com.au>
Reply-To: rhys@golfbox.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from golfbox.com.au ([203.166.11.110]:41194 "HELO golfbox.com.au")
	by vger.kernel.org with SMTP id S261783AbVEaFD6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2005 01:03:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello
I am trying to install SME Server 6.5 on my PE1850 which has the
PERC4e/SI raid controller. SME uses RedHat 7.3 kernel 2.4.20. I
installed SME on another machine not running raid and located the raid
driver in
/lib/modules/2.4.20-37.7.legacy/kernel/drivers/scsi/megaraid.o. 
i then copied this file onto a floppy and inserted it when asked by the
installer.The installer still fails to pick up the driver. What am i
doing wrong?
I also tried running "linux dd" from the boot prompt but it doesnt
recognise "linux" as the correct boot argument. 

Any help would be greatly appreciated
-- 
Rhys Johnson <rhys@golfbox.com.au>
GolfBox

