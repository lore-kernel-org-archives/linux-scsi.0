From: John Summerfield <summer@os2.ami.com.au>
Subject: Re: Weird generic scsi problems may be sorted out
Date: Sun, 07 Apr 2002 21:07:45 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204071307.g37D7kj03013@numbat.Os2.Ami.Com.Au>
References: <200204071237.g37CbQ714863@posh.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: Message from lukekendall@optushome.com.au
   of "Sun, 07 Apr 2002 22:37:25 +1000." <200204071237.g37CbQ714863@posh.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: lukekendall@optushome.com.au
Cc: Sydney Linux Users Group <slug@slug.org.au>, linux-scsi@vger.kernel.org, axboe@suse.de, dgilbert@interlog.com, summer@numbat.Os2.Ami.Com.Au

> I've been battling weird problems with my CD-RW drive for months now.
> It would work fine for days or weeks or months, then fail in weird ways,
> for days or weeks at a stretch.

Sounds like hardware, suppose it could be power. Why not take yourself 
off to the APC website and size yourself for a UPS?

There are formulae and charts to estimate your power consumption.

FWIW a pentium III uses about 30 watts (considerably less than my 
Athlon at 70+).

Cooling could be your problem too. Are things better soon after powerup?




> 
> Last time it worked was after installing and compiling 2.4.18 kernel,
> (still failed), and then under "ATA/IDE/MFM/RLL support", under "IDE,
> ATA and ATAPI Block devices", tried the "Use multi mode by default" Yes
> option in the kernel, and was suddenly able to blank a disc again and
> write a disc.
> 
> Then I tried to write a 2nd one and it failed again, like this:
> 
> Mar 24 16:38:07 posh kernel: SCSI bus is being reset for host 0 channel 0.
> Mar 24 16:38:07 posh kernel: scsi : aborting command due to timeout : pid 5940, scsi0, channel 0, id 0, lun 0 Test Unit Ready 00 00 00 00 00
> Mar 24 16:38:07 posh kernel: SCSI host 0 abort (pid 5940) timed out - resetting
> 
> Other errors over the months have included:
> 
>     o	Occasional timeouts on scsi commands.
>     o	scsi errors happening so fast that the generic scsi sub-system
> 	flooded /var/log/messages with errors, unstoppably, which was
> 	slowly filling the disc.  Only a reboot would ever stop that
> 	one.
>     o	Generic scsi module lock-ups.
>     o	HDD activity light on permanently, despite no disc activity.
>     o	Kernel crashes.  (/sbin/hdparm -d1 -X34 /dev/hdc and
>      	/sbin/hdparm -k1 /dev/hdc helped with this a LOT, but not 100%.)
>     o	Dead CD-RW and DVDROM drives - stone dead.  No power even during 
> 	boot.
> 
> Some of the PC sysadmins at work said that they thought that my system,
> which includes 3 hard disc drives, was under-powered with just a 250W
> power supply.
> 
> The store where I bought it said that a simple test (of my apparently
> dead Cd-RW and DVDROM), would be to unplug the power from the 3 drives,
> and power back up and see if the CD-RW and DVDROM drives got power.  I
> did that, and they did. (Interestingly, after plugging everything back
> together, *everything* is now working again.  But I don't knpow how long
> it will stay like that.)
> 
> So, it seems that a system with Pentium III 833MHz, CD-RW, DVDROM,
> floppy, graphics card, sound card, 4-IDE controller motherboard, 3
> HDDs, is slightly more than can be reliably run from a 250W power
> supply.  I.e., things will all work if you're lucky, but it's all just
> running at the edge of its capabilities, and you can get power on some
> busses dropping just enough to make various bits of hardware fail in
> weird ways.
> 
> This may even explain why I could never get the system to work when I
> plugged in the 4th HDD, and why the problem only seems to be shared by
> a few other people on the internet.
> 
> I'll be getting a 350W power supply this week sometime, and crossing my
> fingers that this is the real answer.
> 
> luke
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Cheers
John Summerfield

Microsoft's most solid OS: http://www.geocities.com/rcwoolley/

Note: mail delivered to me is deemed to be intended for me, for my 
disposition.

==============================
If you don't like being told you're wrong,
	be right!



