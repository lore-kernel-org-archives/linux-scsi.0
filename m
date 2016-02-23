From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>] sr_runtime_suspend+0xc/0x20
 [sr_mod]
Date: Tue, 23 Feb 2016 10:14:35 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1602231011290.1698-100000@iolanthe.rowland.org>
References: <CAM79t8ErGXsDb+8Vsn77gKOe7JPJJLNpjOEzkZktHEJvOXoZWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50278 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752241AbcBWPOh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2016 10:14:37 -0500
In-Reply-To: <CAM79t8ErGXsDb+8Vsn77gKOe7JPJJLNpjOEzkZktHEJvOXoZWQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexandre Rossi <alexandre.rossi@gmail.com>
Cc: Paul Menzel <paul.menzel@giantmonkey.de>, Erich Schubert <erich@debian.org>, Ben Hutchings <ben@decadent.org.uk>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org

On Tue, 23 Feb 2016, Alexandre Rossi wrote:

> Okay now I've tried with 4.4. The oops does not occur. So this is
> fixed for me in 4.4.
> 
> If there is interest in backporting to 4.3, 13b438914341 ("SCSI: fix
> crashes in sd and sr runtime PM") is not enough to backport. Something
> in 4.4, most probably 4fd41a8552af ("SCSI: Fix NULL pointer
> dereference in runtime PM") is also needed.

Although that commit isn't in 4.3.x yet, it should be added soon.  
Maybe in the next release.

Alan Stern

