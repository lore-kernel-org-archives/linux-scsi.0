From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Thu, 27 Mar 2008 19:51:58 +0100
Message-ID: <3ae72650803271151k5a7b5c4cn5078b3bdf6a9c87a@mail.gmail.com>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca>
	 <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca>
	 <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca>
	 <20080325192515.GA24234@suse.de> <47E99A02.7040903@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:32493 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbYC0SwA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 14:52:00 -0400
Received: by rn-out-0910.google.com with SMTP id e24so3584195rng.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2008 11:51:59 -0700 (PDT)
In-Reply-To: <47E99A02.7040903@rtr.ca>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Mar 26, 2008 at 1:34 AM, Mark Lord <lkml@rtr.ca> wrote:
> Greg KH wrote:
>  > On Tue, Mar 25, 2008 at 01:37:03PM -0400, Mark Lord wrote:
>
> >> Perhaps Greg will chime in.
>  >
>  > I've been waiting to see if sanity will take hold of anyone here.
>  ..
>
>  So have we.  sysfs is a total nightmare to extract information from
>  under program / script control.  The idea presented in this thread,
>  is to have it cross-index the contents with a method that actually
>  makes it easy to access in many common scenarios, without requiring
>  huge gobs of code in user space.  Or in kernel space.
>
>  And it's not just a few 10s of lines of code currently,
>  but rather about 80-100 lines just to find the correct device subdir,
>  and *then* a few more 10s of lines of code to retrieve the value.

Hmm, 100 lines? What else do you need?

  $ grep -l 8:3 /sys/class/block/*/dev
  /sys/class/block/sdc/dev

Kay
