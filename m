From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 15:29:45 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310281526251.6609-100000@ida.rowland.org>
References: <1067370946.1104.51.camel@ronald.kuetemeier.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:26116 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261744AbTJ1U3q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 15:29:46 -0500
In-Reply-To: <1067370946.1104.51.camel@ronald.kuetemeier.com>
List-Id: linux-scsi@vger.kernel.org
To: Ronald Kuetemeier <ronald@kuetemeier.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, 28 Oct 2003, Ronald Kuetemeier wrote:

> Right, so the questions is where is it. Since usb-storage-debug was/is
> turned on before the test.
> I looked at my  messages file again and can't find anything. This flag
> should be on for some time in my kernels, and I have used different gcc
> to compile these but there never seems to be any output from usb-storage
> in my kept history of messages. And the camera seems to work just fine
> if there is no 3f test. I  even copied to and from the camera at the
> test8 time frame, with slightly modified sd.c to avoid the tests.
> Any ideas where my usb-storage debug info might go, checked my
> syslog.conf, standard ... Oh well maybe some more printk tonight, it has
> to go somewhere. 
> Please let me know if you have an idea.
> Got to be some misconfiguration somewhere, sorry. I will let you know
> after I find the output.
> Ronald

If your syslog.conf is standard, it probably ignores debugging messages.  
You will need to add a line that says something like:

kern.debug		/var/log/debug

Alan Stern


