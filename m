From: Brad Stockdale <bradsprt@greenepa.net>
Subject: Re: Hot swapping SCSI drives
Date: Fri, 31 Jan 2003 21:25:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.2.0.9.2.20030131211544.00ae6c98@pop.greenepa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from video.greenepa.net (nat-3.greenepa.net [65.173.148.35])
	by moe.greenepa.net (8.12.3/8.12.3) with ESMTP id h112PHxQ028091
	for <linux-scsi@vger.kernel.org>; Sat, 1 Feb 2003 02:25:18 GMT
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

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
	o Have a SCSI drive in a nice removable enclosure -- I forget exactly
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

