From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] drop some attibutes from the FC transport class
Date: Wed, 19 Jan 2005 16:59:48 -0600
Message-ID: <41EEE664.60808@us.ibm.com>
References: <20050119171357.GA16136@lst.de> <20050119172106.GB32702@kroah.com> <41EEA927.7070602@us.ibm.com> <20050119184534.GC1235@kroah.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:34746 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S261956AbVASW7u
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 17:59:50 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j0JMxnaQ216682
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 17:59:49 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0JMxnUm458154
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 15:59:49 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j0JMxmBA015165
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 15:59:49 -0700
In-Reply-To: <20050119184534.GC1235@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Greg KH wrote:
> On Wed, Jan 19, 2005 at 12:38:31PM -0600, Brian King wrote:
> 
>>Greg KH wrote:
>>
>>>On Wed, Jan 19, 2005 at 06:13:57PM +0100, Christoph Hellwig wrote:
>>>
>>>
>>>>I think the hardware_version, firmware_version, rom_version and
>>>>driver_version don't belong into the FC transport class, there's
>>>>nothign specific to FC or even SCSI specific in them.
>>>
>>>
>>>Then put them in the individual driver (not the driver_version one
>>>though, that belongs as a MODULE_VERSION() paramater).
>>>
>>>
>>>
>>>>If you want these attributes talk to Greg about fiding a place in
>>>>the common driver model code for them.
>>>
>>>
>>>No, they don't belong there either, sorry :)
>>
>>How about at an attribute on the pci object?
> 
> 
> It is a pci specific attribute?  If so, I'll add it to the pci core.
> Otherwise you are free to add it yourself to the pci device in your pci
> driver to that location.

I won't argue that it is a pci specific attribute, since there are 
plenty of devices out there that have firmware that are not pci devices, 
such as scsi disks. This just seems like too common of an attribute to 
have each driver doing their own thing. The options as I see them are:

1. scsi_host class
2. pci core
3. driver unique



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
