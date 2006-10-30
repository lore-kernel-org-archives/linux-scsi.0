From: Aboo Valappil <aboo@aboo.org>
Subject: Re: Disk simulator driver
Date: Mon, 30 Oct 2006 23:42:32 +1100
Message-ID: <4545F338.5010904@aboo.org>
References: <1162153159.6802.21.camel@home-desk>	 <20061029230243.GB13218@lists.us.dell.com> <1162166907.6802.24.camel@home-desk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp245-155.static.internode.on.net ([59.167.245.155]:50817 "EHLO
	goobu.aboo.org") by vger.kernel.org with ESMTP id S932182AbWJ3Mmw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Oct 2006 07:42:52 -0500
In-Reply-To: <1162166907.6802.24.camel@home-desk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sean Bruno <sean.bruno@dsl-only.net>
Cc: Matt Domsch <Matt_Domsch@dell.com>, SCSI development list <linux-scsi@vger.kernel.org>

Hi Sean,

I have posted some messages before with the subject "About SG Elements 
of request_buffer" and "SCSITAP, Virtual SCSI HBA and user space SCSI 
initiators". Can you please read them and tell me what you think?
I have exactly what you wanted, and other people in the email group 
either said it is already there or not seems to be very much interested.

Basically, i built to impliment some user space SCSI engines and 
initiators. If you want i can email you a working copy of it where you 
can present the normal files as disks.

Aboo

Sean Bruno wrote:
> On Sun, 2006-10-29 at 17:02 -0600, Matt Domsch wrote:
>   
>> On Sun, Oct 29, 2006 at 12:19:19PM -0800, Sean Bruno wrote:
>>     
>>> Is there a project/driver that would take a disk/file/lvm partition as
>>> an argument(/dev/sda, /tmp/my_big_file.bin /dev/Mapper/MYLVMPART eg.)
>>> and then create a new /dev entry that could be read/written to as though
>>> it were a disk?
>>>
>>> I think I want to look at sg, but I wasn't sure if that is what I want.
>>>
>>> Just poking around for fun and education.
>>>
>>> Sean
>>>       
>> You want something different than losetup and /dev/loop ?
>> e.g. something you can issue disk-like ioctls to?
>>
>>     
> Precisely.  I am interested in capturing the data that would be sent to
> the device and copying it somewhere before it is written to the disk.
> Kind of like the way target mode drivers accept a file/disk as a target
> for their operations.
>
> Sean
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

