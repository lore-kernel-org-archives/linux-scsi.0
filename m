From: Sanjoy Mahajan <sanjoy@mrao.cam.ac.uk>
Subject: Re: Linux 2.6.16-rc3
Date: Mon, 13 Feb 2006 08:42:17 +0000
Message-ID: <E1F8ZHl-0002zK-00@skye.ra.phy.cam.ac.uk>
References: <20060213001240.05e57d42.akpm@osdl.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mraos.ra.phy.cam.ac.uk ([131.111.48.8]:13215 "EHLO
	mraos.ra.phy.cam.ac.uk") by vger.kernel.org with ESMTP
	id S1751080AbWBMIma (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2006 03:42:30 -0500
In-Reply-To: Your message of "Mon, 13 Feb 2006 00:12:40 PST."
             <20060213001240.05e57d42.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Brown, Len" <len.brown@intel.com>, davem@davemloft.net, torvalds@osdl.org, linux-kernel@vger.kernel.org, axboe@suse.de, James.Bottomley@steeleye.com, greg@kroah.com, linux-acpi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, luming.yu@intel.com, lk@bencastricum.nl, helgehaf@aitel.hist.no, fluido@fluido.as, gbruchhaeuser@gmx.de, Nicolas.Mailhot@LaPoste.net, perex@suse.cz, tiwai@suse.de, patrizio.bassi@gmail.com, bni.swe@gmail.com, arvidjaar@mail.ru, p_christ@hol.gr, ghrt@dial.kappa.ro, jinhong.hu@gmail.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, bcrl@kvack.org

> I think we can assume that it will be seen there.  2.6.16 is going into
> distros and will have more exposure than 2.6.15, let alone
> 2.6.16-rcX.

A related point is that S3 sleep/wake problems are very difficult to
debug.  The bug is often not reproducible (I've had a few of those).
Or it happens early in the wakeup, when the serial console hasn't been
restored to a working state (at least on some machines, see bugzilla
#4270).  Or the system has bugs that prevents its going to sleep,
which also prevents any wakeup problems from being investigated.  

Or they happen to regular users, who give up and say 'my laptop cannot
go to sleep in Linux, oh well'.  Besides being inconvenient, it gives
Linux a bad name, especially when people nearby have iBooks and
PowerBooks running MacOS that sleep and wake in 2-3 seconds, including
restoring networking and wireless.

So there's value in chasing any S3 bugs that can be reproduced,
especially those affecting sleeping.

The TP 600X is indeed old, and perhaps the bug is caused by an
otherwise fine change uncovering a 600X hardware or firmware bug
(perhaps the point that comment #8 at bugzilla 5989 is getting at).
However, one of the beauties of Linux, and a nightmare for developers,
is that Linux works on all sorts of hardware.  I don't know whether
this bug should affect the 2.6.16 schedule.  But I think its worth
solving eventually, if only to point where it's clear that it's unique
to this model.

-Sanjoy

`Never underestimate the evil of which men of power are capable.'
         --Bertrand Russell, _War Crimes in Vietnam_, chapter 1.
