From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] [RFC] Deferred disk spinup during system resume
Date: Thu, 30 Dec 2010 23:46:07 +0100
Message-ID: <201012302346.07275.rjw@sisk.pl>
References: <AANLkTinOqLOJ7JCpHeQNYUEirqAvkSce+eFDCGkWn3jE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:45376 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab0L3WrC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Dec 2010 17:47:02 -0500
In-Reply-To: <AANLkTinOqLOJ7JCpHeQNYUEirqAvkSce+eFDCGkWn3jE@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maksim Rayskiy <maksim.rayskiy@gmail.com>
Cc: linux-pm@lists.linux-foundation.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>

On Thursday, December 30, 2010, Maksim Rayskiy wrote:
> Hello,
> 
> When resuming from system suspend, scsi disks are being spun up which
> takes quite a lot of time (5+ seconds in my case). The spinup is done
> synchronously, so this time adds up to overall system resume time.
> Ours is an embedded platform and we are using flash-based rootfs, so
> there is no immediate need in harddrive after resume. What is much
> more important for us is to minimize time-to-full-power. To speed up
> resume, we would like to have an option to defer the spinup or run it
> in parallel with system resume. I could not find any existing
> mechanism to do the trick, but I might have missed something.
> 
> Can anybody comment on this?

Do you use asynchronous suspend/resume?

Rafael
