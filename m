From: Eric Mudama <edmudama@gmail.com>
Subject: Re: firmware help
Date: Fri, 10 Sep 2004 10:20:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <311601c9040910092061681de5@mail.gmail.com>
References: <Pine.LNX.4.58.0409081347100.27903@shenandoah>
Reply-To: Eric Mudama <edmudama@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.204]:45528 "EHLO mproxy.gmail.com")
	by vger.kernel.org with ESMTP id S267599AbUIJQU6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2004 12:20:58 -0400
Received: by mproxy.gmail.com with SMTP id 78so181358rnk
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2004 09:20:57 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.58.0409081347100.27903@shenandoah>
List-Id: linux-scsi@vger.kernel.org
To: jklaas <jklaas@comcast.net>
Cc: linux-scsi@vger.kernel.org

On Wed, 8 Sep 2004 14:51:42 -0400 (EDT), jklaas <jklaas@comcast.net> wrote:
> From everything I've read about firmware on SCSI drives, it appears to be
> impossible to extract the firmware from a drive.  I was hoping that there
> was some sort of SCSI programming judo to make this drive divulge this
> information.  Would I be better off trying to extract the firmware
> directly from the flash chip somehow?
> 
> I was hoping to find some firmware for some EMC Symmetrix/Seagate drives.
> These are Elite 47 drives labelled with Seagate model #ST446452W, and
> a "non-Seagate" part number 9K7001-021.  These drives were apparently only
> ever sold to EMC and were designed by Seagate for EMC specifically.  (Is
> this true of all the Elite drives?)
> 
> Seagate said "The part number you provided for us indicates that the drive
> is OEM.  Please contact your vendor to receive the proper firmware
> upgrade."  Unfortunately, EMCs support site is impenetrable.
> 
> Thank you for your help.

I'm sure there is hidden judo to extract that data, but those who know
it aren't allowed to reveal it because we either 1) work for a drive
manufacturer and would get fired or 2) work for a data recovery
company and make our living with that judo.

What exactly do you hope to accomplish with a binary firmware image
anyway?  The firmware is liable to be a binary image from a custom
architecture... which'd be a LOT of work to try to decode into
something meaningful...

--eric
