From: Douglas Gilbert <dougg@torque.net>
Subject: Re: firmware help
Date: Sat, 11 Sep 2004 23:14:31 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4142FA37.6030108@torque.net>
References: <Pine.LNX.4.58.0409081347100.27903@shenandoah> <311601c9040910092061681de5@mail.gmail.com> <Pine.LNX.4.58.0409101236210.27903@shenandoah>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:1743 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S268081AbUIKNP0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Sep 2004 09:15:26 -0400
In-Reply-To: <Pine.LNX.4.58.0409101236210.27903@shenandoah>
List-Id: linux-scsi@vger.kernel.org
To: jklaas <jklaas@comcast.net>
Cc: linux-scsi@vger.kernel.org

jklaas wrote:
> On Fri, 10 Sep 2004, Eric Mudama wrote:
> 
> 
>>On Wed, 8 Sep 2004 14:51:42 -0400 (EDT), jklaas <jklaas@comcast.net> wrote:
>>
>>>From everything I've read about firmware on SCSI drives, it appears to be
>>>impossible to extract the firmware from a drive.  I was hoping that there
>>>was some sort of SCSI programming judo to make this drive divulge this
>>>information.  Would I be better off trying to extract the firmware
>>>directly from the flash chip somehow?
>>>
>>>I was hoping to find some firmware for some EMC Symmetrix/Seagate drives.
>>>These are Elite 47 drives labelled with Seagate model #ST446452W, and
>>>a "non-Seagate" part number 9K7001-021.  These drives were apparently only
>>>ever sold to EMC and were designed by Seagate for EMC specifically.  (Is
>>>this true of all the Elite drives?)
>>>
>>>Seagate said "The part number you provided for us indicates that the drive
>>>is OEM.  Please contact your vendor to receive the proper firmware
>>>upgrade."  Unfortunately, EMCs support site is impenetrable.
>>>
>>>Thank you for your help.
>>
>>I'm sure there is hidden judo to extract that data, but those who know
>>it aren't allowed to reveal it because we either 1) work for a drive
>>manufacturer and would get fired or 2) work for a data recovery
>>company and make our living with that judo.
>>
>>What exactly do you hope to accomplish with a binary firmware image
>>anyway?  The firmware is liable to be a binary image from a custom
>>architecture... which'd be a LOT of work to try to decode into
>>something meaningful...
>>
>>--eric
>>
> 
> 
> Well, the problem is that I have a bunch of disks (ST446452W) with one
> firmware version (B407) that doesn't seem to report data correctly to my
> RAID card (MegaRAID 438/Enterprise 1400, Firmware GH8E, BIOS 1.48) and
> otherwise don't respond to that RAID card.  However, one disk that has a
> different firmware version (B410) does seem to report correctly to the
> RAID card and does appear to work correctly.  It appears to be impossible
> to locate a firmware file for these disks, so I was just hoping there was
> some way to create one from the disk that does work.
> 
> I'll probably be working on another way around this (i.e. a different
> RAID card or back-rev the firmware on the MegaRAID 438).

Well if you like living dangerously you could try reading
the B410 version firmware and then install it on one of the
B407 models. At the SCSI command level READ BUFFER and WRITE
BUFFER with appropriate parameters could do this for you.

None of my tools can do that but you could look at "scu"
(which was recently rebuilt for current linux distributions)
and "scsirastools".

Doug Gilbert
