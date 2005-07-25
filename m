From: denebeim@deepthot.org (Jay Denebeim)
Subject: Re: Is it possible to support a sector size 8192
Date: Mon, 25 Jul 2005 15:43:57 +0000 (UTC)
Message-ID: <dc31bt$6ti$1@dent.deepthot.org>
References: <E1Dw26Z-0005m7-JQ@sledge.mossbank.org.uk> <200507231528.20356.jhml@gmx.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from deepthot.org ([68.14.232.127]:24034 "EHLO dent.deepthot.org")
	by vger.kernel.org with ESMTP id S261214AbVGYPoH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 11:44:07 -0400
Received: from news by dent.deepthot.org with local (Exim 4.43)
	id 1Dx57V-0001t3-Ma
	for linux-scsi@vger.kernel.org; Mon, 25 Jul 2005 08:43:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In article <200507231528.20356.jhml@gmx.net>,
Johann Hanne <jhml@gmx.net> wrote:
>Wow, an answer directly from Plasmon, that's nice. :-)

>I've already got the FUSE driver (udofs-1.1-92.i386.rpm, based on
>FUSE 1.4, is this current?!). It is nice for a standalone drive, but
>we use a SCSI robotic changer in conjunction with an HSM system
>(Legato DiskXtender 2.9) which needs some kind of direct access to
>the drive. It probes for /dev/nst*, but I guess /dev/sd* would also
>work.

I'm a little confused here.  Tape devices have variable sector sizes.
I believe they're required to handle up to 64K in a unix environment.
The drives I work on go up to 256k.

Jay
-- 
* Jay Denebeim  Moderator       rec.arts.sf.tv.babylon5.moderated *
* newsgroup submission address: b5mod@deepthot.org                *
* moderator contact address:    b5mod-request@deepthot.org        *
* personal contact address:     denebeim@deepthot.org             *
