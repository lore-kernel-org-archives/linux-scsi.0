From: Douglas Gilbert <dougg@torque.net>
Subject: Re: A question on Linux SCSI low-level driver
Date: Sun, 09 May 2004 12:10:47 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <409D9327.9010000@torque.net>
References: <519672568F040C41B6FAC21ADF51B18FEFE3@mailnode1.commstor.crossroads.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:41744 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264254AbUEICNR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 May 2004 22:13:17 -0400
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FEFE3@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org

Lee Xing wrote:
> Hi,
> 
> We are trying to write a low-level driver (no need for a perfect one at this time, just need to register the disks and do some simple I/Os).  I would sincerely appreciate it if some one could give me some information/suggestions/hints.
> 
> This low-level driver has indirect (via other layers) information on physical disks, so it can only provide mid-level driver with bus number, target number and lun number of the disks.  It will convert SCSI passthrough commands coming from the mid-level driver and send the converted command packages to the disks (again, via other layers).  It also sends the responses coming from physical disks (via other layers) back to the mid-level driver.  The "other layers" are SCSI-ready and can handle SCSI cmds/responses well.
> 
> My questions are: 
> 
> - is it (i.e. registering the disks with mid-level driver and doing some
>   simple I/Os) doable if this low-level driver only provides mid-level with
>   bus/target/lun numbers (without any hardware-related information)?

Lee,
See the scsi_debug driver (either in the lk 2.4 or lk 2.6
series). It is a scsi subsystem LLD that is basically a
ram disk so there is no "hardware" information to exchange
with the mid level.

Doug Gilbert

> - what can be the potential problems (if nay)?
> 
> Best Regards,

