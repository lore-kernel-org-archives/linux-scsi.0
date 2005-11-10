From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: [DOC PATCH]  T10/04-262r8
Date: Thu, 10 Nov 2005 07:19:27 +0100
Message-ID: <4372E66F.5070802@gmx.de>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com>	 <4371BB82.3090208@gmx.de> <4371C557.80807@gmx.de> <4371F7C3.5080702@rtr.ca>	 <43720232.6090609@gmx.de> <4372172A.50003@gmx.de>	 <43721C3C.1010103@pobox.com> <1131553363.3271.1.camel@mulgrave>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1131553363.3271.1.camel@mulgrave>
Sender: linux-ide-owner@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
>>> #define	ATA_16		      0x85	/* 16-byte pass-thru */
>>> #define	ATA_12		      0xa1	/* 12-byte pass-thru */
>>

is this all, or do we have a preliminary SATL in kernel yet? cant find.

how about full definitions of the pasthru cdb's in kernel structs and approbiate ioctls?

for hdparm ata-security theres ide taskfile used, can scsi command sequences combined with ide taskfiles 
which use own ioctls?
are taskfiles needed for this in any case?

for smartctl theres sg_cmnd_io() with (user definable?) struct io_hdr. 
so i would try passthru test first with smartctl by adding passthru opcode ATA_12 to smartctl struct scsi_cmd_io io_hdr.
later combining scsi ioparm structs and passthru opcode with usable contents of ide taskfile parm structs in user space.

the passthru cdb is also not clear enough to me:
according to sat-r06 spec byte 0-2 is scsi, 3-9 are ata, 11 is scsi, yes?

thx
tom
