From: Ronald Kuetemeier <ronald@kuetemeier.com>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 12:55:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067370946.1104.51.camel@ronald.kuetemeier.com>
References: <Pine.LNX.4.44L0.0310281408540.793-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:58823 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S261731AbTJ1UM4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 15:12:56 -0500
Received: from gw.kuetemeier.com (12-254-105-101.client.attbi.com [12.254.105.101])
	by zeus.kernel.org (8.11.6/8.11.6) with ESMTP id h9SJvJK11000
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2003 11:57:19 -0800
In-Reply-To: <Pine.LNX.4.44L0.0310281408540.793-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, 2003-10-28 at 12:17, Alan Stern wrote:
> On Tue, 28 Oct 2003, Ronald Kuetemeier wrote:
> 
> > Alan,
> > sorry. Still working on my coffee.
> > I just looked at my .config and debug is turned on:
> > 
> > CONFIG_USB_STORAGE=y
> > CONFIG_USB_STORAGE_DEBUG=y
> > 
> > Any special sysctl you want me to set, didn't see anything in the
> > Documentation/usb dir to this regard.
> > And while I'm on it, do you need scsi debugging info with the usb debug
> > info, to see the interaction. Or should I just use usb debug?
> > Thanks,
> > Ronald
> 
> That should be fine.  I asked because I didn't see any usb-storage 
> debugging messages in the log you posted on Monday (err_messages.txt).
> 
Right, so the questions is where is it. Since usb-storage-debug was/is
turned on before the test.
I looked at my  messages file again and can't find anything. This flag
should be on for some time in my kernels, and I have used different gcc
to compile these but there never seems to be any output from usb-storage
in my kept history of messages. And the camera seems to work just fine
if there is no 3f test. I  even copied to and from the camera at the
test8 time frame, with slightly modified sd.c to avoid the tests.
Any ideas where my usb-storage debug info might go, checked my
syslog.conf, standard ... Oh well maybe some more printk tonight, it has
to go somewhere. 
Please let me know if you have an idea.
Got to be some misconfiguration somewhere, sorry. I will let you know
after I find the output.
Ronald

> Usb-storage debugging alone should be enough.  No need for special 
> sysctl's or scsi debugging.  While I don't expect this will give us a lot 
> of new information, it should at least illustrate more precisely the exact 
> nature of the failure mode.
> 
> Alan Stern
> 
> 
> 

