From: Daniel Stekloff <dsteklof@us.ibm.com>
Subject: Re: lsscsi-0.11
Date: Fri, 9 Jan 2004 10:12:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401091012.28063.dsteklof@us.ibm.com>
References: <3FFE5B19.7050404@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:51610 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263561AbUAISPL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2004 13:15:11 -0500
In-Reply-To: <3FFE5B19.7050404@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, linux-scsi@vger.kernel.org
Cc: ananth@in.ibm.com

On Thursday 08 January 2004 11:41 pm, Douglas Gilbert wrote:
> lsscsi is a utility the uses sysfs in the linux 2.6 series kernels
> to list information about all SCSI devices (including devices
> that use the SCSI stack such as USB mass storage devices)
> or all SCSI hosts that are attached to the system. Both a compact
> format (default), one line per device, and a "classic" format (like
> the output of 'cat /proc/scsi/scsi') are supported for devices.
>
> Version 0.11 is available at
> http://www.torque.net/scsi/lsscsi.html
>
> This version has been reworked for lk 2.6.1-rc1 (and later)
> since sysfs support for st and sg devices has been (re-)added.
>
> lsscsi does not yet use libsysfs but may well soon. One thing
> that lsscsi does that is not yet available in libsysfs is
> to sort (and filter) directory entries. This is most likely
> not relevant for most libsysfs based applications but is
> convenient for those applications that display information
> for human consumption.


Yep, libsysfs doesn't implement any sorts or filters on any of the lists. It 
won't be difficult to do, the dlists have what's needed to complete the 
functionality. And, it would be useful for systool and other applications. We 
will add the sort and filter functions. If there's anything particular you 
have in mind, please let us know. There may be a slight delay in getting new 
changes into our tree, Ananth is traveling to Australia for the Linux 
conference.

Thanks,

Dan



> Doug Gilbert
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

