From: Kantor Zsolt <kantorzsolt@yahoo.com>
Subject: SG_GET_VERSION_NUM and SG_IO issue
Date: Mon, 7 Jul 2008 17:59:07 -0700 (PDT)
Message-ID: <670709.40869.qm@web35402.mail.mud.yahoo.com>
Reply-To: kantorzsolt@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web35402.mail.mud.yahoo.com ([66.163.179.111]:21875 "HELO
	web35402.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755209AbYGHBFs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2008 21:05:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi, I have a strange problem with the SG_GET_VERSION_NUM, and the SG_IO ioctl
I have blacklisted and renamed all my SCSI subsystem drivers, so the kernel can't load them. I have checked with lsmod, and yes the drivers are not loaded. All my SCSI subsystem is compiled as modules for my running kernel (CONFIG_SCSI=m, CONFIG_CHR_DEV_SG=m, CONFIG_BLK_DEV_SD=m . . .), I checked that in the running kernel config file in the /boot directory.
In my initrd image the SCSI drivers are not present either.    
Even so, if the SCSI susbsystem is not loaded at all I can execute successfully the SG_GET_VERSION_NUM ioctl and I can even send commands via the SG_IO ioctl. How is that possible if there are no SCSI drivers loaded ??
My kernel version is 2.6.18-6-k7 and I'm using Debian etch, if this information is helpful 

Thanks,
  Kantor


      
