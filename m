From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Hot swapping SCSI drives
Date: Mon, 3 Feb 2003 08:48:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D5CD@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from petasus.hd.intel.com (petasus.hd.intel.com [10.127.45.3])
	by hermes.hd.intel.com (8.11.6/8.11.6/d: outer.mc,v 1.51 2002/09/23 20:43:23 dmccart Exp $) with ESMTP id h13GhHv12776
	for <linux-scsi@vger.kernel.org>; Mon, 3 Feb 2003 16:43:17 GMT
Received: from fmsmsxv040-1.fm.intel.com (fmsmsxvs040.fm.intel.com [132.233.42.124])
	by petasus.hd.intel.com (8.11.6/8.11.6/d: inner.mc,v 1.28 2003/01/13 19:44:39 dmccart Exp $) with SMTP id h13GfpY04580
	for <linux-scsi@vger.kernel.org>; Mon, 3 Feb 2003 16:41:51 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'Brad Stockdale' <bradsprt@greenepa.net>, linux-scsi@vger.kernel.org

Brad,

You shouldn't have any trouble.  The adapter is fine, and apparently the
disk drives are SCA connector for hotplug.  

There may be a temporary glitch on the SCSI bus if a disk is hot-inserted,
which can show up as either a SCSI parity error or SCSI overrun error, but
the aic7xxx 6.2.20+ driver should handle that ok.  You may want/need to do
the remove-/add-single-device functions also.

Andy

-----Original Message-----
From: Brad Stockdale [mailto:bradsprt@greenepa.net] 
Sent: Friday, January 31, 2003 9:25 PM
To: linux-scsi@vger.kernel.org
Subject: Re: Hot swapping SCSI drives


Hello all,

    I've poked around for info about hot-swapping SCSI drives under linux, 
and the only real info I found was "It may work if you have the right 
hardware, or it may fry your controller and/or hard drive."

    This doesn't give me warm and fuzzies... So I thought I'd check with 
the guru's before I tried to yank the drive out of my still-breathing 
computer...

    The pertinent information about my system configuration is as follows:

	o Running linux kernel 2.4.20
	o Has an Adaptec 2940W card for my SCSI subsystem
	o Have a SCSI drive in a nice removable enclosure -- I forget
exactly
	  what brand, but it cost around $200.00 -- not one of the cheapie
	  plastic units.
	o SCSI hard drive is an IBM 9.1 gigabyte.
	o Have one other device on the SCSI bus -- an external DDS4 HP
	  DAT drive.
	o SCSI HD is connected to internal 68 pin connector
	o HP DAT is connected to external connector...
	o The SCSI hard drive I would like to yank does not contain any
	  filesystem that my box can't live without... I can unmount it
	  and not cause any problems...

    I found some information about the scsiadd utility, but I am a bit 
leary to use it, since I already am doing funky stuff with this particular 
drive. It has XFS as the file system, and the whole drive is taken up by a 
BestCrypt container. scsiadd says its possible to lose data, so I have a 
feeling its doubly risky since I am doing some non-standard things on the 
drive.

    Anyone have any experience hot-swapping drives on an Adaptec 2940?

    If the 2940 is not capable of handling the use/abuse of hot-swapping, 
can anyone recommend a card that would handle it alright? Preferrably an 
Adaptec since I have had a lot of good luck with them, but if I need to 
look at another company for hot-swap capable cards, I will take a look...

Thanks,
Brad

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
