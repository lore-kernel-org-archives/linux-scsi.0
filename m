From: Michael Smith <mike@chat.za.net>
Subject: Re: PERC4/DC (LSI Megaraid) on PowerEdge 2850
Date: Tue, 7 Dec 2004 09:43:12 +0200 (SAST)
Message-ID: <Pine.LNX.4.33.0412070941240.5215-100000@starlight.chat.za.net>
References: <OF471775C1.63CE2BB0-ON85256F63.000B34DD-85256F63.000DB1FE@lexmark.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from starlight.chat.za.net ([196.4.161.7]:10511 "EHLO
	starlight.chat.za.net") by vger.kernel.org with ESMTP
	id S261715AbULGHnX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Dec 2004 02:43:23 -0500
In-Reply-To: <OF471775C1.63CE2BB0-ON85256F63.000B34DD-85256F63.000DB1FE@lexmark.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: webster@lexmark.com
Cc: linux-poweredge@dell.com, linux-scsi@vger.kernel.org


You have a bad disk,one of your disks has failed and has been taken
offline by the raid controller...

If you look at the lights on the disk, you will see one of them is burning
orange.. thats your failed disk.

I am not sure what kind of raid setup you are using, but I had a similar
issue a few weeks ago

Mike

On Mon, 6 Dec 2004 webster@lexmark.com wrote:

> Hello.
> I am trying to use a Dell PERC4/DC RAID controller in a Dell PowerEdge
> 2850 with SUSE Linux .
>
> Every time I try to copy files to a partition on this controller, after
> ~10GB, I start receiving this in syslog:
>
> Dec  6 20:25:14 tasker0 kernel: megaraid: aborting-484304 cmd=2a <c=2 t=1
> l=0>
> Dec  6 20:25:14 tasker0 kernel: megaraid abort: 484304:115[255:1], fw
> owner
> Dec  6 20:25:14 tasker0 kernel: megaraid: aborting-484307 cmd=2a <c=2 t=0
> l=0>
> Dec  6 20:25:14 tasker0 kernel: megaraid abort: 484307:46[255:0], fw owner
> .
> .
> .
> Dec  6 20:28:14 tasker0 kernel: megaraid: aborting-484438 cmd=2a <c=2 t=1
> l=0>
> Dec  6 20:28:14 tasker0 kernel: megaraid abort: 484438[255:1], driver
> owner
> Dec  6 20:28:14 tasker0 kernel: megaraid: reseting the host...
> Dec  6 20:28:14 tasker0 kernel: megaraid: 71 outstanding commands. Max
> wait 180 sec
> Dec  6 20:28:14 tasker0 kernel: megaraid mbox: Wait for 71 commands to
> complete:180
> Dec  6 20:28:14 tasker0 kernel: 3>scsi2 (1:0): rejecting I/O to offline
> device
> Dec  6 20:28:14 tasker0 kernel: scsi2 (0:0): rejecting I/O to offline
> device
> Dec  6 20:28:14 tasker0 kernel: scsi2 (1:0): rejecting I/O to offline
> device
> Dec  6 20:28:14 tasker0 kernel: scsi2 (1:0): rejecting I/O to offline
> device
> Dec  6 20:28:14 tasker0 kernel: SCSI error : <2 2 0 0> return code =
> 0x6000000
> Dec  6 20:28:14 tasker0 kernel: end_request: I/O error, dev sdf, sector
> 1064044038
> Dec  6 20:28:14 tasker0 kernel: scsi2 (0:0): rejecting I/O to offline
> device
> Dec  6 20:28:14 tasker0 kernel: SCSI error : <2 2 0 0> return code =
> 0x6000000
> Dec  6 20:28:14 tasker0 kernel: end_request: I/O error, dev sdf, sector
> 1064043910
> .
> .
> .
>
>
>
> Any advice?
>
> Thanks.
>
> _______________________________________________
> Linux-PowerEdge mailing list
> Linux-PowerEdge@dell.com
> http://lists.us.dell.com/mailman/listinfo/linux-poweredge
> Please read the FAQ at http://lists.us.dell.com/faq
>

