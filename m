From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: SCSI Enclosure Support (multipath)
Date: Wed, 15 Feb 2012 11:06:08 +0200
Message-ID: <20120215090608.GN12984@reaktio.net>
References: <CAB9NSeWgz_m+F7-3JE5Jn12Yi_PjG002UCoKdq9sj7WQLnJ29w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:64668 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab2BOJGK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Feb 2012 04:06:10 -0500
Content-Disposition: inline
In-Reply-To: <CAB9NSeWgz_m+F7-3JE5Jn12Yi_PjG002UCoKdq9sj7WQLnJ29w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Robert Woodworth <robertjwoodworth@gmail.com>

> Hello all.

Hello!

> I'm a firmware engineer working on an expander inside an external
> enclosure that supports SES.  I have been using the sg interface
> (/dev/sgXX) sg_ses and sg_write_buffer to communicate to my device
> fine for some time now.
>
> Searching through the list archives, I found a thread from 2008
> discussing the ses.c kernel patch and associated /sys/ interface and
> lack of /dev/ interface in that code.
>
> For my enclosure, the /sys/ interface is inadequate.  It does not
> appear to provide access to a SSP READ_BUFFER, WRITE_BUFFER or monitor
> generic SES elements.  (the enclosure provides SES monitoring of temp,
> fans and PSU voltages)
>
>
> What I would like to see is a /dev/sesXX mapping such that the I, and
> my soon to come ses monitoring apps don't have to search through the
> /dev/sgXX system to find the SES devices.
>
> Second, my enclosure is 'dual redundant'.  I have two expanders
> providing two paths to each drive and two SES devices in one
> enclosure.  In the sg interface, this becomes two handles (/dev/sg5
> and /dev/sg6  or whatever...)  To handle the true multipath this
> should have a single virtual handle accessing both SES devices and
> failover abilities.
>
> However, my end customers will never need such a Linux kernel system.
> The enclosure is only supported by the mfg on a LSI MegaRAID.  The LSI
> firmware already works perfectly with this system.  It reports one SES
> device and each drive one time and has no problems if one expander is
> removed, re-added then the second expander removed.  The LSI hides the
> SES from the OS anyway, just like it hides the individual drives.
>
>
> Does anyone have similar needs or working on something like this?


I'm not aware of anyone working on this, but I'm sure it's needed
by other aswell!


> If I don't find anything our there, I intend on writing my own kernel
> module to support this.
> Would it be useful enough to share and possibly submit a patch?


Yes please, definitely send a patch :)


-- Pasi


> RJW.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

