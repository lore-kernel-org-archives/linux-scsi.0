From: "Surekha.PC" <surekhap@cisco.com>
Subject: RE: Sysfs does not recognise tape devices ?
Date: Thu, 6 Nov 2003 10:54:03 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <001701c3a426$37fa5110$a0074d0a@apac.cisco.com>
References: <Pine.LNX.4.58.0311052318250.2344@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:61362 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S263369AbTKFFYV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2003 00:24:21 -0500
In-Reply-To: <Pine.LNX.4.58.0311052318250.2344@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: 'Kai Makisara' <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org


Kai,

 Thanks for the information.
 The "/sys/bus/scsi/devices/" shows tape device attributes except for
device name. This is important w.r.t iSCSI devices where we use "udev"
to create device nodes from sysfs lookup. Can you please let me know how
soon the feature unfreeze will happen and when this feature can be made
part of the 2.6 kernel?

Thanks,
Surekha

-----Original Message-----
From: Kai Makisara [mailto:Kai.Makisara@kolumbus.fi] 
Sent: Thursday, November 06, 2003 2:56 AM
To: Surekha.PC
Cc: linux-scsi@vger.kernel.org
Subject: Re: Sysfs does not recognise tape devices ?


On Wed, 5 Nov 2003, Surekha.PC wrote:

>
> Hi,
>
> I have a iSCSI setup with scsi disk and tape configured as iSCSI 
> targets. The disks are recognised with sysfs, but tape device entries 
> are not getting created.
>
The tapes should be visible as SCSI devices in, e.g.,
/sys/bus/scsi/devices/. You can find disks in /sys/block. The tapes
belong to /sys/cdev but it is a very new addition to sysfs and the code
to show the tapes there has not been done yet. It should be very easy
based on Doug Gilberts code for sg but the feature freeze will prevent
adding it to the official kernel for some time.

-- 
Kai

