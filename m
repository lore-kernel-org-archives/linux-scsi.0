From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: firmware help
Date: Fri, 10 Sep 2004 12:29:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4141D671.20008@optonline.net>
References: <Pine.LNX.4.58.0409081347100.27903@shenandoah> <311601c9040910092061681de5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pegasus.allegientsystems.com ([208.251.178.236]:50191 "EHLO
	pegasus.lawaudit.com") by vger.kernel.org with ESMTP
	id S267527AbUIJQ3i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2004 12:29:38 -0400
In-Reply-To: <311601c9040910092061681de5@mail.gmail.com>
List-Id: linux-scsi@vger.kernel.org
To: Eric Mudama <edmudama@gmail.com>
Cc: jklaas <jklaas@comcast.net>, linux-scsi@vger.kernel.org

Eric Mudama wrote:
> On Wed, 8 Sep 2004 14:51:42 -0400 (EDT), jklaas <jklaas@comcast.net> wrote:
> 
>>From everything I've read about firmware on SCSI drives, it appears to be
>>impossible to extract the firmware from a drive.  I was hoping that there
>>was some sort of SCSI programming judo to make this drive divulge this
>>information.  Would I be better off trying to extract the firmware
>>directly from the flash chip somehow?
>>
>>I was hoping to find some firmware for some EMC Symmetrix/Seagate drives.
>>These are Elite 47 drives labelled with Seagate model #ST446452W, and
>>a "non-Seagate" part number 9K7001-021.  These drives were apparently only
>>ever sold to EMC and were designed by Seagate for EMC specifically.  (Is
>>this true of all the Elite drives?)
>>
>>Seagate said "The part number you provided for us indicates that the drive
>>is OEM.  Please contact your vendor to receive the proper firmware
>>upgrade."  Unfortunately, EMCs support site is impenetrable.
>>
>>Thank you for your help.
> 
> 
> I'm sure there is hidden judo to extract that data, but those who know
> it aren't allowed to reveal it because we either 1) work for a drive
> manufacturer and would get fired or 2) work for a data recovery
> company and make our living with that judo.
> 
> What exactly do you hope to accomplish with a binary firmware image
> anyway?  The firmware is liable to be a binary image from a custom
> architecture... which'd be a LOT of work to try to decode into
> something meaningful...

People have done it. There's hacked firmware floating around for NEC DVD 
burners...

> 
> --eric
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

