From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 12:45:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210151945.g9FJjOs03736@localhost.localdomain>
References: <andersen@codepoet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA30103
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 12:45:28 -0700
In-Reply-To: Message from Erik Andersen <andersen@codepoet.org>
   of "Tue, 15 Oct 2002 13:32:16 MDT." <20021015193216.GE15778@codepoet.org>
List-Id: linux-scsi@vger.kernel.org
To: andersen@codepoet.org
Cc: linux-scsi@vger.kernel.org

andersen@codepoet.org said:
> I suspect the 1394 maintainers would reject patches that infect the
> nodemgr with SBP-2 and/or SCSI specific stuff.  Sigh.  We seem to be
> at an impasse.  We either screw up SCSI or we screw up 1394... 

Not necessarily.  We're back around to my original though which was that the 
hotplug event isn't carrying enough information.  Since 1394 can have may 
different types of device attaching, it stands to reason that some of them 
will need to pass extra information through the hotplug event.

Driverfs can be used for this in 2.5, but in 2.4 I suspect you need to enhance the 1394 nodemgr to allow customisable information.  Note, this doesn't require nodemgr to know about sbp-2, but it does require nodemgr to know "this device wants to add this information to the hotplug event", which does sound generic enough to be acceptable without layering violations.

James


