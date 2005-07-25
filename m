From: Jay Denebeim <denebeim@deepthot.org>
Subject: Re: Is it possible to support a sector size 8192
Date: Mon, 25 Jul 2005 12:37:53 -0700 (MST)
Message-ID: <Pine.LNX.4.63.0507251231290.23540@hotblack.deepthot.org>
References: <E1Dw26Z-0005m7-JQ@sledge.mossbank.org.uk> <200507231528.20356.jhml@gmx.net>
 <E1Dx8Jk-0006vH-Ra@sledge.mossbank.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from deepthot.org ([68.14.232.127]:57997 "EHLO dent.deepthot.org")
	by vger.kernel.org with ESMTP id S261474AbVGYTh6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 15:37:58 -0400
Received: from hotblack.deepthot.org ([192.168.12.6])
	by dent.deepthot.org with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.43)
	id 1Dx8lp-00048K-DT
	for linux-scsi@vger.kernel.org; Mon, 25 Jul 2005 12:37:49 -0700
In-Reply-To: <E1Dx8Jk-0006vH-Ra@sledge.mossbank.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

On Mon, 25 Jul 2005, Steve McIntyre wrote:

> Jay Denebeim wrote:
>>> I've already got the FUSE driver (udofs-1.1-92.i386.rpm, based on
>>> FUSE 1.4, is this current?!). It is nice for a standalone drive, but
>>> we use a SCSI robotic changer in conjunction with an HSM system
>>> (Legato DiskXtender 2.9) which needs some kind of direct access to
>>> the drive. It probes for /dev/nst*, but I guess /dev/sd* would also
>>> work.
>>
>> I'm a little confused here.  Tape devices have variable sector sizes.
>> I believe they're required to handle up to 64K in a unix environment.
>> The drives I work on go up to 256k.
>
> Tapes are different. The UDO drive that Johann was asking about is an
> optical _disk_ drive...

Yeah, I got that.  I wasn't going to say anything until he mentioned using 
the tape driver with it.  Is the UDO drive presenting itself as a tape or 
as a disk?

Jay

-- 
* Jay Denebeim  Moderator       rec.arts.sf.tv.babylon5.moderated *
* newsgroup submission address: b5mod@deepthot.org                *
* moderator contact address:    b5mod-request@deepthot.org        *
* personal contact address:     denebeim@deepthot.org             *
