From: "Tim Wesemann" <timuel@voicenet.com>
Subject: Adaptec 2200S with aacraid won't do 64-bit
Date: Tue, 22 Feb 2005 15:27:06 -0500
Message-ID: <042101c5191c$f24209c0$de0167cf@voicenet.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Received: from mail08.voicenet.com ([207.103.0.34]:49407 "HELO
	mail08.voicenet.com") by vger.kernel.org with SMTP id S261237AbVBVU1g
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 15:27:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I apologize in advance if I'm sending this to the wrong place, but I see 
alot of people with adaptec cards and aacraid experience in the archives and 
was also pointed here by the README in the adaptec aacraid-1.1.5 source...

I'm using aacraid for my adaptec 2200S with a RAID5 configuration, in a 
PCI-X slot and I've spent two full days now trying to get it to run in 64 
bit mode to no avail. I've tried 2.4.29 with stock aacraid as well as 2.6.9 
with stock aacraid and also adaptec's aacraid-1.1.5 with 2.6.9. I am also 
running firmware version 7349 on the 2200S.

Here's my lspci output:

02:01.0 RAID bus controller: Adaptec AAC-RAID (rev 01)
        Subsystem: Adaptec 2200S (Vulcan)
        Flags: bus master, 66Mhz, slow devsel, latency 32, IRQ 24
        Memory at f0000000 (32-bit, prefetchable) [size=64M]
        Expansion ROM at <unassigned> [disabled] [size=32K]
        Capabilities: [80] Power Management version 2

The on-board (non-raid) AIC-7902 controller on my SuperMicro P4SC8 
motherboard runs in 64-bit mode without a hitch but I really need to use 
this 2200S...

Would anyone mind beating me with the clue stick or pointing me in the right 
direction? I need throughput!

TIA.

--
Tim Wesemann 

