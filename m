From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: race condition between scsi device add/remove code paths in 2.6.28
Date: Fri, 23 Jan 2009 21:13:15 -0500
Message-ID: <497A793B.7010103@interlog.com>
References: <8b62ef2d0901231608y8df423ema178ae8700173ea1@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53776 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZAXCNW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2009 21:13:22 -0500
In-Reply-To: <8b62ef2d0901231608y8df423ema178ae8700173ea1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sudhakar <ssudhakarp@gmail.com>
Cc: linux-scsi@vger.kernel.org

Sudhakar wrote:
> Hi,
> 
> In our labs, we encountered a kernel crash, while stressing scsi
> device add/remove code path of 2.6.28 kernel. lsscsi output on my
> machine looks like this:
> 
> *******Start******
> 
> [root@IMIT2S005 ~]# lsscsi
> [0:0:0:0]    disk    ATA      ST3250620NS      3BKS  -
> [0:0:1:0]    disk    ATA      ST3250620NS      3BKS  -
> [0:0:2:0]    disk    ATA      ST3250620NS      3BKS  -
> [0:0:3:0]    disk    ATA      ST3250620NS      3BKS  -
> [0:1:0:0]    disk    Dell     VIRTUAL DISK     1028  /dev/sda
> [1:0:0:0]    cd/dvd  Optiarc  DVD RW AD-7190S  1.00  /dev/scd0
> [5:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sdb

As an aside, do you know why the first 4 "ATA" disks are
not showing a device node?

Doug Gilbert
