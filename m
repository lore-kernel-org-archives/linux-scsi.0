From: "Ming Zhang" <mingz@ele.uri.edu>
Subject: Re: Re: Re: about scsi_hostlist
Date: Sun, 17 Nov 2002 18:16:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211172318.gAHNI699027197@leviathan.ele.uri.edu>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

======= At 2002-11-17, 17:58:00 you wrote: =======

>On Sun, Nov 17, 2002 at 05:35:52PM -0500, Ming Zhang wrote: > Hi, Doug > >
>For example, like the iSCSI target code, when it start, it should find all
>SCSI disks or tapes link in order to export to client side. It need the
>scsi_device pointer in order to send requests to it. That is why I need
>it. Is there a formal way to find a scsi_device pointer by its lun, host
>id, ... or by block layer major number and minor number?
>
>There is a process by which it can be found, but it's too long to do on 
>each command.  That means you need to hold a pointer to the device open 
>to make this not be a performance slug.  What are you doing to hold a 
>refcount on the devices you grab the pointer for so that they don't get 
>freed without you knowing it?
Yes, I want to hold a pointer to the device open and modify its refcount
directly. Although this might be a little informal.
Or do u have any suggestion to me for implement such a kernel module
in a more formal way. thx.
>
>P.S. - Enabling word wrap in your mailer would be most appreciated.

my mail client is a very pony one. I will change it soon. thanks for 
remind.

>-- 
>  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
>         Red Hat, Inc. 
>         1801 Varsity Dr.
>         Raleigh, NC 27606
>  
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>.

= = = = = = = = = = = = = = = = = = = =
			



