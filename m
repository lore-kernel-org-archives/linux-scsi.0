From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] drop some attibutes from the FC transport class
Date: Wed, 19 Jan 2005 12:38:31 -0600
Message-ID: <41EEA927.7070602@us.ibm.com>
References: <20050119171357.GA16136@lst.de> <20050119172106.GB32702@kroah.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:2022 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S261836AbVASSii (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 13:38:38 -0500
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j0JIcXm4245772
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 13:38:33 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0JIcWlE263462
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 11:38:32 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j0JIcWua015532
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 11:38:32 -0700
In-Reply-To: <20050119172106.GB32702@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Greg KH wrote:
> On Wed, Jan 19, 2005 at 06:13:57PM +0100, Christoph Hellwig wrote:
> 
>>I think the hardware_version, firmware_version, rom_version and
>>driver_version don't belong into the FC transport class, there's
>>nothign specific to FC or even SCSI specific in them.
> 
> 
> Then put them in the individual driver (not the driver_version one
> though, that belongs as a MODULE_VERSION() paramater).
> 
> 
>>If you want these attributes talk to Greg about fiding a place in
>>the common driver model code for them.
> 
> 
> No, they don't belong there either, sorry :)

How about at an attribute on the pci object? I currently have a driver 
private firmware version in the ipr driver as a scsi_host class 
attribute. Not sure how many other drivers will end up doing similar. 
Might be nice to have a common way to export this information to 
userspace. Or we can always wait for more users before we do something 
like this...

-Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
