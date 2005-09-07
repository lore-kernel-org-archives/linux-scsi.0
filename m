From: Yiannis Mavroukakis <jander@darthvader.us>
Subject: SCSI Raid card problems
Date: Wed, 07 Sep 2005 14:50:04 +0100
Message-ID: <431EF00C.2010403@darthvader.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail68.messagelabs.com ([193.109.255.67]:15016 "HELO
	mail68.messagelabs.com") by vger.kernel.org with SMTP
	id S932142AbVIGNtn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 09:49:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm running reiser4 on 2.6.11-mm4 at the moment. I compiled 2.6.13-mm1 
(and subsequently a few more kernel versions in-between)  as a 
replacement, only to find out that it blows up in my face when the root 
fs is due to be mounted:

VFS: Cannot open root device "801" or unknown-block
Unable to mount root fs on unknown-block (8,1)

The server has a NetRaid-1Si card set in raid-5 mode

lspci -v shows

02:01.1 I2O: Intel Corporation 80960RP [i960RP Microprocessor] (rev 05) 
(prog-if 01)
        Subsystem: Hewlett-Packard Company HP NetRAID-1Si
        Flags: bus master, fast Back2Back, medium devsel, latency 32, IRQ 17
        Memory at fe000000 (32-bit, prefetchable) [size=4M]
        Expansion ROM at <unassigned> [disabled] [size=32K]
        Capabilities: [80] Power Management version 2

dmesg output

scsi2:Found MegaRAID controller at 0xe081a000, IRQ:17
megaraid: [F :B ] detected 1 logical drives.
megaraid: channel[0] is raid.
scsi2 : LSI Logic MegaRAID F  254 commands 16 targs 4 chans 7 luns
scsi2: scanning scsi channel 0 for logical drives.
  Vendor: MegaRAID  Model: LD0 RAID0 26031R  Rev:   F
  Type:   Direct-Access                      ANSI SCSI revision: 02


Everything works fine on 2.6.11-mm4
Was anything changed in the legacy driver that would cause this?

Thank you,

Yiannis.

______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________
