From: Harald Seipp <SEIPP@de.ibm.com>
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 18:57:57 +0200
Message-ID: <OF7D601105.DA2D411C-ONC125705A.005CB29A-C125705A.005D3238@de.ibm.com>
References: <42FB3CBD.6040006@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:9887 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751116AbVHKRBb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 13:01:31 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id j7BH1Ump136254
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 17:01:30 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7BH1Uo2194306
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 19:01:30 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j7BH1TDe001433
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 19:01:30 +0200
In-Reply-To: <42FB3CBD.6040006@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> Harald,
> I just tried remove-single-device followed by
> add-single-device and I got /dev/sda back again.
> I also placed the two commands in a script file
> so they were executed with a very short delay between
> the two commands.
>
> The test was with lk 2.6.13-rc6 and a multicard
> reader (4 luns) via the usb-storage driver.
Just tried on debian etc (2.6.13-rc6), two SCSI HDDs attached to an aic7xxx
- same issue, independent if I use procfs or sysfs for device removal.
But anyway, this behavior seems to be "working as designed" based on the
other feedback to this thread.
>
> > Can I easily query
> > if a device on "h b t l" is mounted to work-around?
>
> ls /sys/class/scsi_device/<h>:<b>:<t>:<l>
>
> will indicate (in the lk 2.6 series) that SCSI device
> "h b t l" is present or not. As for mounted file systems
> on (partitions of) a disk when its is removed and re-added,
> I'm not so sure: seems like a questionable procedure IMO.
This unfortunately does not tell me if there is a pending reference to the
device (e.g. due to mounted file systems). Such a reference would greatly
help to satisfy my needs.

Harald Seipp
IBM Systems and Technology Group

