From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>] sr_runtime_suspend+0xc/0x20
 [sr_mod]
Date: Tue, 19 Jan 2016 11:38:32 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1601191127020.1727-100000@iolanthe.rowland.org>
References: <CAGKbab941Nh7Sy1NTZC6ySxG_P5g7HpjATQ_GSCvDY8y=qgmHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58306 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755740AbcASQie (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2016 11:38:34 -0500
In-Reply-To: <CAGKbab941Nh7Sy1NTZC6ySxG_P5g7HpjATQ_GSCvDY8y=qgmHA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erich Schubert <erich@debian.org>
Cc: Paul Menzel <paul.menzel@giantmonkey.de>, Ben Hutchings <ben@decadent.org.uk>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org, Alexandre Rossi <alexandre.rossi@gmail.com>

On Tue, 19 Jan 2016, Erich Schubert wrote:

> Hi,
> Attached are photos of the Kernel null pointer BUG that I'm observing.
> 
> These shots are with 4.4.0-rc8.
> As you can see, I have a similar trace to Paul, but the error occurs
> one stack frame earlier?

Yours is only slighly similar to Paul's.  He got an error in 
sr_runtime_suspend, but your error occurs in sd_resume -- a completely 
different function in a different source file.

> Maybe Alex issue is the same bug, but triggered slightly different or
> just the kernel compiled differently.
> __rpm_callback, scsi_autopm_put_device, __pm_runtime_resume, sd_probe
> is present in all of these traces.
> 
> Sorry, I do not have a lot of time right now to help testing or debugging.

I can't tell what's going wrong without some real debugging.  This
means somebody has to build and test a patched kernel.  There are no
problems on my computer, so it will have to be one or more of you guys.

Alan Stern

