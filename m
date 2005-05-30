From: |TEcHNO| <techno@punkt.pl>
Subject: Re: [SCSI] Driver broken in 2.6.x?
Date: Mon, 30 May 2005 10:19:23 +0200
Message-ID: <429ACC8B.5040503@punkt.pl>
References: <424EB65A.8010600@punkt.pl>	<20050525214047.731f56ef.akpm@osdl.org>	<4298FD42.10608@punkt.pl> <20050529180747.18b7fd9e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from box3.punkt.pl ([217.8.180.76]:49420 "HELO box.punkt.pl")
	by vger.kernel.org with SMTP id S261560AbVE3IXN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2005 04:23:13 -0400
In-Reply-To: <20050529180747.18b7fd9e.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

Hi,

> You cunningly removed linux-scsi from cc and replaced it with linux-kernel.
> Please don't do that.
Sorry, I forgot I sent it to scsi mailing list too. I'm realy sorry.

> As things have changed we'd need a new bug description please.
Ok.

> Please provide more details about the "hang".
I was scanning with xsane, there were two types of hang:
1. Acuire Preview
	This happend once, after it finished (or it seemd so), it was still in 
"waiting", as if something not happened to tell it finished.
So I chodes "cancel", and a few seconds later it hanged.

2. Scanning
	Once or twice it hanged at the begining or the end of scanning. No 
message, just hanged. XMMS was running so it juste entered the ususal 
sound hanged-and-looping. No reaction to any key.

3. Not a hang, but an instability.
	Basicly the beggining of accuire and scanning locks the machine up for 
a few seconds. Then teh scanning makes the computer less responsive. The 
X system is running at a few frames (around 3 to 8), there is noticable 
time before something happens on the screen. Sometimes the mouse starts 
moving in a mirrored way (left=right and/or up=down).

This sometimes leaves messages as this (the number is variable):
May 27 17:49:28 techno kernel: psmouse.c: Wheel Mouse at 
isa0060/serio1/input0 lost synchronization, throwing
3 bytes away.

> Under what circumstances? 
> 
> Does it oops?
Nothing left in the logs.

> What hardware and which driver?
2.6.12-rc5
00:0c.0 SCSI storage controller: DTC Technology Corp. Domex 536
         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin A routed to IRQ 11
         Region 0: I/O ports at d800 [size=32]

Scanner: ScanMagic 9636 S Plus (Xsane reports it to be Mustek ScanMagic 
12000 SP Plus)


> After it has "hung" is any information available from sysrq-P or sysrq-T?
Not checked, was in X anyway.


And yes, I'm using nvidia binary driver, but atleast 3rd "bug" on the 
list ir the same. It's also worh mentioning that the 3rd is sometimes 
jumpint into 2nd, so the first "lockup" part never ends.

Hope I can help you in any way possible.

-- 
pozdrawiam     |"Help me master, I felt the burning twilight behind
techno@punkt.pl|those gates of stell..." --Perihelion, Prophecy Sequence
