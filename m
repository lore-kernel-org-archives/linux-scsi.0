From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Tue, 23 Sep 2003 08:46:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309230840060.14017-100000@home.osdl.org>
References: <UTC200309231437.h8NEb8N23975.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:3715 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261458AbTIWPqs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2003 11:46:48 -0400
In-Reply-To: <UTC200309231437.h8NEb8N23975.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, david-b@pacbell.net, greg@kroah.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-usb@one-eyed-alien.net, patmans@us.ibm.com, stern@rowland.harvard.edu


On Tue, 23 Sep 2003 Andries.Brouwer@cwi.nl wrote:
> 
> No, the design goal of "hot-pluggable" is that it indicates that
> the device can disappear any moment. Nothing at all about SCSI
> compliance.

You're talking past each other.

Server people think that "hot-pluggable" means "I will tell the system 
before it goes away". Normal users consider hot-pluggable to be "I can rip 
the thing out by hand".

I'm with the normal users - I think the server guys are really talking 
about "controlled shutdown and insert", not "hot-pluggable", but hey, the 
fact is, there's two kinds.

Trying to enumerate three values with one bit is counterproductive.

So we should _not_ have one bit that says "hotpluggable", we should have
separate bits for "should survive a unexpected disconnect" (_real_
hotplug) and "can be disconnected with operator help" (server
"pseudo-hotplug").

USB devices are obviously supposed to be able to just be ripped out, ie
"unexpected", real hotplug.  While FC etc tends to be "pseudo-hotplug".

			Linus

