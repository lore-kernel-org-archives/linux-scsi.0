From: David Nedved <dnedved@nuvox.net>
Subject: how to change sector size on fibrechannel drives
Date: Thu, 13 Jun 2002 09:35:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020613093514.B25071@nuvox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from dnedved@localhost)
	by mung.nuvox.net (8.11.6/8.11.6) id g5DDZFQ29511
	for linux-scsi@vger.kernel.org; Thu, 13 Jun 2002 09:35:15 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

I've salvaged some drives from a MTI fibre channel RAID device, and I'm
trying to use them in linux 2.4.18.  When the scsi module loads, it sees
the drives, but reports them all as having the dreaded
"unsupported sector size 528" message.  All the searches I've done seem
to indicate a low-level format of the drives.   The FC card I'm using,
however (Emulex LP8000), doesn't seem to have an option for low-level
formatting in the BIOS.  I've also tried the lputil command that comes with
the driver, but it seems to have trouble finding the adapter, and it doesn't
seem to have any utilities that would help me anyway.

My fibre channel toys are rather limited, in other words, I don't have
any other controllers with which to low-level these drives.  In a pinch
I could probably find a wintel machine to throw the card into if I had to
in order to low-level format the drives, but this would be rather hard
since I don't have any windows machines.

Am I out of luck?  I wouldn't mind the inefficiency of only using 512
of the 528 bytes in each block if there's some way to override the
default setting... although I would much rather reformat them...

Oh, the drives are all ST136403FC drives if that matters.

Thanks in advance for any clues...

David
