From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [DOC PATCH]  T10/04-262r8
Date: Thu, 10 Nov 2005 02:44:42 -0500
Message-ID: <4372FA6A.3090903@pobox.com>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com>	 <4371BB82.3090208@gmx.de> <4371C557.80807@gmx.de> <4371F7C3.5080702@rtr.ca>	 <43720232.6090609@gmx.de> <4372172A.50003@gmx.de>	 <43721C3C.1010103@pobox.com> <1131553363.3271.1.camel@mulgrave> <4372E66F.5070802@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4372E66F.5070802@gmx.de>
Sender: linux-ide-owner@vger.kernel.org
To: t.schorpp@gmx.de
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

thomas schorpp wrote:
> James Bottomley wrote:
> 
>>>>#define	ATA_16		      0x85	/* 16-byte pass-thru */
>>>>#define	ATA_12		      0xa1	/* 12-byte pass-thru */
>>>
> 
> is this all, or do we have a preliminary SATL in kernel yet? cant find.

It's been there for more than a year:  drivers/scsi/libata-scsi.c


> how about full definitions of the pasthru cdb's in kernel structs and approbiate ioctls?

upstream as of 2.6.14-git


> for hdparm ata-security theres ide taskfile used, can scsi command sequences combined with ide taskfiles 
> which use own ioctls?
> are taskfiles needed for this in any case?

in libata, the HDIO ioctls are implemented by creating issuing a SCSI 
command (ATA passthru).

	Jeff


