From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: [PATCH] Format Unit can take many hours
Date: Tue, 11 May 2004 10:01:55 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0405110952380.14297-100000@sweetums.bluetronic.net>
References: <20040511114936.GI4828@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sweetums.bluetronic.net ([24.199.150.42]:23200 "EHLO
	sweetums.bluetronic.net") by vger.kernel.org with ESMTP
	id S264738AbUEKOGi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2004 10:06:38 -0400
In-Reply-To: <20040511114936.GI4828@tpkurt.garloff.de>
Content-ID: <Pine.GSO.4.33.0405110952382.14297@sweetums.bluetronic.net>
Content-Disposition: INLINE
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>

On Tue, 11 May 2004, Kurt Garloff wrote:
>the timeout for FORMAT_UNIT should be much longer; I've seen 8hrs
>already (75Gig). I've increased the timeout from 2hrs to 12hrs.

If you execute a FORMAT_UNIT properly, the timeout is irrelevant.  Set the
IMMED bit so the command returns as soon as the drive begins processing it.
Send TEST_UNIT_READY to check the progress.  I'll have to consult the
spec, but I think support for Immed is required.

That's how my (now 8 year old) tool for formating scsi devices (zip, jaz,
hard disks, tapes, etc.) has always worked. [No, it is not published code.
If the script kiddies want to low-level your hard drive, they're gonna have
to learn how to do it themselves.]

--Ricky

PS: That even works under Solaris where one does not have the source code
    to change the command timeouts.


