From: "Ming Zhang" <mingz@ele.uri.edu>
Subject: Re: Re: about scsi_hostlist
Date: Sun, 17 Nov 2002 18:3:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211172304.gAHN4h99024044@leviathan.ele.uri.edu>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>




======= At 2002-11-17, 22:57:00 you wrote: =======

>On Sun, Nov 17, 2002 at 05:43:38PM -0500, Ming Zhang wrote:
>> >Why you just do this in userspace?
>> >
>> that iscsi target have to be a kernel module.
>
>why?
basically, an iscsi target tell clients how many scsi devices it has, then iscsi client login and get a reference from it. might be an id stand for a certain scsi device, for example, the lun. then client send request and target get this request, check which scsi device the request want to operate on, and call routine to finish it. since the main operations is tcp/ip send/recv and scsi read/write. I think write it as a kernel module is more suitable. and currently, all iscsi reference implementation on 2.4.x kernel are kernel modules.
>
>> >Umm, no.  Nothing but upperlayer drivers is supposed to talk to the scsi
>> >midlayer directly. Implement an upperlayer driver and check for disks in
>> >->attach instead.
>> ~~~would u like to explain this in more detail? which ->attach?
>
>The attach routine of the upper layer driver.  See struct
>Scsi_Device_Template in hosts.h or look at one of the existing upper
>layer drivers (like sd or sr)
thx, i will check that.
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>.

= = = = = = = = = = = = = = = = = = = =
			




