From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: App correlating PCI info with SCSI host number
Date: Thu, 27 Jan 2005 11:14:38 -0600
Message-ID: <20050127171438.GC10491@lists.us.dell.com>
References: <20050127141251.82212.qmail@web12308.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:64164 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S262675AbVA0ROj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jan 2005 12:14:39 -0500
Content-Disposition: inline
In-Reply-To: <20050127141251.82212.qmail@web12308.mail.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Cameron <smcameron@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 27, 2005 at 06:12:51AM -0800, Stephen Cameron wrote:
> 
> I know on 2.6, I seem to be able to do 
> something like this to correlate PCI 
> (domain)/bus/dev/func with the linux 
> assigned scsi host number.
> 
> myhost:/sys/bus/scsi/devices # find /sys/devices -name 'host[0-9]*' -print
> /sys/devices/pci0000:64/0000:64:01.1/host15
> /sys/devices/pci0000:64/0000:64:01.0/host14
> /sys/devices/pci0000:62/0000:62:01.1/host11
> /sys/devices/pci0000:62/0000:62:01.0/host10
> /sys/devices/pci0000:60/0000:60:03.1/host9
> /sys/devices/pci0000:60/0000:60:03.0/host8
> /sys/devices/pci0000:60/0000:60:02.1/host7
> /sys/devices/pci0000:60/0000:60:02.0/host6
> /sys/devices/pci0000:38/0000:38:01.1/host5
> /sys/devices/pci0000:38/0000:38:01.0/host4
> /sys/devices/pci0000:34/0000:34:01.1/host13
> /sys/devices/pci0000:34/0000:34:01.0/host12
> /sys/devices/pci0000:20/0000:20:03.1/host3
> /sys/devices/pci0000:20/0000:20:03.0/host2
> /sys/devices/pci0000:20/0000:20:02.1/host1
> /sys/devices/pci0000:20/0000:20:02.0/host0
> 
> Is there any generic way to make the same sort
> of correlation on 2.4 kernels?

There's an ioctl() to a disk, SCSI_IOCTL_GET_PCI, so if the controller
has a disk attached, you can get it.

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
