From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 10:03:06 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310280959590.793-100000@ida.rowland.org>
References: <1067313069.1277.17.camel@ronald.kuetemeier.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3332 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263997AbTJ1PDH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 10:03:07 -0500
In-Reply-To: <1067313069.1277.17.camel@ronald.kuetemeier.com>
List-Id: linux-scsi@vger.kernel.org
To: Ronald Kuetemeier <ronald@kuetemeier.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Mon, 27 Oct 2003, Ronald Kuetemeier wrote:

> Patrick,
> attached is a file (err_messages.txt) from an attempt to attach my Sony
> camera (S70) via usb-storage to my system. 
> It should include the relevant errors, if you want me to try something
> else let me know. It's the only usb and scsi device on that system, so I
> won't be able to kill anything else.
> I have also attached a file (succ_messages.txt) after I did:
> echo "Sony:Sony DSC:0x4000" > /proc/scsi/device_info
> which shows a successful (yeah) attempt to connect the camera to the
> system.
> If you need anything else, just let me know.
> Thanks for your help.
> Ronald
> BTW: I'm not on either list, if you (list users) have questions, need me
> to try something else. Please contact me directly.
> PS: Sorry for the cross posting, but maybe we can figure it out this
> way. 

As you probably already know, the page 3F MODE-SENSE request is made only 
to determine whether the device is read-only.  Most USB storage devices 
handle that request okay; there's only a handful that doesn't.  That's why 
we don't disable it by default.

It's not clear to me what is the best way to take care of the devices that 
choke on page 3F.  Should we use a special flag for those devices or 
should we disable it entirely?

Alan Stern

