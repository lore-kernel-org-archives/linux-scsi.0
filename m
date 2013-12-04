From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 01/11] hpsa: use workqueue instead of kernel thread for lockup detection
Date: Wed, 4 Dec 2013 10:31:54 -0600
Message-ID: <20131204163154.GY31390@beardog.cce.hp.com>
References: <20131107164258.3504.5892.stgit@beardog.cce.hp.com> <20131107164529.3504.60292.stgit@beardog.cce.hp.com> <1386007202.2018.28.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:22137 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766Ab3LDQb5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2013 11:31:57 -0500
Content-Disposition: inline
In-Reply-To: <1386007202.2018.28.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com, scameron@beardog.cce.hp.com

On Mon, Dec 02, 2013 at 10:00:02AM -0800, James Bottomley wrote:
> On Thu, 2013-11-07 at 10:45 -0600, Stephen M. Cameron wrote:
> > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > 
> > Much simpler and avoids races starting/stopping the thread.
> > 
> > Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Actually, perhaps you do need to resubmit the series: this is rejecting
> against scsi-misc because of your prior hpsa patches:

Ah, I did not realize you had taken these into your tree:

2f2ec0b [SCSI] hpsa: bring logical drives online when format completes
c99298f [SCSI] hpsa: hide logical drives with format in progress from linux

Since you had complained about the races, and suggested using a
workqueue rather than a kernel thread, I thought that meant you
had dropped them, so I had gone back to the drawing board.  I hope
to have a new version of the series for you this afternoon.

-- steve

> 
> patching file drivers/scsi/hpsa.c
> Hunk #1 succeeded at 170 (offset -2 lines).
> Hunk #2 succeeded at 4881 (offset 247 lines).
> Hunk #3 succeeded at 4899 (offset 247 lines).
> Hunk #4 succeeded at 4918 (offset 247 lines).
> Hunk #5 succeeded at 4947 (offset 247 lines).
> Hunk #6 FAILED at 4862.
> Hunk #7 FAILED at 4928.
> 2 out of 7 hunks FAILED -- saving rejects to file
> drivers/scsi/hpsa.c.rej
> patching file drivers/scsi/hpsa.h
> Hunk #1 FAILED at 130.
> 1 out of 1 hunk FAILED -- saving rejects to file drivers/scsi/hpsa.h.rej
> 
> James
> 
