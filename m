From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: Is there hope for this drive?
Date: Tue, 03 Aug 2004 11:14:00 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3fz744m93.fsf@merlin.emma.line.org>
References: <410F20F6.40802@broadpark.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:63393 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S265285AbUHCJOC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Aug 2004 05:14:02 -0400
In-Reply-To: <410F20F6.40802@broadpark.no> (Helge Hafting's message of "Tue,
	03 Aug 2004 07:21:58 +0200")
List-Id: linux-scsi@vger.kernel.org
To: Helge Hafting <helge.hafting@broadpark.no>
Cc: linux-scsi@vger.kernel.org

Helge Hafting <helge.hafting@broadpark.no> writes:

> I recently got a couple of used IBM Ultrastar drives.
> They worked at first, but one of them suddenly stopped responding to
> read/write requests.
>
> "scsiinfo -i /dev/sdc" still provides info about it, but
> "scsiinfo -a /dev/sdc" provides no more information because every operation
> except the basic inquiry fails:
> "Unable to read Rigid Disk Geometry Page 04h" and so on.
>
> Partitioning and low-level formatting with scsiformat is impossible.

Some drives bootstrap (parts of) their firmware and settings from the
disk (and don't low-level format that area, for obvious reasons). 

You could still try schily's "sformat" but if that doesn't help either,
ditch the drive. I wouldn't use it for anything but /tmp or /var/cache
or perhaps as 3rd or 4th drive in a RAID1 (1:1 mirror).

HD Drives don't last eternally.

-- 
Matthias Andree

Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
