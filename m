From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] drop some attibutes from the FC transport class
Date: Wed, 19 Jan 2005 17:03:39 -0600
Message-ID: <41EEE74B.2090907@us.ibm.com>
References: <20050119171357.GA16136@lst.de> <20050119172106.GB32702@kroah.com> <20050119213924.GG5508@us.ibm.com> <20050119224016.GA5086@kroah.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:36350 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261957AbVASXDm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 18:03:42 -0500
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j0JN3ful573090
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 18:03:41 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0JN3flE258464
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 16:03:41 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j0JN3e64030992
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 16:03:40 -0700
In-Reply-To: <20050119224016.GA5086@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Greg KH wrote:
> On Wed, Jan 19, 2005 at 01:39:24PM -0800, Mike Anderson wrote:
> 
>>Greg KH [greg@kroah.com] wrote:
>>
>>>On Wed, Jan 19, 2005 at 06:13:57PM +0100, Christoph Hellwig wrote:
>>>
>>>>I think the hardware_version, firmware_version, rom_version and
>>>>driver_version don't belong into the FC transport class, there's
>>>>nothign specific to FC or even SCSI specific in them.
>>>
>>>Then put them in the individual driver (not the driver_version one
>>>though, that belongs as a MODULE_VERSION() paramater).
>>
>>Are there plans to export MODULE_VERSION info in /sys/module/*/ ? I
>>believe the intent was to try and use libsysfs to access these attributes
>>/ info.
> 
> 
> I had a patch to do that around here somewhere, but I think it was
> rejected as people can get the same info by using 'modinfo' instead.
> You know, the old, "use a userspace tool instead of wasting kernel
> memory" argument :)

That's too bad. modinfo will only tell you information about the driver 
that modprobe finds, which is not necessarily what is currently loaded 
in kernel memory.

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
