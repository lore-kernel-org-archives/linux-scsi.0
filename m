From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Disk errors
Date: Mon, 31 Jan 2005 13:21:49 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BB5203F@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:13989 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261296AbVAaSVy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 13:21:54 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kit Gerrits <kit@gerritsacc.nl>
Cc: linux-scsi@vger.kernel.org

The PERC controller looks after bad block reassignment.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Kit Gerrits [mailto:kit@gerritsacc.nl] 
Sent: Monday, January 31, 2005 11:44 AM
To: Salyzyn, Mark
Cc: linux-scsi@vger.kernel.org
Subject: RE: Disk errors

Indeed, I had an entire screenful of errors (a few each second) when I
came
in in the morning...
The strange thing is, that the drive with the grown error is part of the
DATA container (/home and /data), whilst the disk with the rest ( / )
was
fine.

You'd expect the error to show  up in /var/log/messages, but it didn't. 
I think the entire controller gave up as soon as the error popped up.

-----
Is there a way of having the controller detect / handle grown errors?
Will setting automatic remapping handle this?

Does Anyone know how to read / write mode pages?
----

Thanks all!

Kit

> -----Oorspronkelijk bericht-----
> Van: Salyzyn, Mark [mailto:mark_salyzyn@adaptec.com] 
> Verzonden: maandag 31 januari 2005 17:03
> Aan: Kit Gerrits
> Onderwerp: RE: Disk errors
> 
> You get tones of I/O error messages from the filesystem 
> driver once the device goes offline. You can check 
> /var/log/messages to find the root cause.
> 
> You will need to run the RAID management tools (afacli) to 
> display the underlying components (container list). Dell has 
> their own customized tools for this, I can not comment on their usage.
> 
> Sincerely -- Mark Salyzyn
> 

