From: Karsten Wiese <annabellesgarden@yahoo.de>
Subject: Help needed: No CD-Recording on 2.6.9 / 2.6.10 for TEAC CD-R55S @ sym53c8xx
Date: Tue, 14 Dec 2004 17:38:01 +0100
Message-ID: <200412141738.01763.annabellesgarden@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp001.mail.ukl.yahoo.com ([217.12.11.32]:64875 "HELO
	smtp001.mail.ukl.yahoo.com") by vger.kernel.org with SMTP
	id S261547AbULNQht (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2004 11:37:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: matthew@wil.cx

Hi,

IIRC stuff also ill behaved with 2.4 kernel and sym53c8xx_2 module.
2.4 kernel with ncr53c8xx module lets cdrecord work just fine. (Just verified with knoppix 3.4 boot cd.)
sym53c8xx is ok for reading from the two attached CD-Drives.
I tried 2.6.10-rc2-mm4 and the 2.6.9-1.681_FC3.

The (error-)messages while starting a cdrecord session:
>>>>>>
$ cdrecord dev=1,4,0 /mnt/hdd1/e1.iso
cdrecord: Input/output error. clear subcode: scsi sendcmd: no error
CDB:  E4 00 00 00 00 80 00 00 00 00 00 00
status: 0x2 (CHECK CONDITION)
Sense Bytes: 70 00 05 00 00 00 00 0A 00 00 00 00 24 00 00 C0
Sense Key: 0x5 Illegal Request, Segment 0
Sense Code: 0x24 Qual 0x00 (invalid field in cdb) Fru 0x0
Sense flags: Blk 0 (not valid) error refers to command part, bit ptr 0 (not valid) field ptr 0
cmd finished after 0.008s timeout 40s
cdrecord: Cannot open new session.
<<<<<<
>>>>>>
$ dmesg
SCSI error : <1 0 4 0> return code = 0x8000002
sr1: Current: sense key: Blank Check
    <<vendor>> ASC=0x8f ASCQ=0x0ASC=0x8f ASCQ=0x0
SCSI error : <1 0 4 0> return code = 0x8000002
sr1: Current: sense key: Blank Check
    <<vendor>> ASC=0x8f ASCQ=0x0ASC=0x8f ASCQ=0x0
sym0:4:0:phase change 2-3 10@01a91b60 resid=8.
<<<<<<
>>>>>>
$ lspci
00:00.0 Host bridge: VIA Technologies, Inc. VT82C693A/694x [Apollo PRO133x] (rev c4)
00:01.0 PCI bridge: VIA Technologies, Inc. VT82C598/694x [Apollo MVP3/Pro133x AGP]
00:07.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super South] (rev 40)
00:07.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:07.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 1a)
00:07.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 1a)
00:07.4 Bridge: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 40)
00:07.5 Multimedia audio controller: VIA Technologies, Inc. VT82C686 AC97 Audio Controller (rev 50)
00:09.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 03)
00:0a.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (rev 08)
00:0c.0 Network controller: PLX Technology, Inc. PCI <-> IOBus Bridge (rev 01)
01:00.0 VGA compatible controller: ATI Technologies Inc 3D Rage LT Pro AGP-133 (rev dc)
<<<<<<

If there is anything I can do to provide more infos, let me know.

thanks,
Karsten
