From: "Ming Zhang" <mingz@ele.uri.edu>
Subject: Re: Re: about scsi_hostlist
Date: Sun, 17 Nov 2002 17:43:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211172245.gAHMj199022666@leviathan.ele.uri.edu>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


>On Sun, Nov 17, 2002 at 05:35:52PM -0500, Ming Zhang wrote:
>> Hi, Doug
>> 
>> For example, like the iSCSI target code, when it start, it should find all SCSI disks or tapes link in order to export to client side.
>
>Why you just do this in userspace?
>
that iscsi target have to be a kernel module.

>> It need the scsi_device pointer in order to send requests to it. That is why I need it.
>
>Umm, no.  Nothing but upperlayer drivers is supposed to talk to the scsi
>midlayer directly. Implement an upperlayer driver and check for disks in
>->attach instead.
~~~would u like to explain this in more detail? which ->attach?

thx

>
>.





