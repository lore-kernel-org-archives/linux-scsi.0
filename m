From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 08:40:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210151540.g9FFe6N02667@localhost.localdomain>
References: <oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA22849
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 08:40:11 -0700
In-Reply-To: Message from Oliver Neukum <oliver@neukum.name>
   of "Tue, 15 Oct 2002 17:19:27 +0200." <200210151719.27064.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Doug Ledford <dledford@redhat.com>, andersen@codepoet.org, linux-scsi@vger.kernel.org

dledford@redhat.com said:
> Now, please, someone tell me why everyone is whining about user space
> doing so little to accomplish what the much larger patch that was
> posted does in kernel space?  My point is, and was, that since we need the
> user space manager *anyway* to handle things the kernel will *never*

oliver@neukum.name said:
> We don't need it. We may want to have it. It works without it, not as
> well, but it works. 

But this is the philosophy difference.  I see hotplug as a replacement for 
kernel code.  I also see it as a way of ditching all the cross subsystem glue 
in the kernel and having the hotplug manager work out what should go on.  
Duplicating the hotplug code in the kernel just in case the user isn't using 
hotplug seems to me to be a waste of effort and an unwanted addition of 
complexity.

The point also is that Eric wants this code to cope with the case where a 
drive is added or removed from the firewire chassis *after* the system has 
been initiallised.  By very definition this is a hotplug event.  It's not 
unreasonable to require the user to do something manual if they choose not to 
use the hotplug infrastructure.

James


